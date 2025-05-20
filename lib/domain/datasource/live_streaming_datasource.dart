import 'package:academa_streaming_platform/domain/entities/live_model.dart';

abstract class LiveStreamingDataSource {
  Future<LiveModel> createLiveSession(String title);

  Future<List<LiveModel>> fetchSessions();
}
