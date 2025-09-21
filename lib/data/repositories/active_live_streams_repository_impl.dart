import 'package:academa_streaming_platform/domain/datasource/active_live_streams_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:academa_streaming_platform/domain/repositories/active_live_streams_repository.dart';

class ActiveLiveStreamsRepositoryImpl implements ActiveLiveStreamsRepository {
  final ActiveLiveStreamsDataSource _dataSource;

  ActiveLiveStreamsRepositoryImpl(this._dataSource);

  @override
  Future<List<LiveSessionEntity>> getActiveLiveStreams() async {
    return await _dataSource.getActiveLiveStreams();
  }
}