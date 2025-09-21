import 'dart:convert';
import 'package:academa_streaming_platform/domain/datasource/auth_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/auth_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _dio; // baseDio (sin interceptor)
  final String googleWebClientId;

  AuthDataSourceImpl(this._dio, {required this.googleWebClientId});

  /// --- Bridge: backend JWT -> Firebase Custom Token -> FirebaseAuth signIn ---
  Future<void> _signInFirebaseWithCustomToken(String accessToken) async {
    // Pedimos el custom token al backend (ruta protegida con tu JWT)
    final resp = await _dio.post(
      '/api/v1/auth/firebase-token',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    if (resp.statusCode != 200 || resp.data == null) {
      throw Exception('No se pudo obtener el custom token de Firebase');
    }
    final token = (resp.data as Map)['token'] as String;
    await FirebaseAuth.instance.signInWithCustomToken(token);
  }

  @override
  Future<AuthSession> signInWithGoogle({String role = 'student'}) async {
    final signIn = GoogleSignIn.instance;

    await signIn.initialize(
      clientId: kIsWeb ? googleWebClientId : null,
      serverClientId: googleWebClientId,
    );

    final account = await signIn.authenticate();
    if (account == null) {
      throw Exception('Inicio con Google cancelado');
    }

    final googleAuth = await account.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) {
      throw Exception('Google no retornó idToken');
    }

    final resp = await _dio.post(
      '/api/v1/auth/oauth/exchange',
      data: {
        'provider': 'google',
        'idToken': idToken,
        'role': role,
      },
    );

    final session = AuthSession.fromMap(Map<String, dynamic>.from(resp.data));

    // 🔑 Bridge a Firebase Auth
    if (session.accessToken != null && session.accessToken!.isNotEmpty) {
      await _signInFirebaseWithCustomToken(session.accessToken!);
    }

    return session;
  }

  @override
  Future<AuthSession> loginWithEmail(String email, String password) async {
    final resp = await _dio.post(
      '/api/v1/auth/email/login',
      data: {'email': email, 'password': password},
    );

    final session = AuthSession.fromMap(Map<String, dynamic>.from(resp.data));

    // 🔑 Bridge a Firebase Auth
    if (session.accessToken != null && session.accessToken!.isNotEmpty) {
      await _signInFirebaseWithCustomToken(session.accessToken!);
    }

    return session;
  }

  @override
  Future<String?> refreshAccessToken(String refreshToken) async {
    final resp = await _dio.post(
      '/api/v1/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    final data = resp.data;
    if (data == null || data['accessToken'] == null) return null;

    // Nota: NO necesitas re-loguear Firebase aquí; la sesión de Firebase sigue viva.
    return data['accessToken'] as String;
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _dio
          .post('/api/v1/auth/logout', data: {'refreshToken': refreshToken});
    } catch (_) {/* no-op */}
    // Cierra sesión de Firebase también
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {/* no-op */}
  }
}
