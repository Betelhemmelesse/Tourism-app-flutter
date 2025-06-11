import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/provider_config.dart';
import '../../domain/models/hotel.dart';
import 'hotel_dialogs.dart';
import 'package:tourism_app/features/hotel/presentation/providers/hotel_provider.dart';

class HotelsTab extends ConsumerWidget {
  const HotelsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(adminProvider);
    final hotels = provider.hotels;

    if (hotels.isEmpty) {
      return const Center(
        child: Text('No hotels found. Add one using the + button.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hotels.length,
      itemBuilder: (context, index) {
        final hotel = hotels[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    hotel.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () => _editHotel(context, hotel),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _deleteHotel(context, hotel, ref),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          hotel.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '\$${hotel.price}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Text(hotel.location),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (hotel.hasWifi)
                          _buildAmenityIcon(Icons.wifi, 'WiFi'),
                        if (hotel.hasPool)
                          _buildAmenityIcon(Icons.pool, 'Pool'),
                        if (hotel.hasRestaurant)
                          _buildAmenityIcon(Icons.restaurant, 'Restaurant'),
                        if (hotel.hasParking)
                          _buildAmenityIcon(Icons.local_parking, 'Parking'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmenityIcon(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _editHotel(BuildContext context, Hotel hotel) {
    showDialog(
      context: context,
      builder: (context) => EditHotelDialog(hotel: hotel),
    );
  }

  Future<void> _deleteHotel(BuildContext context, Hotel hotel, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Hotel'),
        content: Text('Are you sure you want to delete ${hotel.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(adminProvider).deleteHotel(hotel.id);
        // Refresh the hotel list in the explore page
        await ref.read(hotelProvider.notifier).refresh();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hotel deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting hotel: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
} 