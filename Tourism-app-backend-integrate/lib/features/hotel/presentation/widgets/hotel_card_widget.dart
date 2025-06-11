import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/hotel/domain/entities/hotel.dart';
import 'package:tourism_app/features/hotel/presentation/providers/hotel_provider.dart';
import 'package:tourism_app/utils/image_utils.dart';

class HotelCardWidget extends StatelessWidget {
  final Hotel hotel;
  final WidgetRef ref;

  const HotelCardWidget({super.key, required this.hotel, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  ImageUtils.getProxyUrl(hotel.imageUrl),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Failed to load image',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    hotel.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: hotel.isFavorite ? Colors.red : Colors.black,
                  ),
                  onPressed: () {
                    ref
                        .read(hotelProvider.notifier)
                        .toggleFavoriteHotel(hotel.id);
                  },
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
                  children: List.generate(
                    hotel.rating.floor(),
                    (index) =>
                        const Icon(Icons.star, size: 20, color: Colors.orange),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hotel.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        hotel.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children:
                      hotel.services.map((service) {
                        final icon = _getServiceIcon(service);
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon, size: 20),
                            Text(service, style: const TextStyle(fontSize: 10)),
                          ],
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Price: \$${hotel.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String service) {
    switch (service.toLowerCase()) {
      case 'free wifi':
        return Icons.wifi;
      case 'swimming pool':
      case 'pool':
        return Icons.pool;
      case 'restaurant':
        return Icons.restaurant;
      case 'parking':
        return Icons.local_parking;
      case 'gym':
        return Icons.fitness_center;
      case 'spa':
        return Icons.spa;
      case 'breakfast':
        return Icons.free_breakfast;
      default:
        return Icons.check_circle_outline;
    }
  }
}
