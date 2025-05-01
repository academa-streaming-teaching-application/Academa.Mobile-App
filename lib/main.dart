import 'package:academa_streaming_platform/config/router/app_router.dart';
import 'package:academa_streaming_platform/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme().theme(),
      routerConfig: appRouter,
    );
  }
}
