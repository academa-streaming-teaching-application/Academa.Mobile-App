import 'package:flutter/material.dart';

class CustomBodyContainer extends StatelessWidget {
  final Widget child;
  const CustomBodyContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 240, 240, 240),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        width: double.infinity,
        height: double.infinity,
        child: child,
      ),
    );
  }
}
