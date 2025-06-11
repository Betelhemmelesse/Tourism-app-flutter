import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import 'shared_providers.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  
  return ApiService(
    baseUrl: 'http://localhost:3000/api', // Update this with your backend URL
    getToken: () {
      return prefs.getString('token') ?? '';
    },
  );
}); 