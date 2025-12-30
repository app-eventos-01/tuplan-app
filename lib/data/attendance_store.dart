import 'package:shared_preferences/shared_preferences.dart';

const String attendingEventIdsKey = 'attending_event_ids';

Future<Set<String>> loadAttendingIds() async {
  final prefs = await SharedPreferences.getInstance();
  final savedIds = prefs.getStringList(attendingEventIdsKey) ?? [];
  return savedIds.toSet();
}

Future<bool> isAttending(String eventId) async {
  final ids = await loadAttendingIds();
  return ids.contains(eventId);
}

Future<Set<String>> toggleAttending(String eventId) async {
  final prefs = await SharedPreferences.getInstance();
  final savedIds = prefs.getStringList(attendingEventIdsKey) ?? [];
  final updatedIds = savedIds.toSet();
  if (updatedIds.contains(eventId)) {
    updatedIds.remove(eventId);
  } else {
    updatedIds.add(eventId);
  }
  await prefs.setStringList(attendingEventIdsKey, updatedIds.toList());
  return updatedIds;
}
