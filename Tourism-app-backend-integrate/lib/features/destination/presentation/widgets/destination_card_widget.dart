import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/destination/domain/entities/destination.dart';
import 'package:tourism_app/features/destination/presentation/providers/destination_provider.dart';
import 'package:tourism_app/utils/image_utils.dart';

class DestinationCardWidget extends StatelessWidget {
  const DestinationCardWidget({
    super.key,
    required this.destination,
    required this.ref,
  });
  final Destination destination;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              ImageUtils.getProxyUrl(destination.imageUrl),
              height: 250,
              width: double.infinity,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    destination.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    destination.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: destination.isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    ref
                        .read(destinationProvider.notifier)
                        .toggleFavorite(destination.id);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
