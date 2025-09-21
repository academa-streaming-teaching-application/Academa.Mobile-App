import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';

abstract class ActiveLiveStreamsRepository {
  Future<List<LiveSessionEntity>> getActiveLiveStreams();
}