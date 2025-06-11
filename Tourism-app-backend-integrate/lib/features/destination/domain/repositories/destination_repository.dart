import '../entities/destination.dart';

abstract class DestinationRepository {
  Future<List<Destination>> getDestinations();
  Future<void> toggleFavorite(String destinationId);
  Future<List<Destination>> getFavoriteDestinations();
}
