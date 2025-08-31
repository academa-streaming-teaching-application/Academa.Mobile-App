class SubjectEntity {
  final String id;
  final String subject;
  final String topic;
  final int numberOfClasses;
  final double averageRating;
  final int ratingCount;
  final String? teacherId;
  final List<String> studentIds;
  final bool isFollowed;

  const SubjectEntity({
    required this.id,
    required this.subject,
    required this.topic,
    required this.numberOfClasses,
    this.averageRating = 0.0,
    this.ratingCount = 0,
    this.teacherId,
    this.studentIds = const [],
    this.isFollowed = false,
  });

  SubjectEntity copyWith({
    String? id,
    String? subject,
    String? topic,
    int? numberOfClasses,
    double? averageRating,
    int? ratingCount,
    String? teacherId,
    List<String>? studentIds,
    bool? isFollowed,
  }) {
    return SubjectEntity(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      topic: topic ?? this.topic,
      numberOfClasses: numberOfClasses ?? this.numberOfClasses,
      averageRating: averageRating ?? this.averageRating,
      ratingCount: ratingCount ?? this.ratingCount,
      teacherId: teacherId ?? this.teacherId,
      studentIds: studentIds ?? this.studentIds,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }
}
