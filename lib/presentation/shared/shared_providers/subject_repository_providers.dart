import 'dart:async';
import 'package:academa_streaming_platform/data/datasource/subject_datasource_impl.dart';
import 'package:academa_streaming_platform/data/repositories/subject_repository_impl.dart';
import 'package:academa_streaming_platform/domain/entities/subject_entity.dart';
import 'package:academa_streaming_platform/domain/repositories/subject_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/provider/auth_repositoy_provider.dart';

final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SubjectRepositoryImpl(
    SubjectDataSourceImpl(dio),
  );
});

class TopRatedParams {
  final int limit;
  final int minRatings;
  final String? query, topic, professorId;
  const TopRatedParams({
    this.limit = 10,
    this.minRatings = 3,
    this.query,
    this.topic,
    this.professorId,
  });
}

final topRatedSubjectsFutureProvider = FutureProvider.autoDispose
    .family<List<SubjectEntity>, TopRatedParams>((ref, p) {
  final repo = ref.watch(subjectRepositoryProvider);
  return repo.getTopRatedSubjects(
    limit: p.limit,
    minRatings: p.minRatings,
    query: p.query,
    topic: p.topic,
    professorId: p.professorId,
  );
});

final refreshTopRatedSubjectsProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(topRatedSubjectsFutureProvider);
  };
});

final subjectByIdProvider =
    FutureProvider.autoDispose.family<SubjectEntity, String>((ref, id) {
  final repo = ref.watch(subjectRepositoryProvider);
  return repo.getSubjectById(id);
});

final allSubjectsProvider =
    FutureProvider.autoDispose<List<SubjectEntity>>((ref) async {
  final repo = ref.watch(subjectRepositoryProvider);

  final link = ref.keepAlive();
  Timer(const Duration(minutes: 10), link.close);

  return repo.getAllSubjects();
});

final subjectsSearchProvider =
    Provider.autoDispose.family<List<SubjectEntity>, String?>((ref, query) {
  final asyncAll = ref.watch(allSubjectsProvider);
  return asyncAll.maybeWhen(
    data: (list) {
      final q = (query ?? '').trim().toLowerCase();
      if (q.isEmpty) return list;
      return list.where((s) {
        final title = (s.subject ?? '').toLowerCase();
        final topic = (s.category ?? '').toLowerCase();
        final professor = (s.professor?.name ?? '').toLowerCase();
        return title.contains(q) || topic.contains(q) || professor.contains(q);
      }).toList();
    },
    orElse: () => const [],
  );
});

final followedSubjectsProvider =
    FutureProvider.autoDispose<List<SubjectEntity>>((ref) async {
  // Wait for auth tokens to be loaded before making the request
  final authTokens = ref.watch(authTokensProvider);

  // If no access token, return empty list (user not authenticated)
  if (authTokens.accessToken == null) {
    return <SubjectEntity>[];
  }

  final repo = ref.watch(subjectRepositoryProvider);

  final link = ref.keepAlive();
  Timer(const Duration(minutes: 10), link.close);

  return repo.getFollowedSubjects();
});

final teacherOwnSubjectsProvider =
    FutureProvider.autoDispose<List<SubjectEntity>>((ref) async {
  // Wait for auth tokens to be loaded before making the request
  final authTokens = ref.watch(authTokensProvider);

  // If no access token, return empty list (user not authenticated)
  if (authTokens.accessToken == null) {
    return <SubjectEntity>[];
  }

  final repo = ref.watch(subjectRepositoryProvider);

  final link = ref.keepAlive();
  Timer(const Duration(minutes: 10), link.close);

  return repo.getTeachingSubjects();
});
