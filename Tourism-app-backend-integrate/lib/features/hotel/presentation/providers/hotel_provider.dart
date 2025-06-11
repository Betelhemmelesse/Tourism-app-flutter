import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/hotel/domain/entities/hotel.dart';
import 'package:tourism_app/features/hotel/domain/usecases/get_hotels_usecase.dart';
import 'package:tourism_app/features/hotel/domain/usecases/toggle_favorite_hotel_usecase.dart';
import 'package:tourism_app/features/hotel/presentation/providers/usecase_provider.dart';

final hotelProvider = StateNotifierProvider<HotelNotifier, AsyncValue<List<Hotel>>>((ref) {
  final getUseCase = ref.watch(getHotelsUseCaseProvider);
  final toggleUseCase = ref.watch(toggleFavoriteHotelUseCaseProvider);
  return HotelNotifier(getUseCase, toggleUseCase);
});

class HotelNotifier extends StateNotifier<AsyncValue<List<Hotel>>> {
  final GetHotelsUsecase _getHotelsUsecase;
  final ToggleFavoriteHotelUsecase _toggleFavoriteHotelUsecase;

  List<Hotel> _allHotels = [];

  HotelNotifier(this._getHotelsUsecase, this._toggleFavoriteHotelUsecase)
      : super(const AsyncLoading()) {
    fetchHotels();
  }

  Future<void> fetchHotels() async {
    try {
      final hotels = await _getHotelsUsecase();
      _allHotels = hotels;
      state = AsyncData(hotels);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> toggleFavoriteHotel(String hotelId) async {
    try {
      await _toggleFavoriteHotelUsecase(hotelId);
      fetchHotels(); // refresh list after toggle
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void searchHotels(String query) {
    if (query.isEmpty) {
      state = AsyncData(_allHotels);
      return;
    }

    final filtered = _allHotels
        .where((hotel) =>
            hotel.name.toLowerCase().contains(query.toLowerCase()) ||
            hotel.location.toLowerCase().contains(query.toLowerCase()))
        .toList();
    state = AsyncData(filtered);
  }

  void clearSearch() {
    state = AsyncData(_allHotels);
  }

  Future<void> refresh() async {
    await fetchHotels();
  }
}
