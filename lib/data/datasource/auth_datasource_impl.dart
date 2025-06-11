// data/datasource/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/datasource/auth_datasource.dart';
import '../../domain/entities/user_entity.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _dio;

  AuthDataSourceImpl(this._dio);

  @override
  Future<UserEntity> signInWithGoogle(String role) async {
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

    final response = await _dio.post(
      '/login',
      data: {
        'providerId': user.uid,
        'name': user.displayName,
        'lastName': user.displayName,
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
      lastName: response.data['lastName'],
      email: response.data['email'],
      image: response.data['image'] ?? '',
      role: response.data['role'],
    );
  }

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user!;

    final idToken = await user.getIdToken();

    final response = await _dio.post(
      '/sign-in',
      data: {
        'firebaseId': user.uid,
        'email': user.email,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $idToken',
      }),
    );

    return UserEntity(
      id: response.data['_id'],
      name: response.data['name'],
      lastName: response.data['lastName'],
      email: response.data['email'],
      image: response.data['image'] ?? '',
      role: response.data['role'],
    );
  }

  @override
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String lastName,
    required String role,
  }) async {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user!;
    final idToken = await user.getIdToken();

    final response = await _dio.post(
      '/sign-up',
      data: {
        'firebaseId': user.uid,
        'email': user.email,
        'name': name,
        'lastName': lastName,
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
      lastName: response.data['lastName'],
      email: response.data['email'],
      image: response.data['image'] ?? '',
      role: response.data['role'],
    );
  }
}
