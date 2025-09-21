import 'dart:async';
import 'package:academa_streaming_platform/data/datasource/watch_history_datasource_impl.dart';
import 'package:academa_streaming_platform/data/repositories/watch_history_repository_impl.dart';
import 'package:academa_streaming_platform/domain/entities/watch_history_entity.dart';
import 'package:academa_streaming_platform/domain/repositories/watch_history_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/provider/auth_repositoy_provider.dart';

final watchHistoryRepositoryProvider = Provider<WatchHistoryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return WatchHistoryRepositoryImpl(
    WatchHistoryDataSourceImpl(dio),
  );
});

class WatchHistoryParams {
  final int limit;
  final int offset;

  const WatchHistoryParams({
    this.limit = 10,
    this.offset = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchHistoryParams &&
          runtimeType == other.runtimeType &&
          limit == other.limit &&
          offset == other.offset;

  @override
  int get hashCode => limit.hashCode ^ offset.hashCode;
}

final watchHistoryProvider = FutureProvider.autoDispose
    .family<List<WatchHistoryEntity>, WatchHistoryParams>((ref, params) async {
  // Wait for auth tokens to be loaded before making the request
  final authTokens = ref.watch(authTokensProvider);

  // If no access token, return empty list (user not authenticated)
  if (authTokens.accessToken == null) {
    return <WatchHistoryEntity>[];
  }

  final repository = ref.watch(watchHistoryRepositoryProvider);

  final link = ref.keepAlive();
  Timer(const Duration(minutes: 5), link.close);

  return repository.getWatchHistory(
    limit: params.limit,
    offset: params.offset,
  );
});

final refreshWatchHistoryProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(watchHistoryProvider);
  };
});

final updateWatchProgressProvider = Provider<
    Future<void> Function({
      required String sessionId,
      required int currentTime,
      required int totalDuration,
    })>((ref) {
  final repository = ref.watch(watchHistoryRepositoryProvider);
  return repository.updateWatchProgress;
});
