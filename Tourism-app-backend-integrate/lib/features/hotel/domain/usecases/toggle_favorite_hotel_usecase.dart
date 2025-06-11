import '../repositories/hotel_repository.dart';

class ToggleFavoriteHotelUsecase {
  final HotelRepository repository;

  ToggleFavoriteHotelUsecase(this.repository);

  Future<void> call(String hotelId) {
    return repository.toggleFavoriteHotel(hotelId);
  }
}
