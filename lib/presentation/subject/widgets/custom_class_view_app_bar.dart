import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomClassViewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String classId;
  final String teacherId;
  final String userRole;
  const CustomClassViewAppBar({
    super.key,
    required this.title,
    required this.classId,
    required this.teacherId,
    required this.userRole,
  });

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
      title: Text(title, style: _titleStyle),
      leading: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: _iconBg,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      actions: [
        if (userRole == 'teacher')
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: _iconBg,
            child: IconButton(
              icon: const Icon(Icons.video_call_outlined, color: Colors.white),
              onPressed: () => context
                  .push('/live-view?classId=$classId&teacherId=$teacherId'),
            ),
          ),
      ],
    );
  }
}
