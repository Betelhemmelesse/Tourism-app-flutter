import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/core/api/api_service.dart';
import 'package:tourism_app/features/hotel/data/datasources/hotel_remote_data_source.dart';
import 'package:tourism_app/features/hotel/data/repositories/hotel_repository_impl.dart';
import 'package:tourism_app/features/hotel/domain/repositories/hotel_repository.dart';
import '../../../../core/providers/shared_providers.dart';

final hotelRemoteDataSourceProvider = Provider<HotelRemoteDataSource>(
  (ref) => HotelRemoteDataSourceImpl(ref.watch(apiServiceProvider)),
);

final hotelRepositoryProvider = Provider<HotelRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final remoteDataSource = HotelRemoteDataSourceImpl(apiService);
  return HotelRepositoryImpl(remoteDataSource);
});
