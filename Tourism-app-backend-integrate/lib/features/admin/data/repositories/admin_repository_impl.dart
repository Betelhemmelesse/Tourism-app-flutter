import '../../domain/models/destination.dart';
import '../../domain/models/hotel.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../../core/api/api_service.dart';

class AdminRepositoryImpl implements AdminRepository {
  final ApiService _apiService;

  AdminRepositoryImpl(this._apiService);

  @override
  Future<List<Destination>> getDestinations() async {
    try {
      final response = await _apiService.getDestinations();
      return response.map((json) => Destination.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load destinations: ${e.toString()}');
    }
  }

  @override
  Future<Destination> addDestination(Destination destination) async {
    try {
      final response = await _apiService.addDestination(destination.toJson());
      return Destination.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add destination: ${e.toString()}');
    }
  }

  @override
  Future<Destination> updateDestination(Destination destination) async {
    try {
      final response = await _apiService.updateDestination(destination.id, destination.toJson());
      return Destination.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update destination: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteDestination(String id) async {
    try {
      await _apiService.deleteDestination(id);
    } catch (e) {
      throw Exception('Failed to delete destination: ${e.toString()}');
    }
  }

  @override
  Future<List<Hotel>> getHotels() async {
    try {
      final response = await _apiService.getHotels();
      return response.map((json) => Hotel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load hotels: ${e.toString()}');
    }
  }

  @override
  Future<Hotel> addHotel(Hotel hotel) async {
    try {
      final response = await _apiService.addHotel(hotel.toJson());
      return Hotel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add hotel: ${e.toString()}');
    }
  }

  @override
  Future<Hotel> updateHotel(Hotel hotel) async {
    try {
      final response = await _apiService.updateHotel(hotel.id, hotel.toJson());
      return Hotel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update hotel: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteHotel(String id) async {
    try {
      await _apiService.deleteHotel(id);
    } catch (e) {
      throw Exception('Failed to delete hotel: ${e.toString()}');
    }
  }
} 