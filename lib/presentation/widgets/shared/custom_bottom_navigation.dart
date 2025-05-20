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
      case '/live-view':
        return 3; // nuevo caso
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
      case 3:
        context.go('/live-view'); // navega a CreateLiveScreen
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
      margin: const EdgeInsets.all(16),
      height: 82,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
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
            outlinedIcon: Icons.turned_in_not,
            filledIcon: Icons.turned_in,
            label: 'Guardados',
            selected: currentIndex == 1,
          ),
          _buildItem(
            context,
            index: 2,
            outlinedIcon: Icons.person_2_outlined,
            filledIcon: Icons.person_2_rounded,
            label: 'Perfil',
            selected: currentIndex == 2,
          ),
          _buildItem(
            context,
            index: 3,
            outlinedIcon: Icons.videocam_outlined,
            filledIcon: Icons.videocam_rounded,
            label: 'Live',
            selected: currentIndex == 3,
          ),
        ],
      ),
    );
  }
}
