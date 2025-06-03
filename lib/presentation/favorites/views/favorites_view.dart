import 'package:flutter/material.dart';
import 'package:academa_streaming_platform/presentation/favorites/widgets/custom_favorites_app_bar.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_body_container.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomFavoritesAppBar(),
      body: CustomBodyContainer(
        child: Text('el guesaso'),
        // child: ListView.separated(
        //   padding: const EdgeInsets.symmetric(
        //     horizontal: 32.0,
        //     vertical: 24.0,
        //   ),
        //   physics: const ClampingScrollPhysics(),
        //   itemCount: keepWatching.length,
        //   separatorBuilder: (_, __) => const SizedBox(height: 16),
        //   itemBuilder: (context, index) {
        //     final item = keepWatching[index];
        //     return KeepWatchingCard(
        //       cardByPropsWidth: double.infinity,
        //       cardByPropsHeight: 100,
        //       title: item.title,
        //       imagePath: item.imagePath,
        //     );
        //   },
        // ),
      ),
    );
  }
}
