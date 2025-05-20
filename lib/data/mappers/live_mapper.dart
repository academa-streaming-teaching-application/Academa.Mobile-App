// data/mappers/live_mapper.dart
import 'package:academa_streaming_platform/data/models/live_session_dto.dart';
import 'package:academa_streaming_platform/domain/entities/live_model.dart';

class LiveMapper {
  static LiveModel fromBackendDto(LiveSessionDto dto) {
    return LiveModel(
      rtmpUrl: dto.rtmpUrl,
      liveStreamId: dto.liveStreamId,
      streamKey: dto.streamKey,
      playbackId: dto.playbackId,
    );
  }
}
