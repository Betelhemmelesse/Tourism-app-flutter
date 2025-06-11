import 'package:tourism_app/features/hotel/data/datasources/hotel_remote_data_source.dart';
import 'package:tourism_app/features/hotel/data/models/hotel_model.dart';
import 'package:tourism_app/features/hotel/domain/entities/hotel.dart';
import 'package:tourism_app/features/hotel/domain/repositories/hotel_repository.dart';
import 'package:tourism_app/features/hotel/data/models/hotel_converter.dart';
import 'package:tourism_app/features/admin/domain/models/hotel.dart' as admin;

class HotelRepositoryImpl implements HotelRepository {
  final HotelRemoteDataSource remoteDataSource;

  HotelRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HotelModel>> getHotels() {
    return remoteDataSource.getHotels();
  }

  @override
  Future<void> toggleFavoriteHotel(String hotelId) {
    return remoteDataSource.toggleFavoriteHotel(hotelId);
  }

  @override
  Future<List<HotelModel>> getFavoriteHotels() {
    return remoteDataSource.getFavoriteHotels();
  }

  @override
  Future<void> addHotel(Hotel hotel) {
    if (hotel is HotelModel) {
      return remoteDataSource.addHotel(hotel);
    }
    throw Exception('Hotel must be a HotelModel');
  }

  @override
  Future<void> updateHotel(Hotel hotel) {
    if (hotel is HotelModel) {
      return remoteDataSource.updateHotel(hotel);
    }
    throw Exception('Hotel must be a HotelModel');
  }

  @override
  Future<void> deleteHotel(String hotelId) {
    return remoteDataSource.deleteHotel(hotelId);
  }
}
