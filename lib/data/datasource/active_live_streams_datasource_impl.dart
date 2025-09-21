import 'package:academa_streaming_platform/domain/datasource/active_live_streams_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:dio/dio.dart';

class ActiveLiveStreamsDataSourceImpl implements ActiveLiveStreamsDataSource {
  final Dio _dio;

  ActiveLiveStreamsDataSourceImpl(this._dio);

  @override
  Future<List<LiveSessionEntity>> getActiveLiveStreams() async {
    try {
      final resp = await _dio.get('/api/v1/live-streams/active');

      final body = resp.data;
      final List rawList = body is Map
          ? (body['data'] is Map && body['data']['activeLiveStreams'] is List)
              ? body['data']['activeLiveStreams'] as List
              : (body['activeLiveStreams'] is List)
                  ? body['activeLiveStreams'] as List
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
      throw Exception('No se pudieron obtener los lives activos: $msg');
    }
  }
}
