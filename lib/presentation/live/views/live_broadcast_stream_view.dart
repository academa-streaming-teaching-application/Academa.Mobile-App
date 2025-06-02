// lib/presentation/live/live_broadcast_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rtmp_broadcaster/camera.dart';
import '../provider/live_streaming_notifier.dart';

class LiveBroadcastScreen extends ConsumerStatefulWidget {
  const LiveBroadcastScreen({super.key});

  @override
  ConsumerState<LiveBroadcastScreen> createState() =>
      _LiveBroadcastScreenState();
}

class _LiveBroadcastScreenState extends ConsumerState<LiveBroadcastScreen> {
  final TextEditingController _titleController = TextEditingController();

  late final String teacherId;
  late final String classId;
  LiveStreamParams? params;

  bool _cameraInitialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final query = GoRouterState.of(context).uri.queryParameters;
      teacherId = query['teacherId'] ?? '';
      classId = query['classId'] ?? '';

      setState(() {
        params = LiveStreamParams(
          teacherId: teacherId,
          classId: classId,
          title: 'Clase en Vivo',
        );
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (params == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final state = ref.watch(liveStreamingBroadcastProvider(params!));
    final notifier = ref.read(liveStreamingBroadcastProvider(params!).notifier);

    if (!_cameraInitialized && !state.cameraReady) {
      _cameraInitialized = true;
      notifier.initCamera();
    }

    if (state.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Live')),
        body: Center(
          child: Text(state.error!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    if (!state.cameraReady || state.camera == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: LayoutBuilder(
        builder: (context, constraints) {
          final keyboardVisible =
              MediaQuery.of(context).viewInsets.bottom > 100;
          return Stack(
            children: [
              Positioned.fill(
                child: CameraPreview(state.camera!),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (state.isStreaming) {
                      notifier.stopStream();
                    }
                    context.pop();
                  },
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 1),
                curve: Curves.easeOut,
                bottom: keyboardVisible
                    ? MediaQuery.of(context).viewInsets.bottom
                    : 130,
                left: 20,
                right: 20,
                child: TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Add a title...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    filled: true,
                    fillColor: Colors.black54,
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // ✅ FAB no se mueve nunca
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: state.starting
            ? null
            : state.isStreaming
                ? notifier.stopStream
                : () => notifier.startStream(
                      _titleController.text.trim().isEmpty
                          ? 'Clase en Vivo'
                          : _titleController.text.trim(),
                    ),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: state.isStreaming ? Colors.red : Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: state.starting
                ? const CircularProgressIndicator(color: Colors.black)
                : Icon(
                    state.isStreaming ? Icons.stop : Icons.wifi_tethering,
                    size: 32,
                    color: state.isStreaming ? Colors.white : Colors.black,
                  ),
          ),
        ),
      ),
    );
  }
}
