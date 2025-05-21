// domain/repository/auth_repository.dart
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> loginWithGoogle(String role);
  Future<UserEntity> loginWithEmail(String email, String password);
  Future<UserEntity> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String role,
  });
}
