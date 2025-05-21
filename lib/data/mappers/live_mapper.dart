// data/mappers/live_mapper.dart
import 'package:academa_streaming_platform/data/models/live_streaming_dto.dart';
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';

class LiveMapper {
  static LiveStreamingEntity fromBackendDto(LiveStreamingDto dto) {
    return LiveStreamingEntity(
      rtmpUrl: dto.rtmpUrl,
      liveStreamId: dto.liveStreamId,
      streamKey: dto.streamKey,
      playbackId: dto.playbackId,
    );
  }
}
