import 'package:academa_streaming_platform/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  final Widget childView;
  const MainScreen({super.key, required this.childView});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: childView,
      bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 240, 240, 240)),
          child: CustomBottomNavigation()),
    );
  }
}
