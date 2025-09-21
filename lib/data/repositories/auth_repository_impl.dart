import 'package:academa_streaming_platform/domain/datasource/auth_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/auth_entity.dart';
import 'package:academa_streaming_platform/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource remote;
  AuthRepositoryImpl(this.remote);

  @override
  Future<AuthSession> loginWithGoogle({String role = 'student'}) =>
      remote.signInWithGoogle(role: role);

  // @override
  // Future<AuthSession> loginWithApple({String role = 'student'}) =>
  //     remote.signInWithApple(role: role);

  @override
  Future<AuthSession> loginWithEmail(String email, String password) =>
      remote.loginWithEmail(email, password);

  @override
  Future<String?> refresh(String refreshToken) =>
      remote.refreshAccessToken(refreshToken);

  @override
  Future<void> logout(String refreshToken) => remote.logout(refreshToken);
}
