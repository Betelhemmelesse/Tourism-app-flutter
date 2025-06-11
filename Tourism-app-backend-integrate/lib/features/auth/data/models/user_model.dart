import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id, 
    required super.name, 
    required super.email,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '', // Handle both MongoDB _id and regular id
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 
    'name': name, 
    'email': email,
    'role': role,
  };
}
