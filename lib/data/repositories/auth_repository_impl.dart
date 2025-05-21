import '../../domain/datasource/auth_datasource.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> loginWithGoogle(String role) {
    return remoteDataSource.loginWithGoogle(role);
  }

  @override
  Future<UserEntity> loginWithEmail(String email, String password) {
    return remoteDataSource.loginWithEmail(email, password);
  }

  @override
  Future<UserEntity> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String role,
  }) {
    return remoteDataSource.registerWithEmail(
      email: email,
      password: password,
      name: name,
      role: role,
    );
  }
}
