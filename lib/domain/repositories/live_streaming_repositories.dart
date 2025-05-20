import '../entities/live_model.dart';

abstract class LiveStreamingRepository {
  Future<LiveModel> createSession(String title);
  Future<List<LiveModel>> getSessions();
}
