class LiveSessionEntity {
  final String id; // sessionId
  final String subjectId;
  final String liveStreamId;
  final String rtmpServer;
  final String streamKey; // secreta (prod: manejo seguro)
  final String playbackId; // para alumnos (HLS)
  final String subject;
  final String category;
  final int classNumber;
  final String status; // scheduled | live | ended | record_ready...
  final DateTime? startsAt;
  final DateTime? createdAt;

  LiveSessionEntity({
    required this.id,
    required this.subjectId,
    required this.liveStreamId,
    required this.rtmpServer,
    required this.streamKey,
    required this.playbackId,
    required this.subject,
    required this.category,
    required this.classNumber,
    required this.status,
    this.startsAt,
    this.createdAt,
  });

  factory LiveSessionEntity.fromMap(Map<String, dynamic> json) {
    return LiveSessionEntity(
      id: (json['sessionId'] ?? json['id'] ?? json['_id'] ?? '').toString(),
      subjectId: (json['subjectId'] ?? '').toString(),
      liveStreamId: (json['liveStreamId'] ?? '').toString(),
      rtmpServer: (json['rtmpServer'] ?? '').toString(),
      streamKey: (json['streamKey'] ?? '').toString(),
      playbackId: (json['playbackId'] ?? '').toString(),
      subject: (json['subject'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      classNumber: int.tryParse('${json['classNumber']}') ?? 1,
      status: (json['status'] ?? 'scheduled').toString(),
      startsAt: json['startsAt'] != null
          ? DateTime.tryParse(json['startsAt'].toString())
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
