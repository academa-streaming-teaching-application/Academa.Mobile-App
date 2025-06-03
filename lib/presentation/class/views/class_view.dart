import 'package:academa_streaming_platform/presentation/class/widgets/custom_class_view_app_bar.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/keep_watching.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_body_container.dart';
import 'package:go_router/go_router.dart';

import '../provider/class_by_id_provider.dart';

class ClassView extends ConsumerWidget {
  const ClassView({super.key});

  static const TextStyle _liveLabelStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classId = GoRouterState.of(context).uri.queryParameters['id'];

    if (classId == null) {
      return const Scaffold(
        body: Center(child: Text('No class ID provided')),
      );
    }

    final classAsync = ref.watch(fetchClassByIdProvider(classId));
    final savedAssetsAsync =
        ref.watch(fetchSavedAssetsByClassIdProvider(classId));

    final size = MediaQuery.of(context).size;

    return classAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (classData) {
        return savedAssetsAsync.when(
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Scaffold(
            body: Center(child: Text('Error loading videos: $e')),
          ),
          data: (savedAssets) => Scaffold(
            backgroundColor: Colors.black,
            appBar: CustomClassViewAppBar(
              title: classData.type!,
              classId: classData.id,
              teacherId: classData.teacherId!,
            ),
            body: CustomBodyContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          classData.title,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: size.width * 0.2,
                          height: size.height * 0.04,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB300FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Siguiendo',
                              style: _liveLabelStyle,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: CustomButton(
                      text: 'LIVE - PARAMETRIZACIÓN',
                      textColor: Colors.white,
                      backgroundColor: Colors.black,
                      textSize: 16,
                      buttonWidth: size.width,
                      buttonHeight: size.height * 0.07,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (savedAssets.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'No hay grabaciones disponibles para esta clase.',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        itemCount: savedAssets.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final asset = savedAssets[index];
                          return KeepWatchingCard(
                            cardByPropsHeight: 100,
                            title: asset.title ?? 'Video sin título',
                            imagePath:
                                'lib/config/assets/productivity_square.png',
                            onPlay: () {
                              context.push(
                                  '/player?playbackId=${asset.playbackId}');
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
