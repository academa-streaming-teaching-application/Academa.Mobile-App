// data/models/live_session_dto.dart
class LiveSessionDto {
  final String rtmpUrl;
  final String liveStreamId;
  final String streamKey;
  final String playbackId;

  LiveSessionDto({
    required this.rtmpUrl,
    required this.liveStreamId,
    required this.streamKey,
    required this.playbackId,
  });

  factory LiveSessionDto.fromJson(Map<String, dynamic> json) {
    return LiveSessionDto(
      rtmpUrl: json['rtmpUrl'] as String,
      liveStreamId: json['liveStreamId'] as String,
      streamKey: json['streamKey'] as String,
      playbackId: json['playbackId'] as String,
    );
  }
}
