import '../entities/hotel.dart';
import '../repositories/hotel_repository.dart';

class GetHotelsUsecase {
  final HotelRepository repository;

  GetHotelsUsecase(this.repository);

  Future<List<Hotel>> call() {
    return repository.getHotels();
  }
} 