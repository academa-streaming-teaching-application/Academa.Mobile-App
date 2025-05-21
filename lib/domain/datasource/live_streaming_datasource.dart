import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';

abstract class LiveStreamingDataSource {
  Future<LiveStreamingEntity> createLiveSession(String title);

  Future<List<LiveStreamingEntity>> fetchSessions();
}
