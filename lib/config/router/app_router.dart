import 'package:academa_streaming_platform/presentation/auth/views/sign_in_view.dart';
import 'package:academa_streaming_platform/presentation/auth/views/sign_up_view.dart';
import 'package:academa_streaming_platform/presentation/favorites/views/favorites_view.dart';
import 'package:academa_streaming_platform/presentation/home/views/home_view.dart';
import 'package:academa_streaming_platform/presentation/onboarding/onboarding_screen.dart';
import 'package:academa_streaming_platform/presentation/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

    //

    GoRoute(
      path: '/sign-up',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SignUpView(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),

    //

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
              path: '/',
              builder: (context, state) => const HomeView(),
            ),
          ],
        ),
      ],
    ),
  ],
);
