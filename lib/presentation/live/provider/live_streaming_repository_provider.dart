import 'package:academa_streaming_platform/data/datasource/live_streaming_datasource_impl.dart';
import 'package:academa_streaming_platform/presentation/auth/provider/auth_repositoy_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:academa_streaming_platform/domain/datasource/live_streaming_datasource.dart';
import 'package:academa_streaming_platform/domain/repositories/live_streaming_repository.dart';
import 'package:academa_streaming_platform/data/repositories/live_streaming_repository_impl.dart';

final liveDataSourceProvider = Provider<LiveDataSource>((ref) {
  final Dio dio = ref.read(dioProvider);

  final tokens = ref.watch(authTokensProvider);
  final access = tokens.accessToken;

  return LiveDataSourceImpl(
    dio,
    accessToken: access,
  );
});

final liveRepositoryProvider = Provider<LiveRepository>((ref) {
  final ds = ref.read(liveDataSourceProvider);
  return LiveRepositoryImpl(ds);
});
