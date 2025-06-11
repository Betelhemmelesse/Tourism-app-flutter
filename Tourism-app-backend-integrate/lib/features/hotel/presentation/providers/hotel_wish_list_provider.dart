import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/hotel/domain/entities/hotel.dart';
import 'package:tourism_app/features/hotel/presentation/providers/hotel_provider.dart';

final hotelWishlistProvider = Provider<List<Hotel>>((ref) {
  final hotelState = ref.watch(hotelProvider);
  return hotelState.when(
    data: (hotels) => hotels.where((h) => h.isFavorite).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});
