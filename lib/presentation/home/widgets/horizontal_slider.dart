import 'package:flutter/material.dart';

class HorizontalSlider extends StatelessWidget {
  final List<Widget> cards;
  final double height;
  final double horizontalPadding;
  final double vertialPadding;
  const HorizontalSlider(
      {super.key,
      required this.cards,
      this.height = 200,
      this.horizontalPadding = 18,
      this.vertialPadding = 8});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: vertialPadding),
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) => cards[i],
      ),
    );
  }
}
