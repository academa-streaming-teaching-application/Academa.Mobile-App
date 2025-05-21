import 'package:academa_streaming_platform/domain/repositories/live_streaming_repository.dart';
import '../../domain/entities/live_streaming_entity.dart';
import '../../domain/datasource/live_streaming_datasource.dart';

class LiveStreamingRepositoryImpl implements LiveStreamingRepository {
  final LiveStreamingDataSource _ds;
  LiveStreamingRepositoryImpl(this._ds);

  @override
  Future<LiveStreamingEntity> createSession(String title) {
    return _ds.createLiveSession(title);
  }

  @override
  Future<List<LiveStreamingEntity>> getSessions() {
    return _ds.fetchSessions();
  }
}
