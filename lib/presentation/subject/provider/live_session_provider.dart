// presentation/shared/shared_providers/live_session_providers.dart
import 'package:academa_streaming_platform/data/datasource/live_streaming_datasource_impl.dart';
import 'package:academa_streaming_platform/domain/datasource/live_streaming_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:academa_streaming_platform/presentation/auth/provider/auth_repositoy_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final liveDataSourceProvider = Provider<LiveDataSource>((ref) {
  final baseUrl = dotenv.env['API_BASE_URL']!;
  final dio = Dio(BaseOptions(baseUrl: baseUrl));
  final userToken = ref.watch(authTokensProvider);

  return LiveDataSourceImpl(dio, accessToken: userToken.accessToken);
});

final subjectLiveSessionsProvider = FutureProvider.autoDispose
    .family<List<LiveSessionEntity>, String>((ref, subjectId) async {
  final dataSource = ref.watch(liveDataSourceProvider);
  return dataSource.getSubjectLiveSessions(subjectId: subjectId);
});

final liveSessionProvider = FutureProvider.autoDispose
    .family<LiveSessionEntity, String>((ref, sessionId) async {
  final dataSource = ref.watch(liveDataSourceProvider);
  return dataSource.getLiveSession(sessionId: sessionId);
});

final startLiveSessionProvider = FutureProvider.autoDispose
    .family<LiveSessionEntity, StartLiveSessionParams>((ref, params) async {
  final dataSource = ref.watch(liveDataSourceProvider);
  return dataSource.startLiveSession(
    subjectId: params.subjectId,
    classNumber: params.classNumber,
    title: params.title,
    startsAt: params.startsAt,
  );
});

final completeLiveSessionProvider =
    FutureProvider.autoDispose.family<void, String>((ref, sessionId) async {
  final dataSource = ref.watch(liveDataSourceProvider);
  return dataSource.completeLiveSession(sessionId: sessionId);
});

class StartLiveSessionParams {
  final String subjectId;
  final int classNumber;
  final String? title;
  final DateTime? startsAt;

  StartLiveSessionParams({
    required this.subjectId,
    required this.classNumber,
    this.title,
    this.startsAt,
  });
}
