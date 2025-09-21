import 'package:academa_streaming_platform/domain/datasource/subject_rating_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/subject_rating_entity.dart';
import 'package:academa_streaming_platform/domain/repositories/subject_rating_repository.dart';

class SubjectRatingRepositoryImpl implements SubjectRatingRepository {
  final SubjectRatingDataSource dataSource;

  SubjectRatingRepositoryImpl(this.dataSource);

  @override
  Future<SubjectRatingEntity> rateSubject({
    required String subjectId,
    required int score,
    String? comment,
  }) {
    return dataSource.rateSubject(
      subjectId: subjectId,
      score: score,
      comment: comment,
    );
  }

  @override
  Future<SubjectRatingsResponseEntity> getSubjectRatings({
    required String subjectId,
    int page = 1,
    int limit = 10,
  }) {
    return dataSource.getSubjectRatings(
      subjectId: subjectId,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<SubjectRatingEntity?> getUserRating(String subjectId) {
    return dataSource.getUserRating(subjectId);
  }

  @override
  Future<void> deleteRating(String subjectId) {
    return dataSource.deleteRating(subjectId);
  }
}