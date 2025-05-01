import 'package:academa_streaming_platform/presentation/screens/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => OnboardingScreen(),
    ),
  ],
);
