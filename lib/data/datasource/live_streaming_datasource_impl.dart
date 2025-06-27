import 'package:academa_streaming_platform/domain/entities/saved_asset_entity.dart';
import 'package:dio/dio.dart';

import '../../domain/datasource/live_streaming_datasource.dart';
import '../../domain/entities/live_streaming_entity.dart';

import '../models/live_streaming_dto.dart';

class LiveStreamingDataSourceImpl implements LiveStreamingDataSource {
  final Dio _dio;
  LiveStreamingDataSourceImpl(this._dio);

  @override
  Future<LiveStreamingEntity> createLiveSession({
    required String classId,
    required String teacherId,
    required String title,
  }) async {
    final response = await _dio.post(
      '/live/start',
      data: {
        'classId': classId,
        'teacherId': teacherId,
        'title': title,
      },
    );

    final dto = LiveStreamingDto.fromJson(response.data);

    return LiveStreamingEntity(
      rtmpUrl: dto.rtmpUrl,
      liveStreamId: dto.liveStreamId,
      streamKey: dto.streamKey,
      playbackId: dto.playbackId,
      title: dto.title,
      teacherId: dto.teacherId,
      classId: dto.classId,
      createdAt: dto.createdAt,
    );
  }
}
