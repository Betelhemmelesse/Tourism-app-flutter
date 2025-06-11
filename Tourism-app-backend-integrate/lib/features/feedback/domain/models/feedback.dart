class Feedback {
  final String? id;
  final String content;
  final int rating;
  final DateTime? createdAt;

  Feedback({
    this.id,
    required this.content,
    required this.rating,
    this.createdAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['_id'],
      content: json['content'],
      rating: json['rating'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'rating': rating,
    };
  }
} 