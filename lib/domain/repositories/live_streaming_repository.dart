import 'package:academa_streaming_platform/domain/entities/saved_asset_entity.dart';

import '../entities/live_streaming_entity.dart';

abstract class LiveStreamingRepository {
  Future<LiveStreamingEntity> createSession({
    required String classId,
    required String teacherId,
    required String title,
  });
  Future<List<SavedAssetEntity>> getSavedAssets();
}
