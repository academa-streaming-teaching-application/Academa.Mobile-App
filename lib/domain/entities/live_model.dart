// domain/entities/live_model.dart
class LiveModel {
  final String rtmpUrl;
  final String liveStreamId;
  final String streamKey;
  final String playbackId;

  LiveModel({
    required this.rtmpUrl,
    required this.liveStreamId,
    required this.streamKey,
    required this.playbackId,
  });
}
