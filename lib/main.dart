import 'package:academa_streaming_platform/data/datasource/live_remote_data_source.dart';
import 'package:academa_streaming_platform/data/repositories/live_streaming_repository.dart';
import 'package:academa_streaming_platform/domain/repositories/live_streaming_repositories.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';

void main() {
  // ════════════════ Repositorios ════════════════
  final dio = Dio(BaseOptions(baseUrl: 'http://192.168.2.52:3000/api/v1'));

  // Streaming
  final liveDataSource = LiveRemoteDataSource(dio);
  final liveRepo = LiveStreamingRepositoryImpl(liveDataSource);

  runApp(
    MultiProvider(
      providers: [
        Provider<LiveStreamingRepository>.value(value: liveRepo),
        // futuros providers aquí
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Academa Streaming',
      theme: AppTheme().theme(),
      routerConfig: appRouter,
    );
  }
}
