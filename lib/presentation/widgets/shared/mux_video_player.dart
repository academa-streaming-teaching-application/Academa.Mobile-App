import 'package:academa_streaming_platform/presentation/widgets/shared/live_chat/live_chat_list.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/live_chat/live_message_input.dart';
import 'package:academa_streaming_platform/presentation/widgets/shared/live_chat/live_video_header.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MuxVideoPlayer extends StatefulWidget {
  final String playbackId;

  const MuxVideoPlayer({Key? key, required this.playbackId}) : super(key: key);

  @override
  State<MuxVideoPlayer> createState() => _MuxVideoPlayerState();
}

class _MuxVideoPlayerState extends State<MuxVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://stream.mux.com/${widget.playbackId}.m3u8',
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();
      setState(() => _isInitialized = true);
      _controller.play();
    } catch (e) {
      debugPrint('❌ Error al inicializar video: $e');
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo reproducir el video.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleControls() => setState(() => _showControls = !_showControls);
  void _goBack() => Navigator.of(context).maybePop();

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _isInitialized
              ? GestureDetector(
                  onTap: _toggleControls,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final ratio = _controller.value.aspectRatio;
                      double naturalH = width / ratio; // alto natural
                      final maxH = screen.height * 0.35; // 30 %
                      if (naturalH > maxH) naturalH = maxH;

                      return SizedBox(
                        width: width,
                        height: naturalH,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            VideoPlayer(_controller),
                            if (_showControls)
                              Container(
                                color: Colors.black38,
                                child: Stack(
                                  children: [
                                    SafeArea(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: IconButton(
                                          icon: const Icon(Icons.arrow_back,
                                              color: Colors.white),
                                          onPressed: _goBack,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                _controller.value.isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                color: Colors.white,
                                                size: 32,
                                              ),
                                              onPressed: () => setState(() {
                                                _controller.value.isPlaying
                                                    ? _controller.pause()
                                                    : _controller.play();
                                              }),
                                            ),
                                            const SizedBox(width: 16),
                                            IconButton(
                                              icon: const Icon(Icons.replay,
                                                  color: Colors.white,
                                                  size: 28),
                                              onPressed: () => _controller
                                                  .seekTo(Duration.zero),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : SizedBox(
                  height: screen.height * 0.35,
                  child: Center(child: CircularProgressIndicator()),
                ),

          // ───────────── Aquí, debajo, puedes añadir otros widgets ─────────────
          LiveVideoHeader(
            avatarUrl: 'lib/config/assets/productivity_square.png',
            name: 'Hugo Duque',
            title: 'Math',
          ),
          Expanded(
            child: LiveChatList(
              liveStreamId: widget.playbackId,
            ),
          ),
          LiveMessageInput(
            liveStreamId: widget.playbackId,
          ),
        ],
      ),
    );
  }
}
