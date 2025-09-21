// lib/presentation/home/home_page_rebrand.dart

import 'package:academa_streaming_platform/presentation/home/widgets/keep_watching_card.dart';
import 'package:academa_streaming_platform/presentation/home/widgets/onlive_video_card.dart';
import 'package:academa_streaming_platform/presentation/shared/shared_providers/active_live_streams_repository_providers.dart';
import 'package:academa_streaming_platform/presentation/shared/shared_providers/watch_history_repository_providers.dart';
import 'package:academa_streaming_platform/presentation/shared/shared_providers/subject_repository_providers.dart'
    show TopRatedParams, topRatedSubjectsFutureProvider;
import 'package:academa_streaming_platform/presentation/shared/widgets/top_rated_subject_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/subject_entity.dart';

class HomePageRebrand extends ConsumerWidget {
  const HomePageRebrand({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = const TopRatedParams(limit: 10, minRatings: 3);
    final topRatedAsync = ref.watch(topRatedSubjectsFutureProvider(params));

    // Watch the new providers
    final activeLiveStreamsAsync = ref.watch(activeLiveStreamsProvider);
    final watchHistoryParams = const WatchHistoryParams(limit: 10);
    final watchHistoryAsync =
        ref.watch(watchHistoryProvider(watchHistoryParams));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset('lib/config/assets/academa_logo.svg',
                width: 16, height: 16),
            const SizedBox(width: 4),
            const Text('Academa',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Activos
            const _SectionTitle('Live Activos'),
            SizedBox(
              height: 300,
              child: activeLiveStreamsAsync.when(
                loading: () => const _LoadingList(height: 300),
                error: (e, _) =>
                    _ErrorMessage(message: 'Error al cargar lives: $e'),
                data: (liveStreams) {
                  if (liveStreams.isEmpty) {
                    return const Center(
                      child: Text('No hay streams activos en este momento.',
                          style: TextStyle(color: Colors.white70)),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: liveStreams.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (_, index) => OnLiveVideoCard(
                      liveStream: liveStreams[index],
                      onTap: () {
                        context.push(
                            '/video-player/${liveStreams[index].subjectId}/${liveStreams[index].classNumber}');
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Continúa viendo
            const _SectionTitle('Continúa viendo'),
            SizedBox(
              height: 100,
              child: watchHistoryAsync.when(
                loading: () => const _LoadingList(height: 100),
                error: (e, _) =>
                    _ErrorMessage(message: 'Error al cargar historial: $e'),
                data: (watchHistory) {
                  if (watchHistory.isEmpty) {
                    return const Center(
                      child: Text('No hay videos en progreso.',
                          style: TextStyle(color: Colors.white70)),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: watchHistory.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (_, index) => KeepWatchingCard(
                      watchHistory: watchHistory[index],
                      onTap: () {
                        // Navigate to continue watching
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) => VideoPlayerScreen(
                        //     subjectId: watchHistory[index].subjectId,
                        //     classNumber: watchHistory[index].classNumber,
                        //   ),
                        // ));
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Top Clases
            const _SectionTitle('Top Clases'),
            SizedBox(
              height: 250,
              child: topRatedAsync.when(
                loading: () => const _TopRatedLoadingList(),
                error: (e, _) => _TopRatedError(message: '$e'),
                data: (List<SubjectEntity> subjects) {
                  if (subjects.isEmpty) {
                    return const Center(
                      child: Text('No hay materias con ratings suficientes.',
                          style: TextStyle(color: Colors.white70)),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: subjects.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, i) =>
                        TopRatedSubjectCard(subject: subjects[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  final double height;

  const _LoadingList({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, __) => Container(
          width: height == 100 ? 290 : 290,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: const TextStyle(color: Colors.redAccent),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _TopRatedLoadingList extends StatelessWidget {
  const _TopRatedLoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(width: 16),
      itemBuilder: (_, __) => Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }
}

class _TopRatedError extends StatelessWidget {
  final String message;
  const _TopRatedError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text('Error: $message',
        style: const TextStyle(color: Colors.redAccent));
  }
}
