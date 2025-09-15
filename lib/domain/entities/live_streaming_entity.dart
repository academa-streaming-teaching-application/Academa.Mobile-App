// lib/domain/entities/live_session_entity.dart
import 'package:flutter/material.dart';
import 'package:academa_streaming_platform/data/models/live_streaming_dto.dart';

/// Ciclo de vida de la sesión (ended = grabación disponible)
enum LiveSessionStatus {
  scheduled,
  live,
  ended, // disponible
  canceled;

  /// Mapea strings del backend al enum.
  static LiveSessionStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'scheduled':
        return LiveSessionStatus.scheduled;
      case 'live':
        return LiveSessionStatus.live;
      // Trata variantes como 'ended' (disponible)
      case 'ended':
      case 'ready':
      case 'record_ready':
      case 'record-ready':
      case 'recorded':
        return LiveSessionStatus.ended;
      case 'canceled':
        return LiveSessionStatus.canceled;
      default:
        return LiveSessionStatus.scheduled;
    }
  }

  String get displayName {
    switch (this) {
      case LiveSessionStatus.scheduled:
        return 'Programada';
      case LiveSessionStatus.live:
        return 'EN VIVO';
      case LiveSessionStatus.ended:
        return 'Disponible';
      case LiveSessionStatus.canceled:
        return 'Cancelada';
    }
  }

  Color get color {
    switch (this) {
      case LiveSessionStatus.scheduled:
        return Colors.blue;
      case LiveSessionStatus.live:
        return Colors.red;
      case LiveSessionStatus.ended:
        return Colors.green;
      case LiveSessionStatus.canceled:
        return Colors.grey;
    }
  }
}

class LiveSessionEntity {
  final String id;
  final String subjectId;
  final String subject;
  final String category;
  final int classNumber;
  final String? title;
  final LiveSessionStatus status;

  // Streaming (Mux)
  final String? liveStreamId; // ls_...
  final String? streamKey; // clave de emisión
  final String? rtmpServer; // ingest (rtmp/rtmps)
  final String? playbackId; // pl_... (ÚNICO id para LIVE y VOD)

  // Asset (opcional)
  final String? assetId; // as_...

  // Propiedad / tiempos
  final String createdBy;
  final DateTime? startsAt;
  final DateTime? endedAt;
  final DateTime createdAt;

  LiveSessionEntity({
    required this.id,
    required this.subjectId,
    required this.subject,
    required this.category,
    required this.classNumber,
    this.title,
    required this.status,
    this.liveStreamId,
    this.streamKey,
    this.rtmpServer,
    this.playbackId,
    this.assetId,
    required this.createdBy,
    this.startsAt,
    this.endedAt,
    required this.createdAt,
  });

  /// Título mostrado en UI
  String get displayTitle => title ?? 'Clase $classNumber';

  bool get isLive => status == LiveSessionStatus.live;
  bool get isRecorded => status == LiveSessionStatus.ended;

  /// ended + sin playbackId => “Procesando” (hasta que el backend ponga el playbackId de VOD)
  bool get isProcessing =>
      status == LiveSessionStatus.ended &&
      (playbackId == null || playbackId!.isEmpty);

  /// Reproducible si hay playbackId (independiente del estado)
  bool get isPlayable => (playbackId ?? '').isNotEmpty;

  /// Helpers de UI (consideran “Procesando”)
  String get uiDisplayName => isProcessing ? 'Procesando' : status.displayName;
  Color get uiColor => isProcessing ? Colors.orange : status.color;

  /// URL HLS usando el único playbackId
  String get playbackUrl {
    final id = playbackId;
    return (id == null || id.isEmpty) ? '' : 'https://stream.mux.com/$id.m3u8';
  }

  /// Miniatura: con VOD suele funcionar; en LIVE puede no existir
  String get thumbnailUrl {
    final id = playbackId;
    return (id == null || id.isEmpty)
        ? ''
        : 'https://image.mux.com/$id/thumbnail.jpg?time=5';
  }

  /// Duración legible (p.ej., "1h 12m", "12m 05s", "42s")
  String get duration {
    if (endedAt == null || startsAt == null) return '';
    final diff = endedAt!.difference(startsAt!);
    if (diff.inSeconds <= 0) return '';
    final h = diff.inHours;
    final m = diff.inMinutes.remainder(60);
    final s = diff.inSeconds.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s.toString().padLeft(2, '0')}s';
    return '${s}s';
  }

  /// DTO para pantalla de emisión (LIVE)
  LiveStreamingDto toStreamingDto() => LiveStreamingDto(
        rtmpUrl: rtmpServer ?? '',
        liveStreamId: liveStreamId ?? '',
        streamKey: streamKey ?? '',
        playbackId: playbackId ?? '',
        title: displayTitle,
        teacherId: createdBy,
        classId: id,
        createdAt: createdAt.toIso8601String(),
      );

  factory LiveSessionEntity.fromJson(Map<String, dynamic> json) {
    DateTime? _dt(dynamic v) {
      if (v == null) return null;
      try {
        return DateTime.parse(v.toString());
      } catch (_) {
        return null;
      }
    }

    int _int(dynamic v) {
      if (v is int) return v;
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    return LiveSessionEntity(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      subjectId: json['subjectId']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      classNumber: _int(json['classNumber']),
      title: json['title']?.toString(),
      status: LiveSessionStatus.fromString(
          json['status']?.toString() ?? 'scheduled'),
      liveStreamId: json['liveStreamId']?.toString(),
      streamKey: json['streamKey']?.toString(),
      rtmpServer: json['rtmpServer']?.toString(),
      playbackId: json['playbackId']?.toString(), // único id para LIVE/VOD
      assetId: json['assetId']?.toString(),
      createdBy: json['createdBy']?.toString() ?? '',
      startsAt: _dt(json['startsAt']),
      endedAt: _dt(json['endedAt']),
      createdAt: _dt(json['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subjectId': subjectId,
        'subject': subject,
        'category': category,
        'classNumber': classNumber,
        'title': title,
        'status': status
            .name, // si backend requiere snake_case, mapéalo antes de enviar
        'liveStreamId': liveStreamId,
        'streamKey': streamKey,
        'rtmpServer': rtmpServer,
        'playbackId': playbackId,
        'assetId': assetId,
        'createdBy': createdBy,
        'startsAt': startsAt?.toIso8601String(),
        'endedAt': endedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };
}
