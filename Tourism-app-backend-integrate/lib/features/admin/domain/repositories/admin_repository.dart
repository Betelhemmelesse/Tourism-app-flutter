import 'package:tourism_app/features/hotel/domain/repositories/hotel_repository.dart';
import 'package:tourism_app/features/hotel/data/models/hotel_converter.dart';
import '../models/destination.dart';
import '../models/hotel.dart' as admin;

class AdminRepository {
  final HotelRepository _hotelRepository;

  AdminRepository(this._hotelRepository);

  // Destinations
  Future<List<Destination>> getDestinations() async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  Future<Destination> addDestination(Destination destination) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    return destination;
  }

  Future<Destination> updateDestination(Destination destination) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    return destination;
  }

  Future<void> deleteDestination(String id) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
  }

  // Hotels
  Future<List<admin.Hotel>> getHotels() async {
    final hotels = await _hotelRepository.getHotels();
    return hotels.map((h) => HotelConverter.toAdminModel(h)).toList();
  }

  Future<admin.Hotel> addHotel(admin.Hotel hotel) async {
    final userHotel = HotelConverter.fromAdminModel(hotel);
    await _hotelRepository.addHotel(userHotel);
    return hotel;
  }

  Future<admin.Hotel> updateHotel(admin.Hotel hotel) async {
    final userHotel = HotelConverter.fromAdminModel(hotel);
    await _hotelRepository.updateHotel(userHotel);
    return hotel;
  }

  Future<void> deleteHotel(String id) async {
    await _hotelRepository.deleteHotel(id);
  }
} 