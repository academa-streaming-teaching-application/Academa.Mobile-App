import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/user_repository.dart';
import 'auth_repositoy_provider.dart';

/*───────────────────────────── STATE ────────────────────────────────*/
class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  final UserEntity? user;
  final bool isLoading;
  final String? error;

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/*──────────────────────── NOTIFIER ─────────────────────────*/
class AuthNotifier extends Notifier<AuthState> {
  late AuthRepository _repo;

  @override
  AuthState build() {
    _repo = ref.read(authRepositoryProvider);
    return const AuthState();
  }

  /*-------------- HELPER ----------------*/ // ++ NUEVO
  String _friendlyMessage(DioException e) {
    // ++ NUEVO
    final data = e.response?.data; // ++ NUEVO
    if (data is Map && data['message'] is String) {
      // ++ NUEVO
      return data['message'] as String; // ++ NUEVO
    } // ++ NUEVO
    return 'Error de red: ${e.message}'; // ++ NUEVO
  } // ++ NUEVO

  /*-------------- ACCIONES ----------------*/

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repo.loginWithEmail(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(error: _friendlyMessage(e), isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repo.registerWithEmail(
        email: email,
        password: password,
        name: name,
        role: role,
      );
      state = state.copyWith(user: user, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(error: _friendlyMessage(e), isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> loginWithGoogle(String role) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repo.loginWithGoogle(role);
      state = state.copyWith(user: user, isLoading: false);
    } on DioException catch (e) {
      state = state.copyWith(error: _friendlyMessage(e), isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    state = const AuthState();
  }
}

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
