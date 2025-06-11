import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/hotel/domain/usecases/get_favorite_hotels_usecase.dart';
import 'package:tourism_app/features/hotel/domain/usecases/get_hotels_usecase.dart';
import 'package:tourism_app/features/hotel/domain/usecases/toggle_favorite_hotel_usecase.dart';
import '../../domain/usecases/get_hotel_usecase.dart';
import 'package:tourism_app/features/hotel/presentation/providers/hotel_repository_provider.dart';

final getHotelsUseCaseProvider = Provider<GetHotelsUsecase>((ref) {
  final repository = ref.watch(hotelRepositoryProvider);
  return GetHotelsUsecase(repository);
});

final toggleFavoriteHotelUseCaseProvider = Provider<ToggleFavoriteHotelUsecase>((ref) {
  final repository = ref.watch(hotelRepositoryProvider);
  return ToggleFavoriteHotelUsecase(repository);
});

final getFavoriteHotelsUseCaseProvider = Provider<GetFavoriteHotelsUsecase>((ref) {
  final repository = ref.watch(hotelRepositoryProvider);
  return GetFavoriteHotelsUsecase(repository);
});
