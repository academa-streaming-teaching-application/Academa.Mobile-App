import 'user_entity.dart';

class SubjectRatingEntity {
  final String id;
  final String subjectId;
  final String studentId;
  final int score;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserEntity? student;

  const SubjectRatingEntity({
    required this.id,
    required this.subjectId,
    required this.studentId,
    required this.score,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
    this.student,
  });

  SubjectRatingEntity copyWith({
    String? id,
    String? subjectId,
    String? studentId,
    int? score,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserEntity? student,
  }) {
    return SubjectRatingEntity(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      studentId: studentId ?? this.studentId,
      score: score ?? this.score,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      student: student ?? this.student,
    );
  }
}

class RatingStatsEntity {
  final double averageRating;
  final int totalRatings;

  const RatingStatsEntity({
    required this.averageRating,
    required this.totalRatings,
  });

  RatingStatsEntity copyWith({
    double? averageRating,
    int? totalRatings,
  }) {
    return RatingStatsEntity(
      averageRating: averageRating ?? this.averageRating,
      totalRatings: totalRatings ?? this.totalRatings,
    );
  }
}

class SubjectRatingsResponseEntity {
  final List<SubjectRatingEntity> ratings;
  final RatingStatsEntity stats;
  final RatingMetaEntity meta;

  const SubjectRatingsResponseEntity({
    required this.ratings,
    required this.stats,
    required this.meta,
  });
}

class RatingMetaEntity {
  final int page;
  final int limit;
  final int totalRatings;
  final int totalPages;

  const RatingMetaEntity({
    required this.page,
    required this.limit,
    required this.totalRatings,
    required this.totalPages,
  });
}