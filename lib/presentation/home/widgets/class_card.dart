import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final String imagePath;

  final String title;

  final String subtitle;

  final bool isLiked;

  final VoidCallback? onLikeTap;

  const ClassCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.isLiked = false,
    this.onLikeTap,
  });

  static const double _iconSize = 24.0;
  static const TextStyle _titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );
  static const TextStyle _subtitleStyle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.45;
    final cardHeight = size.height * 0.08;
    return Center(
      child: Container(
        width: cardWidth,
        height: double.maxFinite,
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
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.4),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                SizedBox(
                  height: cardHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(title, style: _titleStyle),
                        Text(subtitle, style: _subtitleStyle),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onLikeTap,
                child: Container(
                  //TODO: Add the statefull logo bg
                  // decoration: BoxDecoration(
                  //   color: Colors.white70,
                  //   shape: BoxShape.circle,
                  // ),
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    size: _iconSize,
                    color: isLiked ? Colors.redAccent : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
