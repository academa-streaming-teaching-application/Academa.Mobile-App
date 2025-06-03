import 'package:academa_streaming_platform/domain/entities/saved_asset_entity.dart';
import 'package:flutter/material.dart';
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/keep_watching.dart';
import 'package:go_router/go_router.dart';

class SavedItemsHorizontalSlider extends StatelessWidget {
  final List<SavedAssetEntity> assets;
  final double height;

  const SavedItemsHorizontalSlider({
    super.key,
    required this.assets,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        itemCount: assets.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final asset = assets[i];
          return KeepWatchingCard(
            title: asset.title ?? 'Video sin título',
            imagePath: 'lib/config/assets/productivity_square.png',
            onPlay: () {
              context.push('/player?playbackId=${asset.playbackId}');
            },
          );
        },
      ),
    );
  }
}
