// data/models/live_session_dto.dart
class LiveStreamingDto {
  final String rtmpUrl;
  final String liveStreamId;
  final String streamKey;
  final String playbackId;

  LiveStreamingDto({
    required this.rtmpUrl,
    required this.liveStreamId,
    required this.streamKey,
    required this.playbackId,
  });

  factory LiveStreamingDto.fromJson(Map<String, dynamic> json) {
    return LiveStreamingDto(
      rtmpUrl: json['rtmpUrl'] as String,
      liveStreamId: json['liveStreamId'] as String,
      streamKey: json['streamKey'] as String,
      playbackId: json['playbackId'] as String,
    );
  }
}
