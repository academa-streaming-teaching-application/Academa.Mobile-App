import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rtmp_broadcaster/camera.dart';
import '../../../domain/repositories/live_streaming_repository.dart';
import '../provider/live_streaming_broadcast_provider.dart';

const String demoTeacherId = 'teacher_123';

class LiveBroadcastScreen extends StatelessWidget {
  const LiveBroadcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LiveStreamingBroadcastProvider(
        repository: context.read<LiveStreamingRepository>(),
        teacherId: demoTeacherId,
      )..initCamera(),
      child: Consumer<LiveStreamingBroadcastProvider>(
        builder: (context, liveBroadcastProvider, _) {
          if (!liveBroadcastProvider.cameraReady) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (liveBroadcastProvider.errorMessage != null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Live')),
              body: Center(
                child: Text(
                  liveBroadcastProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          return Scaffold(
            body: CameraPreview(liveBroadcastProvider.controller),
            floatingActionButton: FloatingActionButton(
              backgroundColor:
                  liveBroadcastProvider.isStreaming ? Colors.red : null,
              onPressed: liveBroadcastProvider.startingStream
                  ? null
                  : liveBroadcastProvider.isStreaming
                      ? liveBroadcastProvider.stopStream
                      : liveBroadcastProvider.startStream,
              child: liveBroadcastProvider.startingStream
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Icon(
                      liveBroadcastProvider.isStreaming
                          ? Icons.stop
                          : Icons.videocam,
                    ),
            ),
          );
        },
      ),
    );
  }
}
