// domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String name;
  final String lastName;
  final String email;
  final String image;
  final String role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.image,
    required this.role,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? lastName,
    String? email,
    String? image,
    String? role,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      image: image ?? this.image,
      role: role ?? this.role,
    );
  }
}
