import 'package:academa_streaming_platform/presentation/live/provider/live_broadcast_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rtmp_broadcaster/camera.dart';
import '../../../domain/repositories/live_streaming_repositories.dart';

const String kTeacherId = 'teacher_123';

class LiveBroadcastScreen extends StatelessWidget {
  const LiveBroadcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LiveBroadcastProvider(
        repository: context.read<LiveStreamingRepository>(),
        teacherId: kTeacherId,
      )..initCamera(),
      child: Consumer<LiveBroadcastProvider>(
        builder: (context, vm, _) {
          if (!vm.cameraReady) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (vm.errorMessage != null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Live')),
              body: Center(
                child: Text(vm.errorMessage!,
                    style: const TextStyle(color: Colors.red)),
              ),
            );
          }
          // vista normal
          return Scaffold(
            body: CameraPreview(vm.controller),
            floatingActionButton: FloatingActionButton(
              backgroundColor: vm.isStreaming ? Colors.red : null,
              onPressed: vm.startingStream
                  ? null
                  : vm.isStreaming
                      ? vm.stopStream
                      : vm.startStream,
              child: vm.startingStream
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Icon(vm.isStreaming ? Icons.stop : Icons.videocam),
            ),
          );
        },
      ),
    );
  }
}
