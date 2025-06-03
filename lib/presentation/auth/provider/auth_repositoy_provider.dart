import 'package:academa_streaming_platform/data/datasource/auth_datasource_impl.dart';
import 'package:academa_streaming_platform/data/repositories/auth_repository_impl.dart';
import 'package:academa_streaming_platform/domain/repositories/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    AuthDataSourceImpl(
      Dio(
        BaseOptions(baseUrl: 'http://192.168.2.43:3000/api/v1/auth'),
      ),
    ),
  ),
);
