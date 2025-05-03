import 'package:flutter/material.dart';

class HorizontalSlider extends StatelessWidget {
  final List<Widget> cards;
  final double height;
  const HorizontalSlider({
    super.key,
    required this.cards,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) => cards[i],
      ),
    );
  }
}
