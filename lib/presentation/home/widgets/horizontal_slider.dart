import 'package:flutter/material.dart';
import 'package:academa_streaming_platform/domain/entities/class_entity.dart';
import 'package:academa_streaming_platform/presentation/home/widgets/class_card.dart';

class HorizontalSlider extends StatelessWidget {
  final List<ClassEntity> cards;
  final double height;
  final double horizontalPadding;
  final double vertialPadding;

  const HorizontalSlider({
    super.key,
    required this.cards,
    this.height = 200,
    this.horizontalPadding = 18,
    this.vertialPadding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: vertialPadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final classEntity = cards[i];
          return ClassCard(
              imagePath: 'lib/config/assets/productivity_square.png',
              title: classEntity.type!,
              subtitle: classEntity.title ?? 'Clase sin descripción',
              isLiked: false, // TODO: connect with favorites state
              onLikeTap: () {}, // TODO: implement favorite logic
              id: classEntity.id);
        },
      ),
    );
  }
}
