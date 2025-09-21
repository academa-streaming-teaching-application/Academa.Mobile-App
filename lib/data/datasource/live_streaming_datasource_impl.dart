import 'package:academa_streaming_platform/domain/datasource/live_streaming_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:dio/dio.dart';

class LiveDataSourceImpl implements LiveDataSource {
  final Dio _dio;
  final String? _accessToken;

  LiveDataSourceImpl(
    this._dio, {
    String? accessToken,
  }) : _accessToken = accessToken;

  Options get _authOptions => Options(
        headers: (_accessToken != null && _accessToken!.isNotEmpty)
            ? {'Authorization': 'Bearer $_accessToken'}
            : null,
      );

  @override
  Future<LiveSessionEntity> startLiveSession({
    required String subjectId,
    required int classNumber,
    String? title,
    DateTime? startsAt,
  }) async {
    try {
      final body = <String, dynamic>{
        'subjectId': subjectId,
        'classNumber': classNumber,
        if (title != null) 'title': title,
        if (startsAt != null) 'startsAt': startsAt.toUtc().toIso8601String(),
      };

      final resp = await _dio.post(
        '/api/v1/start-live-session',
        data: body,
        options: _authOptions,
      );

      // The response includes sessionId, rtmpServer, streamKey, playbackId, etc.
      final responseData = Map<String, dynamic>.from(resp.data as Map);

      // Map backend response to LiveSessionEntity format
      final sessionData = {
        '_id': responseData['sessionId'],
        'subjectId': responseData['subjectId'] ?? subjectId,
        'subject': responseData['subject'] ?? '',
        'category': responseData['category'] ?? '',
        'classNumber': responseData['classNumber'] ?? classNumber,
        'title': responseData['title'],
        'status': responseData['status'] ?? 'scheduled',
        'liveStreamId': responseData['liveStreamId'],
        'streamKey': responseData['streamKey'],
        'rtmpServer': responseData['rtmpServer'] ?? responseData['rtmpIngest'],
        'playbackId': responseData['playbackId'],
        'startsAt': responseData['startsAt'],
        'createdAt': responseData['createdAt'],
        'createdBy': '', // You might want to get this from user context
      };

      return LiveSessionEntity.fromJson(sessionData);
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      throw Exception('No se pudo iniciar el live: $msg');
    }
  }

  @override
  Future<void> completeLiveSession({required String sessionId}) async {
    try {
      await _dio.post(
        '/api/v1/live-sessions/$sessionId/complete',
        options: _authOptions,
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      throw Exception('No se pudo completar el live: $msg');
    }
  }

  @override
  Future<LiveSessionEntity> getLiveSession({required String sessionId}) async {
    try {
      final resp = await _dio.get(
        '/api/v1/live-sessions/$sessionId',
        options: _authOptions,
      );

      final data = Map<String, dynamic>.from(resp.data as Map);
      return LiveSessionEntity.fromJson(data);
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      throw Exception('No se pudo obtener la sesión: $msg');
    }
  }

  @override
  Future<List<LiveSessionEntity>> getSubjectLiveSessions({
    required String subjectId,
    String? status,
  }) async {
    try {
      final resp = await _dio.get(
        '/api/v1/subjects/$subjectId/live-sessions',
        queryParameters: {if (status != null) 'status': status},
        options: _authOptions,
      );

      final body = resp.data;

      // Robust parsing: supports { data: { liveSessions: [...] } } (your API),
      // and falls back to top-level liveSessions or raw array if ever needed.
      final List rawList = body is Map
          ? (body['data'] is Map && body['data']['liveSessions'] is List)
              ? body['data']['liveSessions'] as List
              : (body['liveSessions'] is List)
                  ? body['liveSessions'] as List
                  : const []
          : (body is List ? body : const []);

      return rawList
          .map((e) => LiveSessionEntity.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      throw Exception('No se pudo obtener las sesiones: $msg');
    }
  }
}
