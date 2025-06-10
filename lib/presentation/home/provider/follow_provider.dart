// presentation/providers/follow_provider.dart
import 'package:academa_streaming_platform/presentation/auth/provider/auth_provider.dart';
import 'package:academa_streaming_platform/presentation/home/provider/class_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:academa_streaming_platform/presentation/providers/class_repository_provider.dart';

/*─────────────────────────── NOTIFIER ───────────────────────────*/

class _FollowNotifier extends AsyncNotifier<Set<String>> {
  late String? _userId;

  @override
  Future<Set<String>> build() async {
    // Escucha al usuario autenticado
    _userId = ref.watch(authProvider).user?.id;

    if (_userId == null) return <String>{};

    // Obtiene las clases y filtra las seguidas
    final classes = await ref.watch(fetchAllClassesProvider.future);
    return classes.where((c) => c.isFollowed).map((c) => c.id).toSet();
  }

  Future<void> toggle(String classId) async {
    // Si no hay user → nada que hacer
    if (_userId == null) return;

    final current = state.asData?.value ?? <String>{};
    final repo = ref.read(classRepositoryProvider);
    final isLiked = current.contains(classId);

    // ---------- UI optimista ----------
    final nextSet = {...current};
    isLiked ? nextSet.remove(classId) : nextSet.add(classId);
    state = AsyncData(nextSet);

    try {
      await repo.follow(
        classId,
        userId: _userId!, // enviamos uid porque aún no tenemos protect
        follow: !isLiked,
      );
    } catch (e) {
      // rollback en caso de error
      state = AsyncData(current);
      rethrow;
    }
  }
}

/*─────────────────────────── PROVIDER ───────────────────────────*/

final followProvider =
    AsyncNotifierProvider<_FollowNotifier, Set<String>>(_FollowNotifier.new);
