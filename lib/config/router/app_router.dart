import 'package:academa_streaming_platform/presentation/auth/views/sign_in_view_rebrand.dart';
import 'package:academa_streaming_platform/presentation/roadmap/views/roadmaps_view.dart';
import 'package:academa_streaming_platform/presentation/live/views/live_broadcast_stream_view.dart';
import 'package:academa_streaming_platform/presentation/onboarding/onboarding_screen.dart';
import 'package:academa_streaming_platform/presentation/screens/main_screen.dart';
import 'package:academa_streaming_platform/presentation/subject/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/home/views/home_page_rebrand.dart';
import '../../presentation/home/views/role_based_home_page.dart';
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
              builder: (context, state) => const RoleBasedHomePage(),
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
      path: '/live',
      name: 'live',
      builder: (context, state) => const LiveBroadcastScreen(),
    ),

    GoRoute(
      path: '/video-player/:subjectId/:classNumber',
      pageBuilder: (context, state) {
        final subjectId = state.pathParameters['subjectId']!;
        final classNumber =
            int.tryParse(state.pathParameters['classNumber'] ?? '') ?? 0;
        return CustomTransitionPage(
          key: state.pageKey,
          child:
              VideoPlayerScreen(subjectId: subjectId, classNumber: classNumber),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, a, s, child) =>
              FadeTransition(opacity: a, child: child),
        );
      },
    ),

    GoRoute(
      path: '/create-subject',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const Scaffold(
          body: Center(
            child: Text(
              'Create Subject Page - Coming Soon',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
  ],
);
