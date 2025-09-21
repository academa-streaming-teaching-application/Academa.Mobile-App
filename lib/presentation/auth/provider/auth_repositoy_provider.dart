import 'dart:async';
import 'package:academa_streaming_platform/data/datasource/auth_datasource_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:academa_streaming_platform/data/repositories/auth_repository_impl.dart';
import 'package:academa_streaming_platform/domain/repositories/auth_repository.dart';

// -------------------- Secure Storage --------------------
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);

// -------------------- Auth Tokens State --------------------
class AuthTokens {
  final String? accessToken;
  final String? refreshToken;
  const AuthTokens({this.accessToken, this.refreshToken});

  AuthTokens copyWith({String? accessToken, String? refreshToken}) =>
      AuthTokens(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
      );
}

class AuthTokensNotifier extends StateNotifier<AuthTokens> {
  final FlutterSecureStorage storage;
  AuthTokensNotifier(this.storage) : super(const AuthTokens()) {
    _load();
  }

  Future<void> _load() async {
    final at = await storage.read(key: 'accessToken');
    final rt = await storage.read(key: 'refreshToken');
    state = AuthTokens(accessToken: at, refreshToken: rt);
  }

  Future<void> set(String access, String refresh) async {
    await storage.write(key: 'accessToken', value: access);
    await storage.write(key: 'refreshToken', value: refresh);
    state = AuthTokens(accessToken: access, refreshToken: refresh);
  }

  Future<void> setAccessOnly(String access) async {
    await storage.write(key: 'accessToken', value: access);
    state = state.copyWith(accessToken: access);
  }

  Future<void> clear() async {
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'refreshToken');
    state = const AuthTokens();
  }
}

final authTokensProvider =
    StateNotifierProvider<AuthTokensNotifier, AuthTokens>((ref) {
  return AuthTokensNotifier(ref.read(secureStorageProvider));
});

// -------------------- Base Dio (sin interceptores) --------------------
// Se usa para AuthRepository (evita ciclo con el dio con interceptor).
final baseDioProvider = Provider<Dio>((ref) {
  final baseUrl = dotenv.env['API_BASE_URL']!;
  return Dio(BaseOptions(baseUrl: baseUrl));
});

// -------------------- Auth Repository (usa baseDio) --------------------
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final baseDio = ref.read(baseDioProvider);
  final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID']!;
  return AuthRepositoryImpl(
    AuthDataSourceImpl(baseDio, googleWebClientId: webClientId),
  );
});

// -------------------- Dio principal (con interceptor de Auth) --------------------
final dioProvider = Provider<Dio>((ref) {
  final baseUrl = dotenv.env['API_BASE_URL']!;
  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final at = ref.read(authTokensProvider).accessToken;
      if (at != null) {
        options.headers['Authorization'] = 'Bearer $at';
      }
      handler.next(options);
    },
    onError: (e, handler) async {
      if (e.response?.statusCode == 401) {
        final tokens = ref.read(authTokensProvider);
        final rt = tokens.refreshToken;
        if (rt != null) {
          try {
            final repo = ref.read(authRepositoryProvider); // usa baseDio
            final newAccess = await repo.refresh(rt);
            if (newAccess != null) {
              await ref
                  .read(authTokensProvider.notifier)
                  .setAccessOnly(newAccess);
              final req = e.requestOptions;
              req.headers['Authorization'] = 'Bearer $newAccess';
              final res = await dio.fetch(req);
              return handler.resolve(res);
            } else {
              await ref.read(authTokensProvider.notifier).clear();
            }
          } catch (_) {
            await ref.read(authTokensProvider.notifier).clear();
          }
        }
      }
      handler.next(e);
    },
  ));

  return dio;
});
