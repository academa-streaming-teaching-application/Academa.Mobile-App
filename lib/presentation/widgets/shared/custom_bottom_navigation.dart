import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  int getCurrentIndex(BuildContext context) {
    final String path = GoRouterState.of(context).fullPath!;
    switch (path) {
      case '/':
        return 0;

      case '/favorites-view':
        return 1;

      case '/profile-view':
        return 2;
      default:
        return 0;
    }
  }

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/favorites-view');
        break;
      case 2:
        context.go('/profile-view');
        break;
    }
  }

  Widget _buildItem(BuildContext context, int index, IconData icon,
      String label, bool selected) {
    Color color = selected ? Colors.white : Colors.grey;
    return GestureDetector(
      onTap: () => onItemTapped(context, index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = getCurrentIndex(context);

    return Container(
      margin: EdgeInsets.all(16),
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
              context, 0, Icons.home_filled, 'Inicio', currentIndex == 0),
          _buildItem(context, 1, Icons.save, 'Guardados', currentIndex == 1),
          _buildItem(context, 2, Icons.person, 'Perfil', currentIndex == 2),
        ],
      ),
    );
  }
}
