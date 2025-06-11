import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/destination/domain/entities/destination.dart';
import 'package:tourism_app/features/destination/presentation/providers/destination_provider.dart';
import 'package:tourism_app/features/hotel/domain/entities/hotel.dart';
import 'package:tourism_app/features/hotel/presentation/providers/hotel_provider.dart';

final wishlistProvider = Provider<List<Object>>((ref) {
  final destinationState = ref.watch(destinationProvider);
  final hotelState = ref.watch(hotelProvider);

  final wishlistItems = <Object>[];

  destinationState.whenData(
    (destinations) =>
        wishlistItems.addAll(destinations.where((d) => d.isFavorite)),
  );

  hotelState.whenData(
    (hotels) => wishlistItems.addAll(hotels.where((h) => h.isFavorite)),
  );

  return wishlistItems;
});
