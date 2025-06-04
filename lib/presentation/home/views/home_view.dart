import 'package:academa_streaming_platform/presentation/home/widgets/saved_items_horizontal_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:academa_streaming_platform/presentation/home/widgets/class_filters.dart';
import 'package:academa_streaming_platform/presentation/home/widgets/horizontal_slider.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_body_container.dart';
import '../../providers/class_repository_provider.dart';
import '../provider/class_repository_provider.dart';
import '../widgets/live_banner.dart';
import '../widgets/custom_app_bar.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _selectedFilterIndex = 0;

  static const List<String> _filters = [
    'Todas',
    'Matemáticas',
    'Ciencia',
    'Arte',
    'Historia',
    'Tecnología',
    'Deportes',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardHeight = size.height * 0.22;
    final keepWatchingHeight = size.height * 0.12;

    final classAsync = ref.watch(fetchAllClassesProvider);
    final savedItemsAsync = ref.watch(fetchAllSavedItemsProvider);
    final activeLives = ref.watch(activeLiveStreamsProvider);
    print("$savedItemsAsync");

    return Scaffold(
      appBar: const CustomAppBar(),
      body: savedItemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (savedItems) {
          return classAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (classes) {
              return CustomBodyContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    activeLives.when(
                      // ⬅️ REPLACED: LiveBannerSwiper for real-time data
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      data: (liveStreams) {
                        if (liveStreams.isEmpty) {
                          return const SizedBox();
                        }
                        return LiveStreamSwiper(liveStreams: liveStreams);
                      },
                    ),
                    const SizedBox(height: 16),
                    FilterBar(
                      filters: _filters,
                      selectedIndex: _selectedFilterIndex,
                      onTap: (i) => setState(() => _selectedFilterIndex = i),
                    ),
                    const SizedBox(height: 8),
                    HorizontalSlider(
                      cards: classes,
                      height: cardHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 8),
                      child: Text(
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
