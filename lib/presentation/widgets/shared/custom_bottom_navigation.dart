import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final String userRole;
  const CustomBottomNavigation({
    super.key,
    required this.userRole,
  });

  int getCurrentIndex(BuildContext context) {
    final String path = GoRouterState.of(context).fullPath!;
    switch (path) {
      case '/':
        return 0;
      case '/search-view':
        return 1;
      case '/roadmap-view':
        return 2;
      case '/profile-view':
        return 3;
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
        context.go('/search-view');
        break;
      case 2:
        context.go('/roadmap-view');
        break;
      case 3:
        context.go('/profile-view');
        break;
    }
  }

  Widget _buildItem(
    BuildContext context, {
    required int index,
    required IconData outlinedIcon,
    required IconData filledIcon,
    required String label,
    required bool selected,
  }) {
    final color = selected ? Colors.white : Colors.grey;
    final iconData = selected ? filledIcon : outlinedIcon;
    return GestureDetector(
      onTap: () => onItemTapped(context, index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, color: color, size: 28),
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
      height: 82,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
            context,
            index: 0,
            outlinedIcon: Icons.home_outlined,
            filledIcon: Icons.home_rounded,
            label: 'Inicio',
            selected: currentIndex == 0,
          ),
          _buildItem(
            context,
            index: 1,
            outlinedIcon: Icons.search_rounded,
            filledIcon: Icons.search,
            label: 'Buscar',
            selected: currentIndex == 1,
          ),
          // if (userRole == 'student')
          _buildItem(
            context,
            index: 2,
            outlinedIcon: Icons.turned_in_not,
            filledIcon: Icons.turned_in,
            label: 'Rutas',
            selected: currentIndex == 2,
          ),
          _buildItem(
            context,
            index: 3,
            outlinedIcon: Icons.person_2_outlined,
            filledIcon: Icons.person_2_rounded,
            label: 'Perfil',
            selected: currentIndex == 3,
          ),
        ],
      ),
    );
  }
}
