import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final String Function() getToken;

  ApiService({
    required this.baseUrl,
    required this.getToken,
  });

  Map<String, String> get _headers {
    final token = getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Generic HTTP methods
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to fetch data: ${response.body}');
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: json.encode(data),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to post data: ${response.body}');
  }

  // Destinations
  Future<List<dynamic>> getDestinations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/destinations'),
        headers: _headers,
      );
      print('Get destinations response: ${response.body}'); // Debug log
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load destinations: ${response.body}');
    } catch (e) {
      print('Error getting destinations: $e'); // Debug log
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addDestination(Map<String, dynamic> destination) async {
    try {
      // Format the data exactly as the backend expects
      final formattedData = {
        'name': destination['name'],
        'description': destination['description'],
        'image': destination['imageUrl'],
        'price': destination['price'],
        'location': destination['location'],
      };

      print('Making request to: $baseUrl/destinations'); // Debug log
      print('Request body: ${json.encode(formattedData)}'); // Debug log
      print('Headers: $_headers'); // Debug log

      final response = await http.post(
        Uri.parse('$baseUrl/destinations'),
        headers: _headers,
        body: json.encode(formattedData),
      );

      print('Response status code: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData == null) {
          throw Exception('Server returned empty response');
        }
        return responseData;
      }

      // Try to parse error message from response
      String errorMessage;
      try {
        final errorData = json.decode(response.body);
        if (errorData is Map) {
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          } else if (errorData.containsKey('error')) {
            errorMessage = errorData['error'];
          } else {
            errorMessage = json.encode(errorData); // Include full error response
          }
        } else {
          errorMessage = response.body;
        }
      } catch (_) {
        errorMessage = 'Failed to add destination (Status: ${response.statusCode})\nResponse: ${response.body}';
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      print('Error in addDestination: $e'); // Debug log
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateDestination(String id, Map<String, dynamic> destination) async {
    final response = await http.put(
      Uri.parse('$baseUrl/destinations/$id'),
      headers: _headers,
      body: json.encode(destination),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to update destination');
  }

  Future<void> deleteDestination(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/destinations/$id'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete destination');
    }
  }

  // Hotels
  Future<List<dynamic>> getHotels() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hotels'),
        headers: _headers,
      );
      print('Get hotels response: ${response.body}'); // Debug log
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load hotels: ${response.body}');
    } catch (e) {
      print('Error getting hotels: $e'); // Debug log
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addHotel(Map<String, dynamic> hotel) async {
    try {
      // Format the data exactly as the backend expects
      final formattedData = {
        'name': hotel['name'],
        'location': hotel['location'],
        'price': hotel['price'],
        'imageUrl': hotel['imageUrl'],
        'hasWifi': hotel['hasWifi'],
        'hasPool': hotel['hasPool'],
        'hasRestaurant': hotel['hasRestaurant'],
        'hasParking': hotel['hasParking'],
      };

      print('Making request to: $baseUrl/hotels'); // Debug log
      print('Request body: ${json.encode(formattedData)}'); // Debug log
      print('Headers: $_headers'); // Debug log

      final response = await http.post(
        Uri.parse('$baseUrl/hotels'),
        headers: _headers,
        body: json.encode(formattedData),
      );

      print('Response status code: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData == null) {
          throw Exception('Server returned empty response');
        }
        return responseData;
      }

      // Try to parse error message from response
      String errorMessage;
      try {
        final errorData = json.decode(response.body);
        if (errorData is Map) {
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          } else if (errorData.containsKey('error')) {
            errorMessage = errorData['error'];
          } else {
            errorMessage = json.encode(errorData); // Include full error response
          }
        } else {
          errorMessage = response.body;
        }
      } catch (_) {
        errorMessage = 'Failed to add hotel (Status: ${response.statusCode})\nResponse: ${response.body}';
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      print('Error in addHotel: $e'); // Debug log
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateHotel(String id, Map<String, dynamic> hotel) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/hotels/$id'),
        headers: _headers,
        body: json.encode(hotel),
      );
      print('Update hotel response: ${response.body}'); // Debug log
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to update hotel: ${response.body}');
    } catch (e) {
      print('Error updating hotel: $e'); // Debug log
      rethrow;
    }
  }

  Future<void> deleteHotel(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/hotels/$id'),
        headers: _headers,
      );
      print('Delete hotel response: ${response.body}'); // Debug log
      if (response.statusCode != 200) {
        throw Exception('Failed to delete hotel: ${response.body}');
      }
    } catch (e) {
      print('Error deleting hotel: $e'); // Debug log
      rethrow;
    }
  }
} 