import 'package:academa_streaming_platform/domain/datasource/live_streaming_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:academa_streaming_platform/domain/repositories/live_streaming_repository.dart';

class LiveRepositoryImpl implements LiveRepository {
  final LiveDataSource _ds;
  LiveRepositoryImpl(this._ds);

  @override
  Future<LiveSessionEntity> startLiveSession(
    String subjectId,
    int classNumber,
    String title, {
    DateTime? startsAt,
  }) {
    return _ds.startLiveSession(
      subjectId: subjectId,
      classNumber: classNumber,
      title: title,
      startsAt: startsAt,
    );
  }

  @override
  Future<void> completeLiveSession(String sessionId) {
    return _ds.completeLiveSession(sessionId: sessionId);
  }
}
