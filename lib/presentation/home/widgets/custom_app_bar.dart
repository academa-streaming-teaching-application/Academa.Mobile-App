import 'package:academa_streaming_platform/presentation/home/widgets/search_delegate.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle _subtitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );

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
      BorderRadius.all(Radius.circular(12));

  static const double _searchIconSize = 20.0;

  static const BoxDecoration _iconBg = BoxDecoration(
    color: Color(0xFF2F2F2F),
    shape: BoxShape.circle,
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 62);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Usuario', style: _titleStyle),
          SizedBox(height: 2),
          Text('user@example.com', style: _subtitleStyle),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: _iconBg,
          child: IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: _iconBg,
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: _bottomPadding,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => showSearch<String>(
              context: context,
              delegate: MySearchDelegate(),
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
                  Icon(
                    Icons.search,
                    size: _searchIconSize,
                    color: Colors.white,
                  ),
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
