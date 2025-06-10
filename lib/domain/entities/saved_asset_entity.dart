// data/models/saved_asset_dto.dart

class SavedAssetEntity {
  final String assetId;
  final String playbackId;
  final double duration;
  final String status;
  final String createdAt;
  final String? title;

  const SavedAssetEntity({
    // ✨  added const
    required this.assetId,
    required this.playbackId,
    required this.duration,
    required this.status,
    required this.createdAt,
    this.title,
  });

  factory SavedAssetEntity.fromJson(Map<String, dynamic> json) {
    return SavedAssetEntity(
      assetId: (json['assetId'] as String?) ?? '',
      playbackId: (json['playbackId'] as String?) ?? '',
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      status: (json['status'] as String?) ?? '',
      createdAt: (json['createdAt'] as String?) ?? '',
      title: json['title'] as String?,
    );
  }
}
