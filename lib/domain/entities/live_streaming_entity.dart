// domain/entities/live_model.dart
class LiveStreamingEntity {
  final String rtmpUrl;
  final String liveStreamId;
  final String streamKey;
  final String playbackId;
  final String title;
  final String teacherId;
  final String classId;
  final String createdAt;

  LiveStreamingEntity({
    required this.rtmpUrl,
    required this.liveStreamId,
    required this.streamKey,
    required this.playbackId,
    required this.title,
    required this.teacherId,
    required this.classId,
    required this.createdAt,
  });
}
