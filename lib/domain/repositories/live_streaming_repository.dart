import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';

abstract class LiveRepository {
  Future<LiveSessionEntity> startLiveSession(
    String subjectId,
    int classNumber, {
    DateTime? startsAt,
  });

  // ✅ nuevo
  Future<void> completeLiveSession(String sessionId);
}
