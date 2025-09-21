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
  final repository = ref.watch(activeLiveStreamsRepositoryProvider);

  final link = ref.keepAlive();
  Timer(const Duration(minutes: 2), link.close);

  return repository.getActiveLiveStreams();
});