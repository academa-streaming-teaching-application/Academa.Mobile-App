import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomFavoritesAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomFavoritesAppBar({super.key});

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static const BoxDecoration _iconBg = BoxDecoration(
    color: Color(0xFF2F2F2F),
    shape: BoxShape.circle,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 62);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      forceMaterialTransparency: true,
      title: Text('Guardados', style: _titleStyle),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: _iconBg,
          child: IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
