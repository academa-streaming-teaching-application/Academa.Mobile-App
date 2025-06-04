import 'package:academa_streaming_platform/data/datasource/class_datasource_impl.dart';
import 'package:academa_streaming_platform/data/repositories/class_repository_impl.dart';
import 'package:academa_streaming_platform/domain/repositories/class_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final classRepositoryProvider = Provider<ClassRepository>(
  (ref) => ClassRepositoryImpl(
    ClassDataSourceImpl(
      Dio(
        BaseOptions(baseUrl: 'http://192.168.2.43:3000/api/v1/class'),
      ),
    ),
  ),
);
