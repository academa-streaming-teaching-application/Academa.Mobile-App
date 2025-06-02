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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://stream.mux.com/${widget.playbackId}.m3u8',
    )..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
