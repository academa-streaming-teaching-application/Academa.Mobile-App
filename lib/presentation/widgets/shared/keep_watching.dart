import 'package:flutter/material.dart';

class KeepWatchingCard extends StatelessWidget {
  const KeepWatchingCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.cardByPropsHeight,
    this.cardByPropsWidth,
    this.onPlay,
  });

  final String title;
  final String imagePath;
  final VoidCallback? onPlay;
  final double? cardByPropsHeight;
  final double? cardByPropsWidth;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final cardWidth = size.width * 0.8;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: GestureDetector(
        onTap: onPlay,
        child: Container(
          width: cardByPropsWidth ?? cardWidth,
          height: cardByPropsHeight ?? double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.asset(
                  imagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.scaleDown,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.play_circle_fill,
                size: 28,
                color: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
