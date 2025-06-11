class Destination {
  final String id;
  final String title;
  final String imageUrl;
  final bool isFavorite;

  Destination({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.isFavorite = false,
  });
}
