import '../entities/user_entity.dart';

abstract class AuthDataSource {
  Future<UserEntity> signInWithGoogle(String role);
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String role,
  });
}
