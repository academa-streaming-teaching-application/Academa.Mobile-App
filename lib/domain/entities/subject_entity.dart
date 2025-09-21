import 'user_entity.dart';

class SubjectEntity {
  final String id;
  final String subject;
  final String category;
  final String description;
  final int numberOfClasses;
  final double averageRating;
  final int ratingCount;
  final UserEntity? professor;
  final List<String> studentIds;
  final bool isFollowed;

  const SubjectEntity({
    required this.id,
    required this.subject,
    required this.category,
    required this.description,
    required this.numberOfClasses,
    this.averageRating = 0.0,
    this.ratingCount = 0,
    this.professor,
    this.studentIds = const [],
    this.isFollowed = false,
  });

  SubjectEntity copyWith({
    String? id,
    String? subject,
    String? category,
    String? description,
    int? numberOfClasses,
    double? averageRating,
    int? ratingCount,
    UserEntity? professor,
    List<String>? studentIds,
    bool? isFollowed,
  }) {
    return SubjectEntity(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      category: category ?? this.category,
      description: description ?? this.description,
      numberOfClasses: numberOfClasses ?? this.numberOfClasses,
      averageRating: averageRating ?? this.averageRating,
      ratingCount: ratingCount ?? this.ratingCount,
      professor: professor ?? this.professor,
      studentIds: studentIds ?? this.studentIds,
      isFollowed: isFollowed ?? this.isFollowed,
    );
  }
}
