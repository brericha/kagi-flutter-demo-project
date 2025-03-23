import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:kite_api_client/src/kite_api_exception.dart';
import 'package:kite_api_client/src/model/model.dart';

/// {@template kite_api_client}
/// Kite API client.
/// {@endtemplate}
class KiteApiClient {
  /// {@macro kite_api_client}
  KiteApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  // Optional passed Client to pass a mock Client for testing
  final http.Client _httpClient;

  String get _baseUrl => 'https://kite.kagi.com';

  String get _categoriesUrl => '$_baseUrl/kite.json';

  String get _eventsUrl => '$_baseUrl/onthisday.json';

  /// Get a List of [Category].
  Future<List<Category>> getCategories() async {
    try {
      final response = await _httpClient.get(Uri.parse(_categoriesUrl));

      if (response.statusCode == 200) {
        final json = _decodeBody(response.bodyBytes);
        final categories = Category.listOf(json['categories'] as List<dynamic>)
            // Filter out OnThisDay since that is a different type of category
            .where((e) => e.name != 'OnThisDay')
            .toList();
        return categories;
      } else {
        // TODO(brericha): More specific messages for different status codes
        throw KiteApiException('Invalid response code: ${response.statusCode}');
      }
    } on KiteApiException {
      rethrow;
    }
  }

  /// Get a [CategoryResponse] for a specific [Category] by its [Category.file].
  Future<CategoryResponse> getCategory(String file) async {
    try {
      final response = await _httpClient.get(Uri.parse('$_baseUrl/$file'));

      if (response.statusCode == 200) {
        final json = _decodeBody(response.bodyBytes);
        final categoryResponse = CategoryResponse.fromJson(json);
        return categoryResponse;
      } else {
        // TODO(brericha): More specific messages for different status codes
        throw KiteApiException('Invalid response code: ${response.statusCode}');
      }
    } on KiteApiException {
      rethrow;
    }
  }

  /// Get a list of [Event] for the current day.
  Future<List<Event>> getEvents() async {
    try {
      final response = await _httpClient.get(Uri.parse(_eventsUrl));

      if (response.statusCode == 200) {
        final json = _decodeBody(response.bodyBytes);
        return Event.listOf(json['events'] as List<dynamic>);
      } else {
        // TODO(brericha): More specific messages for different status codes
        throw KiteApiException('Invalid response code: ${response.statusCode}');
      }
    } on KiteApiException {
      rethrow;
    } on FormatException catch (_) {
      return [];
    }
  }

  Map<String, dynamic> _decodeBody(Uint8List bodyBytes) {
    final decodedBody = utf8.decode(
      bodyBytes,
      allowMalformed: true,
    );
    return jsonDecode(decodedBody) as Map<String, dynamic>;
  }
}
