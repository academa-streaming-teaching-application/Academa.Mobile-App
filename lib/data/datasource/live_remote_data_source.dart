import 'package:dio/dio.dart';

import '../../domain/datasource/live_streaming_datasource.dart';
import '../../domain/entities/live_model.dart';

import '../models/live_session_dto.dart';
import '../mappers/live_mapper.dart';

class LiveRemoteDataSource implements LiveStreamingDataSource {
  final Dio _dio;
  LiveRemoteDataSource(this._dio);

  @override
  Future<LiveModel> createLiveSession(String teacherId) async {
    final response = await _dio.post(
      '/live/start',
      data: {'teacherId': teacherId},
    );

    print('🔵 response: ${response.data}');

    final LiveSessionDto dto = LiveSessionDto.fromJson(response.data);
    return LiveMapper.fromBackendDto(dto);
  }

  @override
  Future<List<LiveModel>> fetchSessions() async {
    final response = await _dio.get('/live-sessions');

    final dtos = (response.data as List)
        .map((json) => LiveSessionDto.fromJson(json))
        .toList();

    return dtos.map(LiveMapper.fromBackendDto).toList();
  }
}
