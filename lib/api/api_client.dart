import 'dart:convert';

import 'package:http/http.dart' as http;

import '../services/local_storage_service.dart';

/// A reusable HTTP client for communicating with the backend API.
///
/// This class:
/// - Automatically attaches the authentication token.
/// - Encodes request bodies as JSON.
/// - Decodes JSON responses.
/// - Handles common API errors.
class ApiClient {
  /// Base URL for all customer-related API endpoints.
  static const String baseUrl = "https://dmk-hatchery.vercel.app/api/customer/";

  /// Local storage service used to retrieve the saved authentication token.
  final LocalStorageService localStorageService;

  ApiClient({
    required this.localStorageService,
  });

  /// Builds the request headers.
  ///
  /// Includes:
  /// - JSON content type
  /// - Bearer authentication token
  /// - Keep-Alive connection
  Future<Map<String, String>> _headers() async {
    final token = await localStorageService.readToken();

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
      'Connection': 'Keep-Alive',
    };
  }

  /// Parses the HTTP response.
  ///
  /// Returns the decoded JSON for successful requests.
  ///
  /// Throws an [Exception] with the API error message when the
  /// request fails.
  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    throw Exception(
      body['error'] ??
          body['message'] ??
          'Request failed (${response.statusCode})',
    );
  }

  /// Sends a POST request.
  ///
  /// Example:
  /// ```dart
  /// apiClient.postData('/login', {
  ///   'email': email,
  ///   'password': password,
  /// });
  /// ```
  Future<Map<String, dynamic>> postData(
    String uri,
    dynamic data,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl$uri'),
      headers: await _headers(),
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  /// Sends a GET request.
  ///
  /// Example:
  /// ```dart
  /// apiClient.getData('/profile');
  /// ```
  Future<Map<String, dynamic>> getData(String uri) async {
    final response = await http.get(
      Uri.parse('$baseUrl$uri'),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  /// Sends a PUT request.
  ///
  /// Useful for updating existing resources.
  Future<Map<String, dynamic>> putData(
    String uri,
    dynamic data,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl$uri'),
      headers: await _headers(),
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  /// Sends a DELETE request.
  ///
  /// Useful for removing resources.
  Future<Map<String, dynamic>> deleteData(String uri) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$uri'),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }
}
