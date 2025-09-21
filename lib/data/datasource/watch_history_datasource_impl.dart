import 'package:academa_streaming_platform/domain/datasource/watch_history_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/watch_history_entity.dart';
import 'package:dio/dio.dart';

class WatchHistoryDataSourceImpl implements WatchHistoryDataSource {
  final Dio _dio;

  WatchHistoryDataSourceImpl(this._dio);

  @override
  Future<List<WatchHistoryEntity>> getWatchHistory({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final resp = await _dio.get(
        '/api/v1/users/me/watch-history',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      final body = resp.data;
      final List rawList = body is Map
          ? (body['data'] is Map && body['data']['watchHistory'] is List)
              ? body['data']['watchHistory'] as List
              : (body['watchHistory'] is List)
                  ? body['watchHistory'] as List
                  : const []
          : (body is List ? body : const []);

      return rawList
          .map((e) => WatchHistoryEntity.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      throw Exception('No se pudo obtener el historial: $msg');
    }
  }

  @override
  Future<void> updateWatchProgress({
    required String sessionId,
    required int currentTime,
    required int totalDuration,
  }) async {
    try {
      await _dio.post(
        '/api/v1/users/me/watch-progress',
        data: {
          'sessionId': sessionId,
          'currentTime': currentTime,
          'totalDuration': totalDuration,
        },
      );
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      throw Exception('No se pudo actualizar el progreso: $msg');
    }
  }
}
