import 'dart:async';
import 'package:academa_streaming_platform/presentation/auth/provider/auth_repositoy_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:academa_streaming_platform/domain/entities/user_entity.dart';

/// Obtiene el usuario actual cuando hay accessToken.
final currentUserProvider =
    FutureProvider.autoDispose<UserEntity?>((ref) async {
  final tokens = ref.watch(authTokensProvider);
  final access = tokens.accessToken;
  if (access == null) return null;

  final link = ref.keepAlive();
  Timer(const Duration(minutes: 10), link.close);

  final dio = ref.read(dioProvider);
  try {
    final resp = await dio.get('/auth/me'); // tu backend
    final data = resp.data;

    final Map<String, dynamic> raw = (data is Map && data['user'] is Map)
        ? Map<String, dynamic>.from(data['user'])
        : Map<String, dynamic>.from(data as Map);

    return UserEntity(
      id: (raw['id'] ?? raw['_id'] ?? '').toString(),
      name: (raw['name'] ?? '').toString(),
      lastName: (raw['lastName'] ?? '').toString(),
      email: (raw['email'] ?? '').toString(),
      image: (raw['image'] ?? '').toString(),
      role: (raw['role'] ?? 'student').toString(),
    );
  } on DioException {
    return null;
  }
});

/// Solo expone el rol. Si no hay usuario, devuelve '' (invitado).
final currentUserRoleProvider = Provider.autoDispose<String>((ref) {
  final me = ref.watch(currentUserProvider);
  return me.maybeWhen(
    data: (u) => u?.role ?? '',
    orElse: () => '',
  );
});
