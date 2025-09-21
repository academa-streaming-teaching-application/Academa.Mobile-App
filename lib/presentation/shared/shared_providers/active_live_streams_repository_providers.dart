import 'dart:async';
import 'package:academa_streaming_platform/data/datasource/active_live_streams_datasource_impl.dart';
import 'package:academa_streaming_platform/data/repositories/active_live_streams_repository_impl.dart';
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:academa_streaming_platform/domain/repositories/active_live_streams_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/provider/auth_repositoy_provider.dart';

final activeLiveStreamsRepositoryProvider = Provider<ActiveLiveStreamsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ActiveLiveStreamsRepositoryImpl(
    ActiveLiveStreamsDataSourceImpl(dio),
  );
});

final activeLiveStreamsProvider =
    FutureProvider.autoDispose<List<LiveSessionEntity>>((ref) async {
  // Wait for auth tokens to be loaded before making the request
  final authTokens = ref.watch(authTokensProvider);

  // If no access token, return empty list (user not authenticated)
  if (authTokens.accessToken == null) {
    return <LiveSessionEntity>[];
  }

  final repository = ref.watch(activeLiveStreamsRepositoryProvider);

  final link = ref.keepAlive();
  Timer(const Duration(minutes: 2), link.close);

  return repository.getActiveLiveStreams();
});

final refreshActiveLiveStreamsProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(activeLiveStreamsProvider);
  };
});