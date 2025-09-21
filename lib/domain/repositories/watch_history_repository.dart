import 'package:academa_streaming_platform/domain/entities/watch_history_entity.dart';

abstract class WatchHistoryRepository {
  Future<List<WatchHistoryEntity>> getWatchHistory({
    int limit = 10,
    int offset = 0,
  });

  Future<void> updateWatchProgress({
    required String sessionId,
    required int currentTime,
    required int totalDuration,
  });
}