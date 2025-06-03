// data/models/live_session_dto.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class LiveStreamingDto {
  final String rtmpUrl;
  final String liveStreamId;
  final String streamKey;
  final String playbackId;
  final String title;
  final String teacherId;
  final String classId;
  final DateTime createdAt;

  LiveStreamingDto({
    required this.rtmpUrl,
    required this.liveStreamId,
    required this.streamKey,
    required this.playbackId,
    required this.title,
    required this.teacherId,
    required this.classId,
    required this.createdAt,
  });

  factory LiveStreamingDto.fromJson(Map<String, dynamic> json) {
    return LiveStreamingDto(
      rtmpUrl: json['rtmpUrl'] as String,
      liveStreamId: json['liveStreamId'] as String,
      streamKey: json['streamKey'] as String,
      playbackId: json['playbackId'] as String,
      title: json['title'] as String,
      teacherId: json['teacherId'] as String,
      classId: json['classId'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rtmpUrl': rtmpUrl,
      'liveStreamId': liveStreamId,
      'streamKey': streamKey,
      'playbackId': playbackId,
      'title': title,
      'teacherId': teacherId,
      'classId': classId,
      'createdAt': createdAt,
    };
  }
}
