import 'package:tourism_app/features/hotel/data/models/hotel_model.dart';
import '../entities/hotel.dart';

abstract class HotelRepository {
  Future<List<HotelModel>> getHotels();
  Future<void> toggleFavoriteHotel(String hotelId);
  Future<List<HotelModel>> getFavoriteHotels();
  Future<void> addHotel(Hotel hotel);
  Future<void> updateHotel(Hotel hotel);
  Future<void> deleteHotel(String hotelId);
}
