import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:academa_streaming_platform/domain/entities/saved_asset_entity.dart';

abstract class LiveStreamingDataSource {
  Future<LiveStreamingEntity> createLiveSession({
    required String classId,
    required String teacherId,
    required String title,
  });

  Future<List<SavedAssetEntity>> fetchSavedAssets();
}
