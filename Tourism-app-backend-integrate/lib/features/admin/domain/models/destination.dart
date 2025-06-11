class Destination {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String location;

  const Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.location,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    print('Parsing JSON: $json'); // Debug log

    // Try to get ID from various possible field names
    final id = json['_id']?.toString() ?? 
               json['id']?.toString() ?? 
               '';
    
    // Get other fields with null safety
    final name = json['name']?.toString();
    final description = json['description']?.toString();
    final imageUrl = json['image']?.toString();
    final location = json['location']?.toString();
    
    // Parse price - handle both string and number formats
    final dynamic rawPrice = json['price'];
    double? price;
    if (rawPrice != null) {
      if (rawPrice is num) {
        price = rawPrice.toDouble();
      } else if (rawPrice is String) {
        // Remove any non-numeric characters except decimal point
        final cleanPrice = rawPrice.replaceAll(RegExp(r'[^\d.]'), '');
        price = double.tryParse(cleanPrice);
      }
    }

    // Validate required fields and provide default values if needed
    final validName = name?.trim() ?? '';
    final validDescription = description?.trim() ?? '';
    final validImageUrl = imageUrl?.trim() ?? '';
    final validLocation = location?.trim() ?? '';
    final validPrice = price ?? 0.0;

    // Check if any required field is empty
    final List<String> missingFields = [];
    if (validName.isEmpty) missingFields.add('name');
    if (validDescription.isEmpty) missingFields.add('description');
    if (validImageUrl.isEmpty) missingFields.add('imageUrl');
    if (validLocation.isEmpty) missingFields.add('location');
    if (validPrice <= 0) missingFields.add('price');

    if (missingFields.isNotEmpty) {
      throw FormatException(
        'Invalid destination data: Missing or invalid required fields: ${missingFields.join(', ')}\nReceived: $json'
      );
    }

    return Destination(
      id: id,
      name: validName,
      description: validDescription,
      imageUrl: validImageUrl,
      price: validPrice,
      location: validLocation,
    );
  }

  Map<String, dynamic> toJson() {
    // Format the data exactly as the backend expects
    final data = {
      'name': name.trim(),
      'description': description.trim(),
      'image': imageUrl.trim(),
      'price': price.toDouble(), // Ensure it's a double
      'location': location.trim(),
    };
    print('Converting to JSON: $data'); // Debug log
    return data;
  }

  Destination copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    String? location,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      location: location ?? this.location,
    );
  }

  @override
  String toString() {
    return 'Destination(id: $id, name: $name, description: $description, imageUrl: $imageUrl, price: $price, location: $location)';
  }
} 