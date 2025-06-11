import '../entities/destination.dart';
import '../repositories/destination_repository.dart';

class GetFavoriteDestinationsUseCase {
  final DestinationRepository repository;

  GetFavoriteDestinationsUseCase(this.repository);

  Future<List<Destination>> call() {
    return repository.getFavoriteDestinations();
  }
}
