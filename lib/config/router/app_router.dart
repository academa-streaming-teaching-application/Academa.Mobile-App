import 'package:academa_streaming_platform/presentation/auth/views/sign_in_view_rebrand.dart';
import 'package:academa_streaming_platform/presentation/class/views/class_view.dart';
import 'package:academa_streaming_platform/presentation/live/views/live_broadcast_stream_view.dart';
import 'package:academa_streaming_platform/presentation/profile/views/profile_view.dart';
import 'package:academa_streaming_platform/presentation/favorites/views/favorites_view.dart';
import 'package:academa_streaming_platform/presentation/home/views/home_view.dart';
import 'package:academa_streaming_platform/presentation/onboarding/onboarding_screen.dart';
import 'package:academa_streaming_platform/presentation/screens/main_screen.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/mux_video_player.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/home/views/home_page_rebrand.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const HomePageRebrand(),
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
              builder: (context, state) => const HomeView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites-view',
              builder: (context, state) => const FavoritesView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile-view',
              builder: (context, state) => const ProfileView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeView(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/class-view',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ClassView(),
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
