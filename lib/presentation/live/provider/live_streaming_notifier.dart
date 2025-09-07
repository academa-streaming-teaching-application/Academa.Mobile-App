// lib/presentation/live/provider/live_streaming_notifier.dart

import 'package:academa_streaming_platform/domain/repositories/live_streaming_repository.dart';
import 'package:academa_streaming_platform/presentation/live/provider/live_streaming_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rtmp_broadcaster/camera.dart';

/*─────────────────────────── STATE ────────────────────────────*/
class LiveStreamParams {
  final String subjectId;
  final int classNumber;
  final String? title;

  const LiveStreamParams({
    required this.subjectId,
    required this.classNumber,
    this.title,
  });
}

class LiveStreamingState {
  const LiveStreamingState({
    this.camera,
    this.cameraDescription,
    this.cameraReady = false,
    this.isStreaming = false,
    this.starting = false,
    this.error,
    this.sessionId,
    this.liveStreamId,
    this.streamKey,
    this.rtmpServer,
    this.playbackId,
  });

  final CameraController? camera;
  final CameraDescription? cameraDescription;
  final bool cameraReady;
  final bool isStreaming;
  final bool starting;
  final String? error;

  // 🔹 campos necesarios para stop/complete y depurar ingest
  final String? sessionId;
  final String? liveStreamId;
  final String? streamKey;
  final String? rtmpServer;
  final String? playbackId;

  LiveStreamingState copyWith({
    CameraController? camera,
    CameraDescription? cameraDescription,
    bool? cameraReady,
    bool? isStreaming,
    bool? starting,
    String? error,
    String? sessionId,
    String? liveStreamId,
    String? streamKey,
    String? rtmpServer,
    String? playbackId,
  }) {
    return LiveStreamingState(
      camera: camera ?? this.camera,
      cameraDescription: cameraDescription ?? this.cameraDescription,
      cameraReady: cameraReady ?? this.cameraReady,
      isStreaming: isStreaming ?? this.isStreaming,
      starting: starting ?? this.starting,
      error: error,
      sessionId: sessionId ?? this.sessionId,
      liveStreamId: liveStreamId ?? this.liveStreamId,
      streamKey: streamKey ?? this.streamKey,
      rtmpServer: rtmpServer ?? this.rtmpServer,
      playbackId: playbackId ?? this.playbackId,
    );
  }
}

class LiveStreamingNotifier
    extends AutoDisposeFamilyNotifier<LiveStreamingState, LiveStreamParams> {
  late final LiveRepository _repo;
  late final LiveStreamParams _params;

  @override
  LiveStreamingState build(LiveStreamParams params) {
    _params = params;
    _repo = ref.read(liveRepositoryProvider);
    ref.onDispose(() => state.camera?.dispose());
    return const LiveStreamingState();
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      // Se selecciona la cámara trasera por defecto
      final selected = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
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
        cameraDescription: selected, // Se guarda la descripción
        cameraReady: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Error de cámara: $e');
    }
  }

  Future<void> switchCamera() async {
    if (state.isStreaming || state.cameraDescription == null) {
      return;
    }

    await state.camera!.dispose();

    try {
      final cameras = await availableCameras();
      final newCamera = cameras.firstWhere(
        (c) => c.lensDirection != state.cameraDescription!.lensDirection,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        newCamera,
        ResolutionPreset.ultraHigh,
        enableAudio: true,
      );
      await controller.initialize();

      state = state.copyWith(
        camera: controller,
        cameraDescription: newCamera, // Se actualiza la descripción
        cameraReady: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Error al cambiar de cámara: $e');
    }
  }

  Future<void> startStream([String? title]) async {
    if (!state.cameraReady || state.starting) return;
    state = state.copyWith(starting: true, error: null);

    try {
      final session = await _repo.startLiveSession(
        _params.subjectId,
        _params.classNumber,
      );

      state = state.copyWith(
        sessionId: session.id,
        liveStreamId: session.liveStreamId,
        streamKey: session.streamKey,
        rtmpServer: session.rtmpServer,
        playbackId: session.playbackId,
      );

      String ingest = state.rtmpServer ?? 'rtmp://global-live.mux.com:5222/app';
      if (ingest.startsWith('rtmps://')) {
        ingest = 'rtmp://global-live.mux.com:5222/app';
      }
      final url = '$ingest/${state.streamKey}';

      print("url rtpm:" + " " + url);

      await state.camera!.startVideoStreaming(
        url,
        androidUseOpenGL: true,
      );

      state = state.copyWith(isStreaming: true);
    } catch (e) {
      state = state.copyWith(error: 'Falló RTMP: $e');
    } finally {
      state = state.copyWith(starting: false);
    }
  }

  Future<void> stopAndComplete() async {
    if (state.isStreaming) {
      try {
        await state.camera?.stopVideoStreaming();
      } catch (_) {/* no-op */}
      state = state.copyWith(isStreaming: false);
    }

    // 2) avisar al backend para forzar cierre inmediato del live
    final sid = state.sessionId;
    if (sid != null && sid.isNotEmpty) {
      try {
        await _repo.completeLiveSession(sid);
      } catch (e) {
        state = state.copyWith(error: 'No se pudo completar el live: $e');
      }
    }
  }

  Future<void> stopStream() async {
    if (!state.isStreaming) return;
    await state.camera!.stopVideoStreaming();
    state = state.copyWith(isStreaming: false);
  }
}

final liveStreamingBroadcastProvider = AutoDisposeNotifierProviderFamily<
    LiveStreamingNotifier, LiveStreamingState, LiveStreamParams>(
  LiveStreamingNotifier.new,
);
