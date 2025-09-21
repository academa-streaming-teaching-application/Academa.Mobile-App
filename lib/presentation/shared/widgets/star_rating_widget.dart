import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final int rating;
  final Function(int)? onRatingChanged;
  final bool enabled;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.enabled = true,
    this.size = 30,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isActive = index < rating;

        return GestureDetector(
          onTap: enabled && onRatingChanged != null
              ? () => onRatingChanged!(index + 1)
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Icon(
              isActive ? Icons.star : Icons.star_border,
              color: isActive
                  ? (activeColor ?? Colors.amber)
                  : (inactiveColor ?? Colors.grey),
              size: size,
            ),
          ),
        );
      }),
    );
  }
}

class StarRatingDisplay extends StatelessWidget {
  final double rating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const StarRatingDisplay({
    super.key,
    required this.rating,
    this.size = 16,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final diff = rating - index;
        IconData iconData;

        if (diff >= 1) {
          iconData = Icons.star;
        } else if (diff >= 0.5) {
          iconData = Icons.star_half;
        } else {
          iconData = Icons.star_border;
        }

        return Icon(
          iconData,
          color: diff > 0
              ? (activeColor ?? Colors.amber)
              : (inactiveColor ?? Colors.grey),
          size: size,
        );
      }),
    );
  }
}