import 'package:academa_streaming_platform/data/datasource/auth_datasource_impl.dart';
import 'package:academa_streaming_platform/data/datasource/live_streaming_datasource_impl.dart';
import 'package:academa_streaming_platform/data/repositories/auth_repository_impl.dart';
import 'package:academa_streaming_platform/data/repositories/live_streaming_repository_impl.dart';
import 'package:academa_streaming_platform/domain/repositories/user_repository.dart';
import 'package:academa_streaming_platform/presentation/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'domain/repositories/live_streaming_repository.dart';

void main() {
  // TODO: CHANGE THIS A ENV VARIABLE
  final dio = Dio(BaseOptions(baseUrl: 'http://192.168.2.52:3000/api/v1'));

  final liveDataSource = LiveStreamingDataSourceImpl(dio);
  final liveRepo = LiveStreamingRepositoryImpl(liveDataSource);

  final authDataSource = AuthRemoteDataSource(dio);
  final authRepo = AuthRepositoryImpl(authDataSource);

  runApp(
    MultiProvider(
      providers: [
        Provider<LiveStreamingRepository>.value(value: liveRepo),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepo),
        ),
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
