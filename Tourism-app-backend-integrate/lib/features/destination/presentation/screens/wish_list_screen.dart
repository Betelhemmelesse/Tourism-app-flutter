import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/destination/domain/entities/destination.dart';
import 'package:tourism_app/features/destination/presentation/widgets/destination_card_widget.dart';
import 'package:tourism_app/features/hotel/domain/entities/hotel.dart';
import 'package:tourism_app/features/hotel/presentation/widgets/hotel_card_widget.dart';
import '../providers/destination_provider.dart';
import 'package:tourism_app/features/hotel/presentation/providers/hotel_provider.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinationsAsync = ref.watch(destinationProvider);
    final hotelsAsync = ref.watch(hotelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(destinationProvider.notifier).fetchDestinations();
          ref.read(hotelProvider.notifier).fetchHotels();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                'Favorite Destinations',
                destinationsAsync.when(
                  data: (destinations) => destinations
                      .where((d) => d.isFavorite)
                      .map((destination) => DestinationCardWidget(
                            destination: destination,
                            ref: ref,
                          ))
                      .toList(),
                  loading: () => [const Center(child: CircularProgressIndicator())],
                  error: (error, stack) => [
                    Center(child: Text('Error: ${error.toString()}')),
                  ],
                ),
              ),
              _buildSection(
                'Favorite Hotels',
                hotelsAsync.when(
                  data: (hotels) => hotels
                      .where((h) => h.isFavorite)
                      .map((hotel) => HotelCardWidget(
                            hotel: hotel,
                            ref: ref,
                          ))
                      .toList(),
                  loading: () => [const Center(child: CircularProgressIndicator())],
                  error: (error, stack) => [
                    Center(child: Text('Error: ${error.toString()}')),
                  ],
                ),
              ),
              _buildEmptyState(destinationsAsync, hotelsAsync),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildEmptyState(
    AsyncValue<List<Destination>> destinationsAsync,
    AsyncValue<List<Hotel>> hotelsAsync,
  ) {
    if (destinationsAsync.isLoading || hotelsAsync.isLoading) {
      return const SizedBox.shrink();
    }

    final hasDestinations = destinationsAsync.whenOrNull(
          data: (destinations) => destinations.any((d) => d.isFavorite),
        ) ??
        false;

    final hasHotels = hotelsAsync.whenOrNull(
          data: (hotels) => hotels.any((h) => h.isFavorite),
        ) ??
        false;

    if (!hasDestinations && !hasHotels) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No favorites yet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Start adding destinations and hotels to your favorites!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
