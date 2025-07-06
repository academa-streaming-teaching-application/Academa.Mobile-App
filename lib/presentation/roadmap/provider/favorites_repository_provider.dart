import 'package:academa_streaming_platform/presentation/providers/class_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:academa_streaming_platform/domain/entities/class_entity.dart';
import 'package:academa_streaming_platform/presentation/auth/provider/auth_provider.dart';

final fetchEnrolledClassesProvider =
    FutureProvider.autoDispose<List<ClassEntity>>((ref) async {
  final repo = ref.watch(classRepositoryProvider);
  final user = ref.watch(authProvider.select((s) => s.user));

  debugPrint('[provider] auth.user = $user'); // 🔸

  if (user == null) {
    debugPrint('[provider] user == null → retorno []'); // 🔸
    return [];
  }

  final userId = user.id ?? '';
  debugPrint('[provider] userId = $userId'); // 🔸

  final classes = await repo.getEnrolledClassesByUser(userId);
  debugPrint('[provider] clases recibidas = ${classes.length}'); // 🔸
  return classes;
});
