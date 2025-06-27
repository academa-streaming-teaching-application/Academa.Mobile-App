import 'package:flutter/material.dart';
import 'package:academa_streaming_platform/presentation/favorites/widgets/custom_favorites_app_bar.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_body_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/keep_watching.dart';
import 'package:go_router/go_router.dart';

import '../provider/favorites_repository_provider.dart';

class FavoritesView extends ConsumerWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrolledAsync = ref.watch(fetchEnrolledClassesProvider);
    print("enrolledAsync $enrolledAsync");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomFavoritesAppBar(),
      body: CustomBodyContainer(
        child: enrolledAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (classes) {
            if (classes.isEmpty) {
              return const Center(
                child: Text(
                  'Aún no sigues ninguna clase.',
                  style: TextStyle(color: Colors.black),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 24.0,
              ),
              physics: const ClampingScrollPhysics(),
              itemCount: classes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = classes[index];
                return KeepWatchingCard(
                  cardByPropsWidth: double.infinity,
                  cardByPropsHeight: 100,
                  title: item.title,
                  imagePath: 'lib/config/assets/productivity_square.png',
                  onPlay: () {
                    context.push('/class-view?id=${item.id}');
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
