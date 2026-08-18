import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final http.Client _client;
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient({http.Client? client}) {
    return _instance;
  }

  ApiClient._internal({http.Client? client})
      : _client = client ?? http.Client();

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final defaultHeaders = await _getHeaders();
    if (headers != null) {
      defaultHeaders.addAll(headers);
    }
    return await _client.get(url, headers: defaultHeaders);
  }

  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final defaultHeaders = await _getHeaders();
    if (headers != null) {
      defaultHeaders.addAll(headers);
    }
    final encodedBody = body is String ? body : jsonEncode(body);
    return await _client.post(url, headers: defaultHeaders, body: encodedBody);
  }
}
