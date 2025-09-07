import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';

abstract class LiveDataSource {
  Future<LiveSessionEntity> startLiveSession({
    required String subjectId,
    required int classNumber,
    DateTime? startsAt,
  });

  // ✅ nuevo
  Future<void> completeLiveSession({required String sessionId});
}
