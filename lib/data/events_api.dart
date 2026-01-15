import 'dart:convert';

import 'package:http/http.dart' as http;

import 'events.dart';

class EventsApi {
  EventsApi({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? kApiBaseUrl;

  final http.Client _client;
  final String _baseUrl;

  Future<List<EventItem>> fetchEvents() async {
    final response = await _client.get(Uri.parse('$_baseUrl/eventos'));
    if (response.statusCode != 200) {
      throw Exception('Error al cargar eventos (${response.statusCode})');
    }
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((event) => EventItem.fromJson(event as Map<String, dynamic>))
        .toList();
  }
}

const String kApiBaseUrl = 'http://localhost:8000';
