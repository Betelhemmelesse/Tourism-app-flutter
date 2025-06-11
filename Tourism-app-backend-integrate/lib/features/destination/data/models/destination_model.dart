import '../../domain/entities/destination.dart';

class DestinationModel extends Destination {
  DestinationModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    super.isFavorite,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imageUrl': imageUrl,
    'isFavorite': isFavorite,
  };

  DestinationModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return DestinationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
