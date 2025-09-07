import 'package:dio/dio.dart';
import 'package:academa_streaming_platform/domain/datasource/live_streaming_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';

class LiveDataSourceImpl implements LiveDataSource {
  final Dio _dio;
  final String? _accessToken;

  LiveDataSourceImpl(
    this._dio, {
    String? accessToken,
  }) : _accessToken = accessToken;

  @override
  Future<LiveSessionEntity> startLiveSession({
    required String subjectId,
    required int classNumber,
    DateTime? startsAt,
  }) async {
    try {
      final body = <String, dynamic>{
        'subjectId': subjectId,
        'classNumber': classNumber,
        if (startsAt != null) 'startsAt': startsAt.toUtc().toIso8601String(),
      };

      final resp = await _dio.post(
        '/api/v1/start-live-session',
        data: body,
        options: Options(
          headers: (_accessToken != null && _accessToken!.isNotEmpty)
              ? {'Authorization': 'Bearer $_accessToken'}
              : null,
        ),
      );

      // El controller devuelve el objeto plano con sessionId, playbackId, etc.
      final map = Map<String, dynamic>.from(resp.data as Map);
      map['subjectId'] ??= subjectId; // por si no viene explícito
      return LiveSessionEntity.fromMap(map);
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      throw Exception('No se pudo iniciar el live: $msg');
    }
  }

  // añade este método a LiveDataSourceImpl
  @override
  Future<void> completeLiveSession({required String sessionId}) async {
    try {
      await _dio.post(
        '/api/v1/live-sessions/$sessionId/complete',
        options: Options(
          headers: (_accessToken != null && _accessToken!.isNotEmpty)
              ? {'Authorization': 'Bearer $_accessToken'}
              : null,
        ),
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      throw Exception('No se pudo completar el live: $msg');
    }
  }
}
