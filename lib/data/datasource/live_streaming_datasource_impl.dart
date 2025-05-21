import 'package:dio/dio.dart';

import '../../domain/datasource/live_streaming_datasource.dart';
import '../../domain/entities/live_streaming_entity.dart';

import '../models/live_streaming_dto.dart';

class LiveStreamingDataSourceImpl implements LiveStreamingDataSource {
  final Dio _dio;
  LiveStreamingDataSourceImpl(this._dio);

  @override
  Future<LiveStreamingEntity> createLiveSession(String teacherId) async {
    final response = await _dio.post(
      '/live/start',
      data: {'teacherId': teacherId},
    );

    final dto = LiveStreamingDto.fromJson(response.data);

    return LiveStreamingEntity(
      rtmpUrl: dto.rtmpUrl,
      liveStreamId: dto.liveStreamId,
      streamKey: dto.streamKey,
      playbackId: dto.playbackId,
    );
  }

  @override
  Future<List<LiveStreamingEntity>> fetchSessions() async {
    final response = await _dio.get('/live-sessions');

    final dtos = (response.data as List)
        .map((json) => LiveStreamingDto.fromJson(json))
        .toList();

    return dtos
        .map((dto) => LiveStreamingEntity(
              rtmpUrl: dto.rtmpUrl,
              liveStreamId: dto.liveStreamId,
              streamKey: dto.streamKey,
              playbackId: dto.playbackId,
            ))
        .toList();
  }
}
