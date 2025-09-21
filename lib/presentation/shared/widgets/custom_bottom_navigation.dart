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

    // For teachers, profile is at index 2 instead of 3
    if (userRole == 'teacher') {
      switch (path) {
        case '/':
          return 0;
        case '/search-view':
          return 1;
        case '/profile-view':
          return 2;
        default:
          return 0;
      }
    } else {
      // For students, keep original indexes
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
  }

  void onItemTapped(BuildContext context, int index) {
    if (userRole == 'teacher') {
      // For teachers: index 2 is profile (no roadmap)
      switch (index) {
        case 0:
          context.go('/');
          break;
        case 1:
          context.go('/search-view');
          break;
        case 2:
          context.go('/profile-view');
          break;
      }
    } else {
      // For students: keep original navigation
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

    // Build navigation items based on user role
    List<Widget> navigationItems = [
      // Home - always visible
      _buildItem(
        context,
        index: 0,
        outlinedIcon: Icons.home_outlined,
        filledIcon: Icons.home_rounded,
        label: 'Inicio',
        selected: currentIndex == 0,
      ),
      // Search - always visible
      _buildItem(
        context,
        index: 1,
        outlinedIcon: Icons.search_rounded,
        filledIcon: Icons.search,
        label: 'Buscar',
        selected: currentIndex == 1,
      ),
    ];

    // Add roadmap only for students
    if (userRole == 'student') {
      navigationItems.add(
        _buildItem(
          context,
          index: 2,
          outlinedIcon: Icons.turned_in_not,
          filledIcon: Icons.turned_in,
          label: 'Rutas',
          selected: currentIndex == 2,
        ),
      );
    }

    // Profile - always visible (index 2 for teachers, 3 for students)
    navigationItems.add(
      _buildItem(
        context,
        index: userRole == 'teacher' ? 2 : 3,
        outlinedIcon: Icons.person_2_outlined,
        filledIcon: Icons.person_2_rounded,
        label: 'Perfil',
        selected: currentIndex == (userRole == 'teacher' ? 2 : 3),
      ),
    );

    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navigationItems,
      ),
    );
  }
}
