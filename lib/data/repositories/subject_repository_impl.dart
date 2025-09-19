// data/repositories/subject_repository_impl.dart
import 'package:academa_streaming_platform/domain/repositories/subject_repository.dart';

import '../../domain/datasource/subject_datasource.dart';
import '../../domain/entities/subject_entity.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectDataSource dataSource;

  SubjectRepositoryImpl(this.dataSource);

  @override
  Future<List<SubjectEntity>> getAllSubjects() {
    return dataSource.getAllSubjects();
  }

  @override
  Future<List<SubjectEntity>> getTopRatedSubjects({
    int limit = 10,
    int minRatings = 3,
    String? query,
    String? topic,
    String? professorId,
  }) {
    return dataSource.getTopRatedSubjects(
      limit: limit,
      minRatings: minRatings,
      query: query,
      topic: topic,
      professorId: professorId,
    );
  }

  @override
  Future<SubjectEntity> getSubjectById(String id) {
    return dataSource.getSubjectById(id);
  }

  @override
  Future<bool> follow(
    String subjectId, {
    required String userId,
    required bool follow,
  }) {
    return dataSource.follow(
      subjectId,
      userId: userId,
      follow: follow,
    );
  }

  @override
  Future<void> subscribeToSubject(String subjectId) {
    return dataSource.subscribeToSubject(subjectId);
  }

  @override
  Future<void> unsubscribeFromSubject(String subjectId) {
    return dataSource.unsubscribeFromSubject(subjectId);
  }

  @override
  Future<bool> getSubscriptionStatus(String subjectId) {
    return dataSource.getSubscriptionStatus(subjectId);
  }

  @override
  Future<List<SubjectEntity>> getFollowedSubjects() {
    return dataSource.getFollowedSubjects();
  }
}
