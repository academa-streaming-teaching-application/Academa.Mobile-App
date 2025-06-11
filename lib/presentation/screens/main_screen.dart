import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 🔸
import 'package:academa_streaming_platform/presentation/auth/provider/auth_provider.dart'; // 🔸
import 'package:academa_streaming_platform/presentation/widgets/shared/custom_bottom_navigation.dart';

class MainScreen extends ConsumerWidget {
  // 🔸
  final Widget childView;
  const MainScreen({super.key, required this.childView});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🔸
    // ── rol del usuario ────────────────────────────────────────────────
    final userRole = ref.watch(
      authProvider.select((s) => s.user?.role ?? ''),
    ); // 🔸

    return Scaffold(
      extendBody: true,
      body: childView,
      bottomNavigationBar: CustomBottomNavigation(userRole: userRole), // 🔸
    );
  }
}
