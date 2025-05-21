// domain/entities/live_model.dart
class LiveStreamingEntity {
  final String rtmpUrl;
  final String liveStreamId;
  final String streamKey;
  final String playbackId;

  LiveStreamingEntity({
    required this.rtmpUrl,
    required this.liveStreamId,
    required this.streamKey,
    required this.playbackId,
  });
}
