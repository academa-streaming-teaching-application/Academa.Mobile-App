import 'package:academa_streaming_platform/presentation/home/widgets/saved_items_horizontal_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:academa_streaming_platform/presentation/home/widgets/horizontal_slider.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_body_container.dart';
import 'package:go_router/go_router.dart';
import '../provider/class_repository_provider.dart';
import '../widgets/live_banner.dart';
import '../widgets/custom_app_bar.dart';
import 'package:academa_streaming_platform/presentation/auth/provider/auth_provider.dart'; // 🔸

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardHeight = size.height * 0.22;
    final keepWatchingHeight = size.height * 0.12;

    final authState = ref.watch(authProvider);
    final userRole = authState.user?.role ?? ''; // 🔸
    final userId = authState.user?.id ?? ''; // 🔸

    final classesAsync = userRole == 'teacher' // 🔸
        ? ref.watch(fetchClassesByTeacherProvider(userId)) // 🔸
        : ref.watch(fetchAllClassesProvider); // 🔸

    final savedItemsAsync = ref.watch(fetchAllSavedItemsProvider);
    final activeLives = ref.watch(activeLiveStreamsProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: savedItemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (savedItems) {
          return classesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (classes) {
              return CustomBodyContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userRole != 'teacher') // 🔸
                      activeLives.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Center(child: Text('Error: $e')),
                        data: (liveStreams) {
                          if (liveStreams.isEmpty) return const SizedBox();
                          return LiveStreamSwiper(liveStreams: liveStreams);
                        },
                      ),
                    const SizedBox(height: 8),

                    /* ── 4. Contenido principal según rol ────────── */
                    if (userRole == 'teacher') ...[
                      // 🔸
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 8),
                        child: const Text(
                          'Estas son las clases asignadas a ti en las que puedes iniciar sesiones live',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      HorizontalSlider(
                        cards: classes,
                        height: cardHeight,
                      ),
                    ] else ...[
                      HorizontalSlider(
                        cards: classes,
                        height: cardHeight,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 8),
                        child: const Text(
                          'Continúa viendo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SavedItemsHorizontalSlider(
                        height: keepWatchingHeight,
                        assets: savedItems,
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
