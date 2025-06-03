import 'package:academa_streaming_platform/domain/entities/saved_asset_entity.dart';
import 'package:academa_streaming_platform/presentation/providers/saved_asset_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/class_entity.dart';

final fetchClassByIdProvider =
    FutureProvider.family.autoDispose<ClassEntity, String>((ref, id) async {
  final repository = ref.watch(classRepositoryProvider);
  return repository.getClassById(id);
});

final fetchSavedAssetsByClassIdProvider =
    FutureProvider.family<List<SavedAssetEntity>, String>((ref, id) async {
  final repository = ref.watch(classRepositoryProvider);
  return repository.getSavedAssetsByClassId(id);
});
