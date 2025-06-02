import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:academa_streaming_platform/domain/entities/saved_asset_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:academa_streaming_platform/data/repositories/class_repository_impl.dart';
import 'package:academa_streaming_platform/domain/repositories/class_repository.dart';
import 'package:academa_streaming_platform/domain/entities/class_entity.dart';

import '../../../data/datasource/class_datasource_impl.dart';
import '../../../data/datasource/live_streaming_datasource_impl.dart';
import '../../../data/repositories/live_streaming_repository_impl.dart';
import '../../../domain/repositories/live_streaming_repository.dart';

/// Classes
final classRepositoryProvider = Provider<ClassRepository>(
  (ref) => ClassRepositoryImpl(
    ClassDataSourceImpl(
      Dio(
        BaseOptions(baseUrl: 'http://192.168.68.108:3000/api/v1/class'),
      ),
    ),
  ),
);

final fetchAllClassesProvider = FutureProvider<List<ClassEntity>>((ref) async {
  final repository = ref.watch(classRepositoryProvider);
  return repository.getAllClasses();
});

//Saved Videos
final savedItemsRepositoryProvider = Provider<LiveStreamingRepository>(
  (ref) => LiveStreamingRepositoryImpl(
    LiveStreamingDataSourceImpl(
      Dio(
        BaseOptions(baseUrl: 'http://192.168.68.108:3000/api/v1'),
      ),
    ),
  ),
);

final fetchAllSavedItemsProvider =
    FutureProvider<List<SavedAssetEntity>>((ref) async {
  final repository = ref.watch(savedItemsRepositoryProvider);
  return repository.getSavedAssets();
});
