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
  static const String attendanceIdsKey = 'attendance_event_ids';

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
          await initialize(); // asegura init + timezone

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
    await _plugin.cancel(_dailyRecommendationsId);
  }

  Future<void> scheduleAttendanceNotifications(EventItem event) async {
    if (event.startsAt == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(attendanceRemindersKey) ?? true;
    if (!enabled) {
      return;
    }

    final now = tz.TZDateTime.now(tz.local);
    final eventStart = tz.TZDateTime(
      tz.local,
      event.startsAt!.year,
      event.startsAt!.month,
      event.startsAt!.day,
      event.startsAt!.hour,
      event.startsAt!.minute,
    );

    if (eventStart.isBefore(now)) {
      return;
    }

    final sameDayTenAm = tz.TZDateTime(
      tz.local,
      eventStart.year,
      eventStart.month,
      eventStart.day,
      10,
    );
    if (sameDayTenAm.isAfter(now)) {
      await _plugin.zonedSchedule(
        _attendanceNotificationId(event, 1),
        'TuPlan',
        'Hoy tienes: ${event.title}',
        sameDayTenAm,
        _attendanceDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }

    final oneHourBefore = eventStart.subtract(const Duration(hours: 1));
    if (oneHourBefore.isAfter(now)) {
      await _plugin.zonedSchedule(
        _attendanceNotificationId(event, 2),
        'TuPlan',
        'En 1 hora empieza: ${event.title}',
        oneHourBefore,
        _attendanceDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelAttendanceNotifications(EventItem event) async {
    await _plugin.cancel(_attendanceNotificationId(event, 1));
    await _plugin.cancel(_attendanceNotificationId(event, 2));
  }

  Future<void> cancelAttendanceNotificationsForIds(Iterable<String> ids) async {
    for (final id in ids) {
      final event = kEvents.firstWhere(
        (event) => eventId(event) == id,
        orElse: () => EventItem(
          title: '',
          date: '',
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
      await cancelAttendanceNotifications(event);
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

  int _attendanceNotificationId(EventItem event, int offset) {
    final hash = _stableHash(eventId(event));
    return (hash % 1000000) * 10 + offset;
  }

  int _stableHash(String value) {
    var hash = 0;
    for (final codeUnit in value.codeUnits) {
      hash = 0x1fffffff & (hash + codeUnit);
      hash = 0x1fffffff & (hash + ((hash & 0x0007ffff) << 10));
      hash ^= (hash >> 6);
    }
    hash = 0x1fffffff & (hash + ((hash & 0x03ffffff) << 3));
    hash ^= (hash >> 11);
    hash = 0x1fffffff & (hash + ((hash & 0x00003fff) << 15));
    return hash;
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
            final String timeZoneName = tzInfo.identifier; // <-- tiene que ser String

            try {
              tz.setLocalLocation(tz.getLocation(timeZoneName));
            } catch (_) {
              // Fallback por si el emulador devuelve algo raro/no soportado
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
