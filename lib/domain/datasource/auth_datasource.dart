import 'dart:async';
import 'package:academa_streaming_platform/domain/entities/auth_entity.dart';

abstract class AuthDataSource {
  Future<AuthSession> signInWithGoogle({String role = 'student'});
  // Future<AuthSession> signInWithApple({String role = 'student'});
  Future<AuthSession> loginWithEmail(String email, String password);

  Future<String?> refreshAccessToken(String refreshToken);
  Future<void> logout(String refreshToken);
}
