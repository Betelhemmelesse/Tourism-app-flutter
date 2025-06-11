import 'package:tourism_app/features/hotel/domain/entities/hotel.dart';
import 'package:tourism_app/features/hotel/domain/repositories/hotel_repository.dart';

class GetFavoriteHotelsUsecase {
  final HotelRepository repository;

  GetFavoriteHotelsUsecase(this.repository);

  Future<List<Hotel>> call() {
    return repository.getFavoriteHotels();
  }
}
