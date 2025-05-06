import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  const Separator({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: color, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(text, style: TextStyle(color: color)),
        ),
        Expanded(child: Divider(color: color, thickness: 1)),
      ],
    );
  }
}
