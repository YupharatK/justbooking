import 'dart:io';
import '../core/api_client.dart';
import '../models/user.dart';

class AuthService {
  final ApiClient _api = ApiClient();

  Future<String> login(String email, String password) async {
    final response = await _api.post('/api/auth/login', body: {
      'email': email,
      'password': password,
    }, requireAuth: false);
    
    final token = response['token'];
    await _api.saveToken(token);
    return token;
  }

  Future<String> register({
    required String email,
    required String password,
    required String role,
    required String firstName,
    required String lastName,
    String? nickname,
    String? phone,
    String? address,
    File? profileImage,
  }) async {
    dynamic response;
    final body = {
      'email': email,
      'password': password,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      if (nickname != null) 'nickname': nickname,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
    };
    
    if (profileImage != null) {
      // Use multipartPost for uploading image
      response = await _api.multipartPost(
        '/api/auth/register',
        'profileImage', // Field name for the file, change if your API uses 'image' or 'avatar'
        profileImage,
        extraFields: body,
        requireAuth: false,
      );
    } else {
      // Use standard post
      response = await _api.post('/api/auth/register', body: body, requireAuth: false);
    }
    
    final token = response['token'];
    await _api.saveToken(token);
    return token;
  }

  Future<User> getCurrentUser() async {
    final response = await _api.get('/api/auth/me');
    return User.fromJson(response['user']);
  }

  Future<User> updateProfile(Map<String, dynamic> data) async {
    final response = await _api.patch('/api/profile', body: data);
    return User.fromJson(response['user']);
  }

  Future<void> logout() async {
    await _api.deleteToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _api.getToken();
    return token != null;
  }
}
