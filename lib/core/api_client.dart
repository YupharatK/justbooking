import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'api_config.dart';

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);
  
  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final _storage = const FlutterSecureStorage();
  final http.Client _client = http.Client();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<Map<String, String>> _getHeaders({bool requireAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (requireAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      String errorMessage = 'เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์';
      try {
        final body = jsonDecode(response.body);
        if (body['message'] != null) {
          errorMessage = body['message'];
        } else if (body['error'] != null) {
          errorMessage = body['error'];
        }
      } catch (_) {}
      throw ApiException(errorMessage, response.statusCode);
    }
  }

  Future<dynamic> get(String endpoint, {bool requireAuth = true}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);
    final response = await _client.get(url, headers: headers);
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body, bool requireAuth = true}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);
    final response = await _client.post(url, headers: headers, body: body != null ? jsonEncode(body) : null);
    return _handleResponse(response);
  }

  Future<dynamic> patch(String endpoint, {Map<String, dynamic>? body, bool requireAuth = true}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);
    final response = await _client.patch(url, headers: headers, body: body != null ? jsonEncode(body) : null);
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint, {bool requireAuth = true}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = await _getHeaders(requireAuth: requireAuth);
    final response = await _client.delete(url, headers: headers);
    return _handleResponse(response);
  }

  Future<dynamic> multipartPost(
      String endpoint,
      String fileField,
      File file, {
      bool requireAuth = true,
      Map<String, String>? extraFields,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final request = http.MultipartRequest('POST', url);
    final headers = await _getHeaders(requireAuth: requireAuth);
    headers.remove('Content-Type'); // Let http set multipart type
    request.headers.addAll(headers);

    if (extraFields != null) {
      request.fields.addAll(extraFields);
    }

    final ext = file.path.split('.').last.toLowerCase();
    MediaType? mediaType;
    if (ext == 'png') mediaType = MediaType('image', 'png');
    else if (ext == 'jpg' || ext == 'jpeg') mediaType = MediaType('image', 'jpeg');
    
    request.files.add(await http.MultipartFile.fromPath(
      fileField,
      file.path,
      contentType: mediaType,
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  Future<dynamic> multiMultipartPost(
      String endpoint,
      String fileField,
      List<File> files, {
      bool requireAuth = true,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final request = http.MultipartRequest('POST', url);
    final headers = await _getHeaders(requireAuth: requireAuth);
    headers.remove('Content-Type');
    request.headers.addAll(headers);

    for (var file in files) {
      final ext = file.path.split('.').last.toLowerCase();
      MediaType? mediaType;
      if (ext == 'png') mediaType = MediaType('image', 'png');
      else if (ext == 'jpg' || ext == 'jpeg') mediaType = MediaType('image', 'jpeg');
      
      request.files.add(await http.MultipartFile.fromPath(
        fileField,
        file.path,
        contentType: mediaType,
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }
}
