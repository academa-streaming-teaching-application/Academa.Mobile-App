// data/datasource/auth_datasource_impl.dart
import 'dart:convert';
import 'dart:math';

import 'package:academa_streaming_platform/domain/datasource/auth_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/auth_entity.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _dio;
  final String googleWebClientId; // pásalo desde dotenv

  AuthDataSourceImpl(this._dio, {required this.googleWebClientId});

  // ========= Google =========
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

    print('googleAuth' + idToken!);

    if (idToken == null) {
      throw Exception('Google no retornó idToken');
    }

    // Intercambio en tu backend (no Firebase Admin):
    final resp = await _dio.post(
      '/api/v1/auth/oauth/exchange',
      data: {
        'provider': 'google',
        'idToken': idToken,
        'role': role,
      },
    );
    return AuthSession.fromMap(Map<String, dynamic>.from(resp.data));
  }

  // ========= Email / Password (tu endpoint actual) =========
  @override
  Future<AuthSession> loginWithEmail(String email, String password) async {
    final resp = await _dio.post(
      '/auth/email/login',
      data: {'email': email, 'password': password},
    );
    return AuthSession.fromMap(Map<String, dynamic>.from(resp.data));
  }

  // ========= Refresh / Logout =========
  @override
  Future<String?> refreshAccessToken(String refreshToken) async {
    final resp =
        await _dio.post('/auth/refresh', data: {'refreshToken': refreshToken});
    final data = resp.data;
    if (data == null || data['accessToken'] == null) return null;
    return data['accessToken'] as String;
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post('/auth/logout', data: {'refreshToken': refreshToken});
    } catch (_) {/* no-op */}
  }
}
