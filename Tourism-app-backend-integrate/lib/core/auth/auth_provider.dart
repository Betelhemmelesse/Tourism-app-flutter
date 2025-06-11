import 'package:flutter/material.dart';
import 'auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService) {
    _initializeAuth();
  }

  bool get isAuthenticated => _authService.isAuthenticated;
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAdmin => _user?['role'] == 'admin';

  Future<void> _initializeAuth() async {
    _user = await _authService.getCurrentUser();
    notifyListeners();
  }

  Future<bool> register(String email, String password, {String role = 'user'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _authService.register(email, password, role: role);
      _user = data['user'];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _authService.login(email, password);
      _user = data['user'];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  String? getToken() {
    return _authService.getToken();
  }
} 