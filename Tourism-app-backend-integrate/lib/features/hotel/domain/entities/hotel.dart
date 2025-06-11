class Hotel {
  final String id;
  final String name;
  final String location;
  final double price;
  final String imageUrl;
  final double rating;
  final List<String> services;
  final bool isFavorite;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.services,
    required this.isFavorite,
  });
}
