import 'user_entity.dart';

class AuthSession {
  final String accessToken;
  final String refreshToken;
  final UserEntity user;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthSession.fromMap(Map<String, dynamic> json) {
    String _s(dynamic v) => v == null ? '' : v.toString();
    final userMap = Map<String, dynamic>.from(json['user'] ?? {});

    return AuthSession(
      accessToken: _s(json['accessToken']),
      refreshToken: _s(json['refreshToken']),
      user: UserEntity(
        id: _s(userMap['id'] ?? userMap['_id']),
        name: _s(userMap['name']),
        lastName: _s(userMap['lastName']),
        email: _s(userMap['email']),
        image: _s(userMap['image']),
        role: _s(
            userMap['role'].toString().isEmpty ? 'student' : userMap['role']),
      ),
    );
  }
}
