import 'package:academa_streaming_platform/presentation/auth/views/sign_in_view_rebrand.dart';
import 'package:academa_streaming_platform/presentation/roadmap/views/roadmaps_view.dart';
import 'package:academa_streaming_platform/presentation/live/views/live_broadcast_stream_view.dart';
import 'package:academa_streaming_platform/presentation/onboarding/onboarding_screen.dart';
import 'package:academa_streaming_platform/presentation/screens/main_screen.dart';
import 'package:academa_streaming_platform/presentation/shared/widgets/mux_video_player.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/home/views/home_page_rebrand.dart';
import '../../presentation/profile/views/profile_rebrand_view.dart';
import '../../presentation/roadmap/views/subject_in_roadmap_view.dart';
import '../../presentation/search/views/search_view.dart';
import '../../presentation/subject/views/subject_view_rebrand.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    //

    GoRoute(
      path: '/sign-in',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SignInView(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(childView: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePageRebrand(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/roadmap-view',
              builder: (context, state) => const RoadmapsView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile-view',
              builder: (context, state) => const ProfileRebrandView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search-view',
              builder: (context, state) => const SearchView(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/subject-view/:id',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: SubjectViewRebrand(
          subjectId: state.pathParameters['id']!,
        ),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    GoRoute(
      path: '/roadmap-subjects',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SubjectInRoadmapView(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/live-view',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LiveBroadcastScreen(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/player',
      pageBuilder: (context, state) {
        final playbackId = state.uri.queryParameters['playbackId'];

        return CustomTransitionPage(
          key: state.pageKey,
          child: MuxVideoPlayer(playbackId: playbackId ?? ''),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),

    // GoRoute(
    //   path: '/player',
    //   pageBuilder: (context, state) {
    //     final playbackId = state.uri.queryParameters['playbackId'];
    //     final liveStreamId = state.uri.queryParameters['liveStreamId'];
    //     final teacherName = state.uri.queryParameters['teacherName'];
    //     final avatarUrl = state.uri.queryParameters['avatarUrl'];
    //     final title = state.uri.queryParameters['title'];

    //     return CustomTransitionPage(
    //       key: state.pageKey,
    //       child: LiveStreamWatchScreen(
    //         playbackId: playbackId ?? '',
    //         liveStreamId: liveStreamId ?? '',
    //         teacherName: teacherName ?? 'Anónimo',
    //         avatarUrl: 'lib/config/assets/productivity_square.png',
    //         title: title ?? '',
    //       ),
    //       transitionDuration: const Duration(milliseconds: 400),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         return FadeTransition(opacity: animation, child: child);
    //       },
    //     );
    //   },
    // ),
  ],
);
