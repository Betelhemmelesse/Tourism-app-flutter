import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(String name, String email, String password, {String role = 'user'});
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const String baseUrl = 'http://localhost:3000/api/auth';
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  final SharedPreferences _prefs;

  AuthRemoteDataSourceImpl(this._prefs);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
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
        if (data['user'] == null) {
          throw Exception('Invalid response format: user data is missing');
        }
        await _saveAuthData(data);
        return UserModel.fromJson(data['user']);
      }
      
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to login');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> signup(String name, String email, String password, {String role = 'user'}) async {
    try {
      if (name.isEmpty) {
        throw Exception('Name is required');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['user'] == null) {
          throw Exception('Invalid response format: user data is missing');
        }
        await _saveAuthData(data);
        return UserModel.fromJson(data['user']);
      }
      
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to register');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _prefs.remove(tokenKey);
    await _prefs.remove(userKey);
  }

  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    if (data['token'] != null) {
      await _prefs.setString(tokenKey, data['token']);
    }
    if (data['user'] != null) {
      await _prefs.setString(userKey, json.encode(data['user']));
    }
  }
}
