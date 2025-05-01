import 'package:academa_streaming_platform/presentation/auth/screen/sign_in_screen.dart';
import 'package:academa_streaming_platform/presentation/onboarding/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SignInScreen(),
    ),
  ],
);
