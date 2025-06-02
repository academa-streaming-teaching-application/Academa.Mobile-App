// lib/presentation/live/live_streaming_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rtmp_broadcaster/camera.dart';
import '../../../domain/repositories/live_streaming_repository.dart';
import 'live_streaming_repository_provider.dart';

/*─────────────────────────── STATE ────────────────────────────*/
class LiveStreamParams {
  final String teacherId;
  final String classId;
  final String title;

  const LiveStreamParams({
    required this.teacherId,
    required this.classId,
    required this.title,
  });
}

class LiveStreamingState {
  const LiveStreamingState({
    this.camera,
    this.cameraReady = false,
    this.isStreaming = false,
    this.starting = false,
    this.error,
  });

  final CameraController? camera;
  final bool cameraReady;
  final bool isStreaming;
  final bool starting;
  final String? error;

  LiveStreamingState copyWith({
    CameraController? camera,
    bool? cameraReady,
    bool? isStreaming,
    bool? starting,
    String? error,
  }) {
    return LiveStreamingState(
      camera: camera ?? this.camera,
      cameraReady: cameraReady ?? this.cameraReady,
      isStreaming: isStreaming ?? this.isStreaming,
      starting: starting ?? this.starting,
      error: error,
    );
  }
}

class LiveStreamingNotifier
    extends AutoDisposeFamilyNotifier<LiveStreamingState, LiveStreamParams> {
  late final LiveStreamingRepository _repo;
  late final LiveStreamParams _params;

  @override
  LiveStreamingState build(LiveStreamParams params) {
    _params = params;
    _repo = ref.read(liveStreamingRepositoryProvider);

    ref.onDispose(() => state.camera?.dispose());

    return const LiveStreamingState();
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      final selected = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        selected,
        ResolutionPreset.ultraHigh,
        enableAudio: true,
      );
      await controller.initialize();

      state = state.copyWith(
        camera: controller,
        cameraReady: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Error de cámara: $e');
    }
  }

  Future<void> startStream(String title) async {
    if (!state.cameraReady || state.starting) return;
    state = state.copyWith(starting: true, error: null);

    try {
      final session = await _repo.createSession(
        teacherId: _params.teacherId,
        classId: _params.classId,
        title: title, // ← usamos el título actualizado
      );

      final url = '${session.rtmpUrl}/${session.streamKey}';
      await state.camera!.startVideoStreaming(url, androidUseOpenGL: true);

      state = state.copyWith(isStreaming: true);
    } catch (e) {
      state = state.copyWith(error: 'Falló RTMP: $e');
    } finally {
      state = state.copyWith(starting: false);
    }
  }

  Future<void> stopStream() async {
    if (!state.isStreaming) return;
    await state.camera!.stopVideoStreaming();
    state = state.copyWith(isStreaming: false);
  }
}

final liveStreamingBroadcastProvider = AutoDisposeNotifierProviderFamily<
    LiveStreamingNotifier,
    LiveStreamingState,
    LiveStreamParams>(LiveStreamingNotifier.new);
