import 'package:academa_streaming_platform/domain/datasource/watch_history_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/watch_history_entity.dart';
import 'package:academa_streaming_platform/domain/repositories/watch_history_repository.dart';

class WatchHistoryRepositoryImpl implements WatchHistoryRepository {
  final WatchHistoryDataSource _dataSource;

  WatchHistoryRepositoryImpl(this._dataSource);

  @override
  Future<List<WatchHistoryEntity>> getWatchHistory({
    int limit = 10,
    int offset = 0,
  }) async {
    return await _dataSource.getWatchHistory(
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<void> updateWatchProgress({
    required String sessionId,
    required int currentTime,
    required int totalDuration,
  }) async {
    return await _dataSource.updateWatchProgress(
      sessionId: sessionId,
      currentTime: currentTime,
      totalDuration: totalDuration,
    );
  }
}