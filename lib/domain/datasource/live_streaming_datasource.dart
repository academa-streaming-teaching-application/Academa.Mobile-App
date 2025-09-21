import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';

abstract class LiveDataSource {
  Future<LiveSessionEntity> startLiveSession({
    required String subjectId,
    required int classNumber,
    String? title,
    DateTime? startsAt,
  });

  Future<void> completeLiveSession({required String sessionId});

  Future<LiveSessionEntity> getLiveSession({required String sessionId});

  Future<List<LiveSessionEntity>> getSubjectLiveSessions({
    required String subjectId,
    String? status,
  });
}
