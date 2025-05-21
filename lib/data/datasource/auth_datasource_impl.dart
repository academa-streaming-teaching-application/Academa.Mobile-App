// data/datasource/auth_remote_datasource.dart
import 'package:academa_streaming_platform/data/models/user_model_dto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/datasource/auth_datasource.dart';
import '../../domain/entities/user_entity.dart';

class AuthRemoteDataSource implements AuthDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  @override
  Future<UserEntity> loginWithGoogle(String role) async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final user = userCredential.user!;
    final idToken = await user.getIdToken();

    final response = await dio.post(
      // TODO: CHANGE THIS FOR THE ENV VARIABLE
      'http://10.0.2.2:3000/api/v1/auth/login',
      data: {
        'providerId': user.uid,
        'name': user.displayName,
        'email': user.email,
        'image': user.photoURL,
        'role': role,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $idToken',
      }),
    );

    return UserEntity(
      id: response.data['_id'],
      name: response.data['name'],
      email: response.data['email'],
      image: response.data['image'] ?? '',
      role: response.data['role'],
    );
  }

  @override
  Future<UserEntity> loginWithEmail(String email, String password) async {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user!;
    final idToken = await user.getIdToken();

    final response = await dio.post(
      'http://10.0.2.2:3000/api/v1/auth/login',
      data: {
        'providerId': user.uid,
        'email': user.email,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $idToken',
      }),
    );

    return UserEntity(
      id: response.data['_id'],
      name: response.data['name'],
      email: response.data['email'],
      image: response.data['image'] ?? '',
      role: response.data['role'],
    );
  }

  @override
  Future<UserEntity> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user!;
    final idToken = await user.getIdToken();

    final response = await dio.post(
      'http://10.0.2.2:3000/api/v1/auth/login',
      data: {
        'providerId': user.uid,
        'email': user.email,
        'name': name,
        'image': null,
        'role': role,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $idToken',
      }),
    );

    return UserEntity(
      id: response.data['_id'],
      name: response.data['name'],
      email: response.data['email'],
      image: response.data['image'] ?? '',
      role: response.data['role'],
    );
  }
}
