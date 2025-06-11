import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:3000/api/auth';
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  final SharedPreferences _prefs;

  AuthService(this._prefs);

  Future<Map<String, dynamic>> register(String email, String password, {String role = 'user'}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      await _saveAuthData(data);
      return data;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _saveAuthData(data);
      return data;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  Future<void> logout() async {
    await _prefs.remove(tokenKey);
    await _prefs.remove(userKey);
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final userStr = _prefs.getString(userKey);
    if (userStr != null) {
      return json.decode(userStr);
    }
    return null;
  }

  String? getToken() {
    return _prefs.getString(tokenKey);
  }

  bool get isAuthenticated => getToken() != null;

  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    await _prefs.setString(tokenKey, data['token']);
    await _prefs.setString(userKey, json.encode(data['user']));
  }
} 