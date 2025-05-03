import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const FilterBar({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onTap,
  });

  static const TextStyle _selectedStyle = TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle _unselectedStyle = TextStyle(
    fontSize: 18,
    color: Colors.grey.shade700,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(filters[i],
                    style: isSelected ? _selectedStyle : _unselectedStyle),
                const SizedBox(height: 4),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFB300FF),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
