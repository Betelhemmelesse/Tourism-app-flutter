import '../repositories/destination_repository.dart';
import '../entities/destination.dart';

class GetDestinationsUsecase {
  final DestinationRepository repository;

  GetDestinationsUsecase(this.repository);

  Future<List<Destination>> call() {
    return repository.getDestinations();
  }
}
