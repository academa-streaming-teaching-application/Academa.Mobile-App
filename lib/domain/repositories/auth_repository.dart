import 'package:academa_streaming_platform/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthSession> loginWithGoogle({String role = 'student'});
  Future<AuthSession> loginWithApple({String role = 'student'});
  Future<AuthSession> loginWithEmail(String email, String password);

  Future<String?> refresh(String refreshToken);
  Future<void> logout(String refreshToken);
}
