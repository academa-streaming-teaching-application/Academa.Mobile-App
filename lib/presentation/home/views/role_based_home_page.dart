// lib/presentation/home/role_based_home_page.dart

import 'package:academa_streaming_platform/presentation/auth/provider/user_provider.dart';
import 'package:academa_streaming_platform/presentation/home/views/home_page_rebrand.dart';
import 'package:academa_streaming_platform/presentation/home/views/teacher_home_page_rebrand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleBasedHomePage extends ConsumerWidget {
  const RoleBasedHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, stackTrace) => const Scaffold(
        body: Center(
          child: Text(
            'Error al cargar usuario',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
      data: (user) {
        if (user == null) {
          // User not authenticated, show student homepage by default
          return const HomePageRebrand();
        }

        // Route based on user role
        switch (user.role.toLowerCase()) {
          case 'teacher':
            return const TeacherHomePageRebrand();
          case 'student':
          default:
            return const HomePageRebrand();
        }
      },
    );
  }
}
