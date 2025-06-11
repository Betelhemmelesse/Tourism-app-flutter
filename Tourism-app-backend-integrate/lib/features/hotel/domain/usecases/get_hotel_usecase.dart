import '../repositories/hotel_repository.dart';
import '../entities/hotel.dart';

class GetHotelUsecase {
  final HotelRepository repository;

  GetHotelUsecase(this.repository);

  Future<List<Hotel>> call() {
    return repository.getHotels();
  }
}
