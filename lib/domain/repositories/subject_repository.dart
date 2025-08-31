import '../entities/subject_entity.dart';

abstract class SubjectRepository {
  Future<List<SubjectEntity>> getAllSubjects({String? userId});
  Future<SubjectEntity> getSubjectById(String id);

  Future<List<SubjectEntity>> getTopRatedSubjects({
    int limit = 10,
    int minRatings = 3,
    String? query,
    String? topic,
    String? professorId,
  });

  Future<bool> follow(
    String subjectId, {
    required String userId,
    required bool follow,
  });
}
