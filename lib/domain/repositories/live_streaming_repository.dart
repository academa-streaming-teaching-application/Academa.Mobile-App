import '../entities/live_streaming_entity.dart';

abstract class LiveStreamingRepository {
  Future<LiveStreamingEntity> createSession(String title);
  Future<List<LiveStreamingEntity>> getSessions();
}
