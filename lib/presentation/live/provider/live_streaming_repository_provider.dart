import 'package:academa_streaming_platform/data/datasource/live_streaming_datasource_impl.dart';
import 'package:academa_streaming_platform/data/models/live_streaming_dto.dart';
import 'package:academa_streaming_platform/data/repositories/live_streaming_repository_impl.dart';
import 'package:academa_streaming_platform/domain/repositories/live_streaming_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/live_streaming_entity.dart';

final liveStreamingRepositoryProvider = Provider<LiveStreamingRepository>(
  (ref) => LiveStreamingRepositoryImpl(
    LiveStreamingDataSourceImpl(
      Dio(
        BaseOptions(baseUrl: 'http://192.168.1.142:3000/api/v1'),
      ),
    ),
  ),
);

final activeLiveStreamsProvider =
    StreamProvider<List<LiveStreamingEntity>>((ref) {
  return FirebaseFirestore.instance
      .collection('active_livestreams')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final dto = LiveStreamingDto.fromJson(doc.data());
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
          }).toList());
});
