import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MuxVideoPlayer extends StatefulWidget {
  final String playbackId;

  const MuxVideoPlayer({Key? key, required this.playbackId}) : super(key: key);

  @override
  _MuxVideoPlayerState createState() => _MuxVideoPlayerState();
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
    )..initialize().then((_) {
        setState(() => _isInitialized = true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  void _goBack() {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isInitialized
          ? Stack(
              children: [
                // 👇 Video pantalla completa
                GestureDetector(
                  onTap: _toggleControls,
                  child: SizedBox.expand(
                    // 👈 Ocupa toda la pantalla
                    child: FittedBox(
                      fit: BoxFit.cover, // 👈 Cubre completamente la pantalla
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                ),

                // 👇 Controles superpuestos
                if (_showControls)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black38,
                      child: Column(
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
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _controller.value.isPlaying
                                          ? _controller.pause()
                                          : _controller.play();
                                    });
                                  },
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: const Icon(Icons.replay,
                                      color: Colors.white, size: 28),
                                  onPressed: () =>
                                      _controller.seekTo(Duration.zero),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
