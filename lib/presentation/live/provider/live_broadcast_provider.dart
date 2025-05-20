import 'package:flutter/material.dart';
import 'package:rtmp_broadcaster/camera.dart'; // ← único import
import '../../../domain/repositories/live_streaming_repositories.dart';

class LiveBroadcastProvider extends ChangeNotifier {
  LiveBroadcastProvider({
    required LiveStreamingRepository repository,
    required this.teacherId,
  }) : _repository = repository;

  final LiveStreamingRepository _repository;
  final String teacherId;

  CameraController? _camera;

  bool cameraReady = false;
  bool isStreaming = false;
  bool startingStream = false;
  String? errorMessage;

  Future<void> initCamera() async {
    try {
      final List<CameraDescription> cameras = await availableCameras();

      final CameraDescription selected = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _camera = CameraController(
        selected,
        ResolutionPreset.ultraHigh,
        enableAudio: true,
      );
      await _camera!.initialize();

      cameraReady = true;
    } catch (e) {
      errorMessage = 'Error de cámara: $e';
    }
    notifyListeners();
  }

  Future<void> startStream() async {
    if (!cameraReady) return;
    startingStream = true;
    errorMessage = null;
    notifyListeners();

    try {
      final session = await _repository.createSession(teacherId);
      final fullUrl = '${session.rtmpUrl}/${session.streamKey}';
      debugPrint('▶ RTMP push → $fullUrl');

      await _camera!.startVideoStreaming(
        fullUrl,
        androidUseOpenGL: true,
      );

      debugPrint('✅ RTMP push started');
      isStreaming = true;
    } catch (e) {
      errorMessage = 'Falló RTMP: $e';
      debugPrint('❌ $e');
    } finally {
      startingStream = false;
      notifyListeners();
    }
  }

  Future<void> stopStream() async {
    await _camera!.stopVideoStreaming();
    isStreaming = false;
    notifyListeners();
  }

  CameraController get controller => _camera!;
}
