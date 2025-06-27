import 'package:academa_streaming_platform/presentation/home/provider/follow_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✨
import 'package:academa_streaming_platform/domain/entities/class_entity.dart';
import 'package:academa_streaming_platform/presentation/home/widgets/class_card.dart';

class HorizontalSlider extends ConsumerWidget {
  // ✨ antes StatelessWidget
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
  Widget build(BuildContext context, WidgetRef ref) {
    // ✨ recibe ref
    final liked = ref.watch(followProvider).value ?? {}; // ✨ set<String>

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
        itemBuilder: (_, i) {
          final c = cards[i];

          return ClassCard(
            imagePath: 'lib/config/assets/productivity_square.png',
            title: c.type ?? '',
            subtitle: c.title ?? 'Clase sin descripción',
            id: c.id,
            isLiked: liked.contains(c.id), // ✨
            onLikeTap: () =>
                ref.read(followProvider.notifier).toggle(c.id), // ✨
          );
        },
      ),
    );
  }
}
