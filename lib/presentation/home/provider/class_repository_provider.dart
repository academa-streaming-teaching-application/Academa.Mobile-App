import 'package:academa_streaming_platform/data/models/live_streaming_dto.dart';
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:academa_streaming_platform/domain/entities/saved_asset_entity.dart';
import 'package:academa_streaming_platform/presentation/providers/class_repository_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:academa_streaming_platform/domain/entities/class_entity.dart';

final fetchAllClassesProvider = FutureProvider<List<ClassEntity>>((ref) async {
  final repository = ref.watch(classRepositoryProvider);
  return repository.getAllClasses();
});

final fetchAllSavedItemsProvider =
    FutureProvider<List<SavedAssetEntity>>((ref) async {
  final repository = ref.watch(classRepositoryProvider);
  return repository.getSavedAssets();
});

final activeLiveStreamsProvider =
    StreamProvider<List<LiveStreamingEntity>>((ref) {
  return FirebaseFirestore.instance
      .collection('active_livestreams')
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
