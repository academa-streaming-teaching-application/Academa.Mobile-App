// data/datasource/auth_datasource_impl.dart
import 'dart:convert';
import 'dart:math';

import 'package:academa_streaming_platform/domain/datasource/auth_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/auth_entity.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _dio;
  final String googleWebClientId; // pásalo desde dotenv

  AuthDataSourceImpl(this._dio, {required this.googleWebClientId});

  // ========= Helpers =========
  String _randomNonce(int length) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final rand = Random.secure();
    return List.generate(length, (_) => charset[rand.nextInt(charset.length)])
        .join();
  }

  String _sha256(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // ========= Google =========
  @override
  Future<AuthSession> signInWithGoogle({String role = 'student'}) async {
    // v7: usar instancia + initialize() + authenticate()
    final signIn = GoogleSignIn.instance;

    // IMPORTANTE:
    // - En Android/iOS usa serverClientId con tu *Web Client ID* para que el
    //   idToken tenga aud = Web Client ID (lo que valida tu backend).
    // - En web, clientId debe ser ese mismo Web Client ID.
    await signIn.initialize(
      clientId: kIsWeb ? googleWebClientId : null,
      serverClientId: googleWebClientId,
    );

    final account = await signIn.authenticate();
    if (account == null) {
      throw Exception('Inicio con Google cancelado');
    }

    final googleAuth = await account.authentication;
    final idToken = googleAuth.idToken; // v7 ya NO expone accessToken
    if (idToken == null) {
      throw Exception('Google no retornó idToken');
    }

    // Intercambio en tu backend (no Firebase Admin):
    final resp = await _dio.post(
      '/auth/oauth/exchange',
      data: {
        'provider': 'google',
        'idToken': idToken,
        'role': role, // política: app => student
      },
    );
    return AuthSession.fromMap(Map<String, dynamic>.from(resp.data));
  }

  // ========= Apple =========
  @override
  Future<AuthSession> signInWithApple({String role = 'student'}) async {
    // nonce para protegerte de replay; el backend validará sha256(rawNonce)
    final rawNonce = _randomNonce(32);
    final hashedNonce = _sha256(rawNonce);

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: const [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw Exception('Apple no retornó identityToken');
    }

    final resp = await _dio.post(
      '/auth/oauth/exchange',
      data: {
        'provider': 'apple',
        'idToken': idToken,
        'nonce': rawNonce, // tu backend valida sha256(nonce)
        'role': role,
        'fullName': {
          'givenName': credential.givenName,
          'familyName': credential.familyName,
        },
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
