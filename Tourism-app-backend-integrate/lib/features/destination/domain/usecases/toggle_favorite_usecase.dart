import '../repositories/destination_repository.dart';

class ToggleFavoriteUsecase {
  final DestinationRepository repository;

  ToggleFavoriteUsecase(this.repository);

  Future<void> call(String destinationId) {
    return repository.toggleFavorite(destinationId);
  }
}
