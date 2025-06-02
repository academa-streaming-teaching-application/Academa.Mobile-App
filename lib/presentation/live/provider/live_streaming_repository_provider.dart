import 'package:academa_streaming_platform/data/datasource/live_streaming_datasource_impl.dart';
import 'package:academa_streaming_platform/data/repositories/live_streaming_repository_impl.dart';
import 'package:academa_streaming_platform/domain/repositories/live_streaming_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final liveStreamingRepositoryProvider = Provider<LiveStreamingRepository>(
  (ref) => LiveStreamingRepositoryImpl(
    LiveStreamingDataSourceImpl(
      Dio(
        BaseOptions(baseUrl: 'http://192.168.68.108:3000/api/v1'),
      ),
    ),
  ),
);
