import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/events.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String dailyRecommendationsKey =
      'daily_recommendations_enabled';
  static const String attendanceRemindersKey =
      'attendance_reminders_enabled';

  static const int _dailyRecommendationsId = 1001;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings);
    await _configureLocalTimeZone();
    _initialized = true;
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    if (Platform.isIOS || Platform.isMacOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await _plugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  Future<void> showTestNow() async {
    await initialize();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'tuplan_test',
        'Tests',
        channelDescription: 'Canal de pruebas',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      9999,
      'TuPlan (TEST)',
      'Si ves esto, permisos/canal OK ✅',
      details,
    );
  }

  Future<void> updateDailyRecommendations({
    required List<EventItem> events,
    required Set<String> favoriteIds,
  }) async {
    await initialize();
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(dailyRecommendationsKey) ?? false;
    if (!enabled) {
      await _plugin.cancel(_dailyRecommendationsId);
      return;
    }

    final recommendations = _buildRecommendations(events, favoriteIds);
    if (recommendations.isEmpty) {
      await _plugin.cancel(_dailyRecommendationsId);
      return;
    }

    final titles = recommendations.take(2).map((event) => event.title).toList();
    final body = titles.join(' · ');

    await _plugin.zonedSchedule(
      _dailyRecommendationsId,
      'TuPlan: Recomendaciones',
      body,
      _nextTenAm(),
      _recommendationsDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyRecommendations() async {
    await initialize();
    await _plugin.cancel(_dailyRecommendationsId);
  }

  Future<void> scheduleEventNotifications(EventItem event) async {
    await initialize();
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(attendanceRemindersKey) ?? true;
    if (!enabled) {
      return;
    }

    final now = tz.TZDateTime.now(tz.local);
    final eventStart = tz.TZDateTime(
      tz.local,
      event.startsAt.year,
      event.startsAt.month,
      event.startsAt.day,
      event.startsAt.hour,
      event.startsAt.minute,
    );

    if (eventStart.isBefore(now)) {
      return;
    }

    final baseId = _attendanceNotificationBaseId(event);
    final zone = _eventZone(event);

    final sameDayTenAm = tz.TZDateTime(
      tz.local,
      eventStart.year,
      eventStart.month,
      eventStart.day,
      10,
    );
    if (sameDayTenAm.isAfter(now)) {
      await _plugin.zonedSchedule(
        baseId,
        'TuPlan: Evento hoy',
        'Hoy tienes: ${event.title}. Revisa detalles en la app.',
        sameDayTenAm,
        _attendanceDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }

    final oneHourBefore = eventStart.subtract(const Duration(hours: 1));
    if (oneHourBefore.isAfter(now)) {
      await _plugin.zonedSchedule(
        baseId + 1,
        'TuPlan: Tu evento empieza pronto',
        '${event.title} en $zone comienza en 1 hora.',
        oneHourBefore,
        _attendanceDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelEventNotifications(EventItem event) async {
    await initialize();
    final baseId = _attendanceNotificationBaseId(event);
    await _plugin.cancel(baseId);
    await _plugin.cancel(baseId + 1);
  }

  Future<void> cancelAttendanceNotificationsForIds(Iterable<String> ids) async {
    await initialize();
    for (final id in ids) {
      final event = kEvents.firstWhere(
        (event) => eventId(event) == id,
        orElse: () => EventItem(
          title: '',
          date: '',
          startsAt: DateTime.now(),
          location: '',
          category: '',
          price: '',
          description: '',
          isFeatured: false,
        ),
      );
      if (event.title.isEmpty) {
        continue;
      }
      await cancelEventNotifications(event);
    }
  }

  List<EventItem> _buildRecommendations(
    List<EventItem> events,
    Set<String> favoriteIds,
  ) {
    if (favoriteIds.isEmpty) {
      final featured =
          events.where((event) => event.isFeatured).toList(growable: false);
      final nonFeatured =
          events.where((event) => !event.isFeatured).toList(growable: false);
      return [...featured, ...nonFeatured];
    }

    final Map<String, int> categoryCounts = {};
    for (final event in events) {
      if (favoriteIds.contains(eventId(event))) {
        categoryCounts[event.category] =
            (categoryCounts[event.category] ?? 0) + 1;
      }
    }

    if (categoryCounts.isEmpty) {
      return events
          .where((event) => !favoriteIds.contains(eventId(event)))
          .toList();
    }

    final maxCount = categoryCounts.values.reduce((a, b) => a > b ? a : b);
    final topCategories = categoryCounts.entries
        .where((entry) => entry.value == maxCount)
        .map((entry) => entry.key)
        .toSet();

    final recommendations = events
        .where(
          (event) =>
              topCategories.contains(event.category) &&
              !favoriteIds.contains(eventId(event)),
        )
        .toList();

    if (recommendations.isNotEmpty) {
      return recommendations;
    }

    return events
        .where((event) => !favoriteIds.contains(eventId(event)))
        .toList();
  }

  int _attendanceNotificationBaseId(EventItem event) {
    return eventId(event).hashCode.abs() % 100000;
  }

  String _eventZone(EventItem event) {
    return event.location.split(',').first.trim();
  }

  tz.TZDateTime _nextTenAm() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      10,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();

    final tzInfo = await FlutterTimezone.getLocalTimezone();
    final String timeZoneName = tzInfo.identifier;

    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  NotificationDetails get _recommendationsDetails {
    const androidDetails = AndroidNotificationDetails(
      'tuplan_recommendations',
      'Recomendaciones diarias',
      channelDescription: 'Recomendaciones de eventos para ti',
      importance: Importance.defaultImportance,
    );
    const iosDetails = DarwinNotificationDetails();
    return const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  NotificationDetails get _attendanceDetails {
    const androidDetails = AndroidNotificationDetails(
      'tuplan_attendance',
      'Recordatorios de asistencia',
      channelDescription: 'Avisos para eventos confirmados',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    return const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }
}
