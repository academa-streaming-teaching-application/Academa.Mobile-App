import 'package:flutter/material.dart';

class VerticalSlider extends StatelessWidget {
  final List<Widget> cards;
  final double height;
  final double horizontalPadding;
  final double verticalPadding;

  const VerticalSlider({
    super.key,
    required this.cards,
    this.height = 100,
    this.horizontalPadding = 18,
    this.verticalPadding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        scrollDirection: Axis.vertical,
        itemCount: cards.length,
        itemBuilder: (context, index) => cards[index],
        separatorBuilder: (context, index) => SizedBox(height: verticalPadding),
      ),
    );
  }
}
