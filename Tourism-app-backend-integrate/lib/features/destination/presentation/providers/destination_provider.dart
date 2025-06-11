import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/destination/domain/usecases/toggle_favorite_usecase.dart';
import 'package:tourism_app/features/destination/presentation/providers/usecase_provider.dart';
import '../../domain/entities/destination.dart';
import '../../domain/usecases/get_destinations_usecase.dart';

// States
final destinationProvider =
    StateNotifierProvider<DestinationNotifier, AsyncValue<List<Destination>>>((
      ref,
    ) {
      final getUseCase = ref.watch(getDestinationsUseCaseProvider);
      final toggleUseCase = ref.watch(toggleFavoriteUseCaseProvider);
      return DestinationNotifier(getUseCase, toggleUseCase);
    });

// Notifier
class DestinationNotifier extends StateNotifier<AsyncValue<List<Destination>>> {
  final GetDestinationsUsecase _getDestinationsUsecase;
  final ToggleFavoriteUsecase _toggleFavoriteUsecase;

  List<Destination> _allDestinations = [];

  DestinationNotifier(this._getDestinationsUsecase, this._toggleFavoriteUsecase)
    : super(const AsyncLoading()) {
    fetchDestinations();
  }

  Future<void> fetchDestinations() async {
    try {
      final destinations = await _getDestinationsUsecase();
      _allDestinations = destinations;
      state = AsyncData(destinations);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void searchDestinations(String query) {
    final filtered =
        _allDestinations.where((destination) {
          return destination.title.toLowerCase().contains(query.toLowerCase());
        }).toList();
    state = AsyncData(filtered);
  }

  Future<void> toggleFavorite(String destinationId) async {
    try {
      await _toggleFavoriteUsecase(destinationId);
      fetchDestinations(); // refresh list after toggle
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void clearSearch() {
    state = AsyncData(_allDestinations);
  }
}
