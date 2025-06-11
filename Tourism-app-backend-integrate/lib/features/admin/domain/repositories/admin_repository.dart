import '../models/destination.dart';
import '../models/hotel.dart';

abstract class AdminRepository {
  // Destinations
  Future<List<Destination>> getDestinations();
  Future<Destination> addDestination(Destination destination);
  Future<Destination> updateDestination(Destination destination);
  Future<void> deleteDestination(String id);

  // Hotels
  Future<List<Hotel>> getHotels();
  Future<Hotel> addHotel(Hotel hotel);
  Future<Hotel> updateHotel(Hotel hotel);
  Future<void> deleteHotel(String id);
} 