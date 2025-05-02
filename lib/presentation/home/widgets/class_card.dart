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

  static const double _borderRadius = 12.0;
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      elevation: 4,
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
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: _titleStyle),
                    const SizedBox(height: 4),
                    Text(subtitle, style: _subtitleStyle),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onLikeTap,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: _iconSize,
                  color: isLiked ? Colors.redAccent : Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
