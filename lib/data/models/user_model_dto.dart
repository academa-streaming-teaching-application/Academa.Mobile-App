// data/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String image;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      image: json['image'] ?? '',
      role: json['role'] as String,
    );
  }
}
