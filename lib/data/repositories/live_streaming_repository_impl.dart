import 'package:academa_streaming_platform/domain/entities/saved_asset_entity.dart';
import 'package:academa_streaming_platform/domain/repositories/live_streaming_repository.dart';
import '../../domain/entities/live_streaming_entity.dart';
import '../../domain/datasource/live_streaming_datasource.dart';

class LiveStreamingRepositoryImpl implements LiveStreamingRepository {
  final LiveStreamingDataSource _ds;
  LiveStreamingRepositoryImpl(this._ds);

  @override
  Future<LiveStreamingEntity> createSession({
    required String classId, // ✅ changed: added
    required String teacherId, // ✅ changed: added
    required String title, // ✅ changed: added
  }) {
    return _ds.createLiveSession(
      classId: classId, // ✅ changed
      teacherId: teacherId, // ✅ changed
      title: title, // ✅ changed
    );
  }
}
