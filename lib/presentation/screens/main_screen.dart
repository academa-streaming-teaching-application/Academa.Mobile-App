import 'package:academa_streaming_platform/presentation/auth/provider/user_provider.dart';
import 'package:academa_streaming_platform/presentation/shared/widgets/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerWidget {
  final Widget childView;
  const MainScreen({super.key, required this.childView});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(currentUserRoleProvider);
    return Scaffold(
      extendBody: true,
      body: childView,
      bottomNavigationBar: CustomBottomNavigation(userRole: userRole),
    );
  }
}
