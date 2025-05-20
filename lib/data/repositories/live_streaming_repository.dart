import 'package:academa_streaming_platform/domain/repositories/live_streaming_repositories.dart';
import '../../domain/entities/live_model.dart';
import '../../domain/datasource/live_streaming_datasource.dart';

class LiveStreamingRepositoryImpl implements LiveStreamingRepository {
  final LiveStreamingDataSource _ds;
  LiveStreamingRepositoryImpl(this._ds);

  @override
  Future<LiveModel> createSession(String title) {
    return _ds.createLiveSession(title);
  }

  @override
  Future<List<LiveModel>> getSessions() {
    return _ds.fetchSessions();
  }
}
