import '../../domain/entities/destination.dart';
import '../../domain/repositories/destination_repository.dart';
import '../datasources/destination_remote_data_source.dart';

class DestinationRepositoryImpl implements DestinationRepository {
  final DestinationRemoteDataSource remoteDataSource;

  DestinationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Destination>> getDestinations() {
    return remoteDataSource.getDestinations();
  }

  @override
  Future<void> toggleFavorite(String destinationId) {
    return remoteDataSource.toggleFavorite(destinationId);
  }

  @override
  Future<List<Destination>> getFavoriteDestinations() {
    return remoteDataSource.getFavoriteDestinations();
  }
}
