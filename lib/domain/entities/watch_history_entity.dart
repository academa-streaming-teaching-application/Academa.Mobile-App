class WatchHistoryEntity {
  final String id;
  final String userId;
  final String sessionId;
  final String subjectId;
  final String subject;
  final int classNumber;
  final String? title;
  final String? playbackId;
  final DateTime lastWatchedAt;
  final double watchProgress;
  final int totalDuration;
  final int watchedDuration;
  final bool isCompleted;
  final String? thumbnailUrl;

  const WatchHistoryEntity({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.subjectId,
    required this.subject,
    required this.classNumber,
    this.title,
    this.playbackId,
    required this.lastWatchedAt,
    required this.watchProgress,
    required this.totalDuration,
    required this.watchedDuration,
    required this.isCompleted,
    this.thumbnailUrl,
  });

  String get displayTitle => title ?? 'Clase $classNumber';

  String get progressText {
    final remainingSeconds = totalDuration - watchedDuration;
    final remainingMinutes = (remainingSeconds / 60).round();

    if (remainingMinutes < 1) {
      return 'Casi terminado';
    } else if (remainingMinutes < 60) {
      return 'Tiempo restante: ${remainingMinutes} min';
    } else {
      final hours = (remainingMinutes / 60).floor();
      final minutes = remainingMinutes % 60;
      return 'Tiempo restante: ${hours}h ${minutes}m';
    }
  }

  String get playbackUrl {
    final id = playbackId;
    return (id == null || id.isEmpty) ? '' : 'https://stream.mux.com/$id.m3u8';
  }

  factory WatchHistoryEntity.fromJson(Map<String, dynamic> json) {
    DateTime? _dt(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    double _double(dynamic v) {
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v?.toString() ?? '') ?? 0.0;
    }

    int _int(dynamic v) {
      if (v is int) return v;
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    return WatchHistoryEntity(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      sessionId: json['sessionId']?.toString() ?? '',
      subjectId: json['subjectId']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      classNumber: _int(json['classNumber']),
      title: json['title']?.toString(),
      playbackId: json['playbackId']?.toString(),
      lastWatchedAt: _dt(json['lastWatchedAt']) ?? DateTime.now(),
      watchProgress: _double(json['watchProgress']),
      totalDuration: _int(json['totalDuration']),
      watchedDuration: _int(json['watchedDuration']),
      isCompleted: json['isCompleted'] == true,
      thumbnailUrl: json['thumbnailUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'sessionId': sessionId,
        'subjectId': subjectId,
        'subject': subject,
        'classNumber': classNumber,
        'title': title,
        'playbackId': playbackId,
        'lastWatchedAt': lastWatchedAt.toIso8601String(),
        'watchProgress': watchProgress,
        'totalDuration': totalDuration,
        'watchedDuration': watchedDuration,
        'isCompleted': isCompleted,
        'thumbnailUrl': thumbnailUrl,
      };
}