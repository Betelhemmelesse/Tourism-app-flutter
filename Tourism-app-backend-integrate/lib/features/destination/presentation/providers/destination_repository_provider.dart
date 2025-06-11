import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/destination/data/datasources/destination_remote_data_source.dart';
import 'package:tourism_app/features/destination/data/repositories/destination_repository_impl.dart';
import 'package:tourism_app/features/destination/domain/repositories/destination_repository.dart';

final destinationRemoteDataSourceProvider =
    Provider<DestinationRemoteDataSource>(
      (ref) => DestinationRemoteDataSourceImpl(),
    );

final destinationRepositoryProvider = Provider<DestinationRepository>((ref) {
  final remoteDataSource = ref.watch(destinationRemoteDataSourceProvider);
  return DestinationRepositoryImpl(remoteDataSource);
});
