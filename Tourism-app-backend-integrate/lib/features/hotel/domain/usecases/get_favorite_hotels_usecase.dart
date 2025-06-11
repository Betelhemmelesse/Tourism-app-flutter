import '../entities/hotel.dart';
import '../repositories/hotel_repository.dart';

class GetFavoriteHotelsUsecase {
  final HotelRepository repository;

  GetFavoriteHotelsUsecase(this.repository);

  Future<List<Hotel>> call() {
    return repository.getFavoriteHotels();
  }
} 