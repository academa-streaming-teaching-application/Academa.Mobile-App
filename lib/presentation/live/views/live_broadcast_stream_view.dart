// lib/presentation/live/live_broadcast_screen.dart

import 'package:academa_streaming_platform/presentation/live/provider/live_streaming_notifier.dart';
import 'package:academa_streaming_platform/presentation/subject/widgets/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rtmp_broadcaster/camera.dart';

class LiveBroadcastScreen extends ConsumerStatefulWidget {
  const LiveBroadcastScreen({super.key});

  @override
  ConsumerState<LiveBroadcastScreen> createState() =>
      _LiveBroadcastScreenState();
}

class _LiveBroadcastScreenState extends ConsumerState<LiveBroadcastScreen> {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();

  late String subjectId;
  late int classNumber;

  LiveStreamParams? params;
  bool _cameraInitialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = GoRouterState.of(context);

      final q = s.uri.queryParameters;
      final qSubjectId = q['subjectId'];
      final qClassNumber = int.tryParse(q['classNumber'] ?? '');

      final p = s.pathParameters;
      final pSubjectId = p['subjectId'];
      final pClassNumber = int.tryParse(p['classNumber'] ?? '');

      subjectId = (qSubjectId ?? pSubjectId ?? '').trim();
      classNumber = (qClassNumber ?? pClassNumber ?? 1);

      final suggestedTitle = 'Clase $classNumber';

      setState(() {
        params = LiveStreamParams(
          subjectId: subjectId,
          classNumber: classNumber,
          title: suggestedTitle,
        );
        _titleController.text = suggestedTitle;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _showChat() {
    ClassChatBottomSheet.show(context, subjectId, classNumber);
  }

  void _hideKeyboard() {
    _titleFocusNode.unfocus();
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
          child: Text(
            state.error!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
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
      body: GestureDetector(
        onTap: _hideKeyboard,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final keyboardVisible =
                MediaQuery.of(context).viewInsets.bottom > 100;
            return Stack(
              children: [
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: state.camera!.value.previewSize!.height,
                      height: state.camera!.value.previewSize!.width,
                      child: CameraPreview(state.camera!),
                    ),
                  ),
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
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.chat_bubble_outline_rounded,
                              color: Colors.white),
                          onPressed: _showChat,
                          tooltip: 'Chat de la clase',
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon:
                            const Icon(Icons.cameraswitch, color: Colors.white),
                        onPressed: notifier.switchCamera,
                      ),
                    ],
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.easeOut,
                  bottom: keyboardVisible
                      ? MediaQuery.of(context).viewInsets.bottom + 10
                      : 130,
                  left: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Título de la clase',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            const Icon(Icons.edit, color: Colors.white54),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _titleController,
                                focusNode: _titleFocusNode,
                                enabled: !state.isStreaming,
                                textInputAction: TextInputAction.done,
                                style: TextStyle(
                                  color: state.isStreaming
                                      ? Colors.white54
                                      : Colors.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: state.isStreaming
                                      ? 'Transmitiendo...'
                                      : 'Agrega un título...',
                                  hintStyle:
                                      const TextStyle(color: Colors.white54),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 16,
                                  ),
                                ),
                                onSubmitted: (_) {
                                  if (!state.isStreaming && !state.starting) {
                                    final typed = _titleController.text.trim();
                                    final titleToSend = typed.isEmpty
                                        ? (params!.title ??
                                            'Clase ${params!.classNumber}')
                                        : typed;
                                    notifier.startStream(titleToSend);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: state.starting
            ? null
            : state.isStreaming
                ? notifier.stopAndComplete
                : () {
                    final typed = _titleController.text.trim();
                    final titleToSend = typed.isEmpty
                        ? (params!.title ?? 'Clase ${params!.classNumber}')
                        : typed;
                    notifier.startStream(titleToSend);
                  },
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
