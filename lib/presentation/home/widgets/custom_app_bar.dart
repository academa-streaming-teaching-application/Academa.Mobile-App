import 'package:academa_streaming_platform/presentation/home/widgets/search_class_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/provider/auth_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  /* ────────── style constants ────────── */
  static const TextStyle _titleStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle _subtitleStyle =
      TextStyle(color: Colors.white, fontSize: 14);
  static const TextStyle _searchPlaceholderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w200,
    color: Colors.white,
  );
  static const EdgeInsets _bottomPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const double _searchBoxHeight = 48.0;
  static const EdgeInsets _searchBoxPadding =
      EdgeInsets.symmetric(horizontal: 16);
  static const BorderRadius _searchBoxRadius =
      BorderRadius.all(Radius.circular(16));
  static const double _searchIconSize = 20.0;
  static const BoxDecoration _iconBg =
      BoxDecoration(color: Color(0xFF2F2F2F), shape: BoxShape.circle);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 62);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    /* ── 1. Read the user (synchronous) ───────────────────── */
    /// Change the selector to match your real data model.
    ///   • If `authProvider` *is* the user, just do:
    ///         final user = ref.watch(authProvider);
    ///   • If `authProvider` gives an object that contains a
    ///     user field, select it:
    ///         final user = ref.watch(authProvider).user;
    final user = ref.watch(authProvider); // <== adapt as needed

    final displayName = user.user?.name ?? 'Invitado';
    final email = user.user?.email ?? '';

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(displayName, style: _titleStyle),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: colorScheme.primary),
              const SizedBox(width: 4),
              Text(email, style: _subtitleStyle),
            ],
          ),
        ],
      ),
      actions: [
        /* 🔔 Notifications */
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: _iconBg,
          child: IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ],
      /* 🔍 Search bar under the AppBar */
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: _bottomPadding,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => showSearch<void>(
              context: context,
              delegate: SearchClassDelegate(),
            ),
            child: Container(
              height: _searchBoxHeight,
              padding: _searchBoxPadding,
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: _searchBoxRadius,
              ),
              alignment: Alignment.centerLeft,
              child: const Row(
                children: [
                  Icon(Icons.search,
                      size: _searchIconSize, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Buscar...', style: _searchPlaceholderStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
