import 'package:academa_streaming_platform/domain/entities/saved_asset_entity.dart';
import 'package:academa_streaming_platform/presentation/providers/saved_asset_provider.dart';
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
