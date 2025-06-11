import '../../domain/entities/hotel.dart';

class HotelModel extends Hotel {
  final bool hasWifi;
  final bool hasPool;
  final bool hasRestaurant;
  final bool hasParking;

  HotelModel({
    required String id,
    required String name,
    required String location,
    required double price,
    required String imageUrl,
    required double rating,
    required List<String> services,
    required bool isFavorite,
    this.hasWifi = false,
    this.hasPool = false,
    this.hasRestaurant = false,
    this.hasParking = false,
  }) : super(
          id: id,
          name: name,
          location: location,
          price: price,
          imageUrl: imageUrl,
          rating: rating,
          services: services,
          isFavorite: isFavorite,
        );

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      services: (json['services'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isFavorite: json['isFavorite'] as bool? ?? false,
      hasWifi: json['hasWifi'] as bool? ?? false,
      hasPool: json['hasPool'] as bool? ?? false,
      hasRestaurant: json['hasRestaurant'] as bool? ?? false,
      hasParking: json['hasParking'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'services': services,
      'isFavorite': isFavorite,
      'hasWifi': hasWifi,
      'hasPool': hasPool,
      'hasRestaurant': hasRestaurant,
      'hasParking': hasParking,
    };
  }

  HotelModel copyWith({
    String? id,
    String? name,
    String? location,
    double? price,
    String? imageUrl,
    double? rating,
    List<String>? services,
    bool? isFavorite,
    bool? hasWifi,
    bool? hasPool,
    bool? hasRestaurant,
    bool? hasParking,
  }) {
    return HotelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      services: services ?? this.services,
      isFavorite: isFavorite ?? this.isFavorite,
      hasWifi: hasWifi ?? this.hasWifi,
      hasPool: hasPool ?? this.hasPool,
      hasRestaurant: hasRestaurant ?? this.hasRestaurant,
      hasParking: hasParking ?? this.hasParking,
    );
  }
}
