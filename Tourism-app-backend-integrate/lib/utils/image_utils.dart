import 'package:flutter/foundation.dart';

class ImageUtils {
  static String getProxyUrl(String imageUrl) {
    if (!kIsWeb) return imageUrl;
    
    // For web platform, use a CORS proxy
    // You can use any of these services:
    // 1. cors.bridged.cc
    // 2. corsproxy.io
    // 3. cors-anywhere.herokuapp.com
    // Note: For production, you should set up your own proxy server
    return 'https://cors.bridged.cc/$imageUrl';
  }

  static bool isValidImageUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
} 