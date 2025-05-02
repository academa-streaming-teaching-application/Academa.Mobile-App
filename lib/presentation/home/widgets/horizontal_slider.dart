import 'package:flutter/material.dart';

class HorizontalSlider extends StatelessWidget {
  final List<Widget> cards;
  const HorizontalSlider({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) => SizedBox(
          width: 200,
          child: cards[i],
        ),
      ),
    );
  }
}
