import '../entities/subject_entity.dart';

abstract class SubjectDataSource {
  Future<List<SubjectEntity>> getAllSubjects();

  Future<List<SubjectEntity>> getTopRatedSubjects({
    int limit = 10,
    int minRatings = 3,
    String? query,
    String? topic,
    String? professorId,
  });
  Future<SubjectEntity> getSubjectById(String id);

  Future<bool> follow(
    String subjectId, {
    required String userId,
    required bool follow,
  });

  Future<void> subscribeToSubject(String subjectId);

  Future<void> unsubscribeFromSubject(String subjectId);

  Future<bool> getSubscriptionStatus(String subjectId);

  Future<List<SubjectEntity>> getFollowedSubjects();
}
