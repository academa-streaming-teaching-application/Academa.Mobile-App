import '../entities/subject_rating_entity.dart';

abstract class SubjectRatingDataSource {
  /// Rate a subject (create or update user's rating)
  Future<SubjectRatingEntity> rateSubject({
    required String subjectId,
    required int score,
    String? comment,
  });

  /// Get paginated list of all ratings for a subject
  Future<SubjectRatingsResponseEntity> getSubjectRatings({
    required String subjectId,
    int page = 1,
    int limit = 10,
  });

  /// Get the current user's rating for a specific subject
  Future<SubjectRatingEntity?> getUserRating(String subjectId);

  /// Delete the current user's rating for a specific subject
  Future<void> deleteRating(String subjectId);
}