// providers/subject_repository_provider.dart
import 'package:academa_streaming_platform/data/datasource/subject_datasource_impl.dart';
import 'package:academa_streaming_platform/data/repositories/subject_repository_impl.dart';
import 'package:academa_streaming_platform/domain/entities/subject_entity.dart';
import 'package:academa_streaming_platform/domain/repositories/subject_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  final baseUrl = dotenv.env['API_BASE_URL']!;
  return SubjectRepositoryImpl(
    SubjectDataSourceImpl(Dio(BaseOptions(baseUrl: baseUrl))),
  );
});

class TopRatedParams {
  final int limit;
  final int minRatings;
  final String? query, topic, professorId;
  const TopRatedParams(
      {this.limit = 10,
      this.minRatings = 3,
      this.query,
      this.topic,
      this.professorId});
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
