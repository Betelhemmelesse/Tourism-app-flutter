class Hotel {
  final String id;
  final String name;
  final String location;
  final double price;
  final String imageUrl;
  final bool hasWifi;
  final bool hasPool;
  final bool hasRestaurant;
  final bool hasParking;

  const Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.imageUrl,
    this.hasWifi = false,
    this.hasPool = false,
    this.hasRestaurant = false,
    this.hasParking = false,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      hasWifi: json['hasWifi'] as bool? ?? false,
      hasPool: json['hasPool'] as bool? ?? false,
      hasRestaurant: json['hasRestaurant'] as bool? ?? false,
      hasParking: json['hasParking'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'price': price,
      'imageUrl': imageUrl,
      'hasWifi': hasWifi,
      'hasPool': hasPool,
      'hasRestaurant': hasRestaurant,
      'hasParking': hasParking,
    };
  }

  Hotel copyWith({
    String? id,
    String? name,
    String? location,
    double? price,
    String? imageUrl,
    bool? hasWifi,
    bool? hasPool,
    bool? hasRestaurant,
    bool? hasParking,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      hasWifi: hasWifi ?? this.hasWifi,
      hasPool: hasPool ?? this.hasPool,
      hasRestaurant: hasRestaurant ?? this.hasRestaurant,
      hasParking: hasParking ?? this.hasParking,
    );
  }
} 