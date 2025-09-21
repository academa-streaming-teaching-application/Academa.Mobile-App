import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';

abstract class ActiveLiveStreamsDataSource {
  Future<List<LiveSessionEntity>> getActiveLiveStreams();
}