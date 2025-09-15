// presentation/video/video_player_screen.dart
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:academa_streaming_platform/presentation/shared/widgets/live_chat/live_chat_list.dart';
import 'package:academa_streaming_platform/presentation/shared/widgets/live_chat/live_message_input.dart';
import 'package:academa_streaming_platform/presentation/shared/widgets/live_chat/live_video_header.dart';
import 'package:academa_streaming_platform/presentation/subject/provider/live_session_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:academa_streaming_platform/firebase_options.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final String subjectId;
  final int classNumber;

  const VideoPlayerScreen({
    super.key,
    required this.subjectId,
    required this.classNumber,
  });

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  String? _currentUrl;
  bool _isInitialized = false;
  bool _isFullScreen = false;
  bool _showControls = true;
  bool _isBuffering = false;
  bool _showChat = false;

  @override
  void initState() {
    super.initState();
    _ensureFirebaseAndAuth();
    ref.listen<AsyncValue<List<LiveSessionEntity>>>(
      subjectLiveSessionsProvider(widget.subjectId),
      (prev, next) => next.whenData(_tryInitFromSessions),
    );
    _hideControlsAfterDelay();
  }

  Future<void> _ensureFirebaseAndAuth() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
    if (mounted) setState(() {});
  }

  Future<void> _tryInitFromSessions(List<LiveSessionEntity> sessions) async {
    final session = sessions
        .where((s) => s.classNumber == widget.classNumber)
        .cast<LiveSessionEntity?>()
        .firstWhere((s) => s != null, orElse: () => null);
    if (session == null) return;

    final url = session.playbackUrl;
    final canPlay = session.isPlayable && url.isNotEmpty;
    if (!canPlay) return;

    if (_currentUrl == url && _controller != null && _isInitialized) return;

    final old = _controller;
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));

    try {
      await _controller!.initialize();
      await _controller!.play();
      _controller!.addListener(_onControllerTick);
      setState(() {
        _currentUrl = url;
        _isInitialized = true;
      });
    } finally {
      old?.removeListener(_onControllerTick);
      await old?.dispose();
    }
  }

  void _onControllerTick() {
    final isBuffering = _controller?.value.isBuffering ?? false;
    if (isBuffering != _isBuffering && mounted) {
      setState(() => _isBuffering = isBuffering);
    }
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      if (_controller?.value.isPlaying ?? false) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _hideControlsAfterDelay();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) _showChat = false; // oculta chat en fullscreen
    });
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerTick);
    _controller?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync =
        ref.watch(subjectLiveSessionsProvider(widget.subjectId));

    return Scaffold(
      backgroundColor: Colors.black,
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
            child:
                Text('Error: $e', style: const TextStyle(color: Colors.white))),
        data: (sessions) {
          final session = sessions
              .where((s) => s.classNumber == widget.classNumber)
              .cast<LiveSessionEntity?>()
              .firstWhere((s) => s != null, orElse: () => null);

          if (session == null) {
            return const Center(
              child: Text('Clase no encontrada',
                  style: TextStyle(color: Colors.white)),
            );
          }

          _tryInitFromSessions(sessions);

          final title = session.displayTitle;
          final isWide = MediaQuery.of(context).size.width >= 900 ||
              MediaQuery.of(context).orientation == Orientation.landscape;

          final videoArea = Center(
            child: _isInitialized && _controller != null
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio == 0
                        ? 16 / 9
                        : _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : const CircularProgressIndicator(),
          );

          final controls = _showControls
              ? _VideoControls(
                  controller: _controller,
                  classTitle: title,
                  onFullScreenToggle: _toggleFullScreen,
                  isFullScreen: _isFullScreen,
                )
              : const SizedBox.shrink();

          final chatToggleBtn = !_isFullScreen
              ? Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      _showChat ? Icons.close_fullscreen : Icons.chat_bubble,
                      color: Colors.white,
                    ),
                    tooltip: _showChat ? 'Ocultar chat' : 'Mostrar chat',
                    onPressed: () => setState(() => _showChat = !_showChat),
                  ),
                )
              : const SizedBox.shrink();

          final chatPanel = Container(
            color: const Color(0xFF141414),
            width: isWide ? 360 : null,
            child: Column(
              children: [
                LiveVideoHeader(
                  avatarUrl:
                      'https://ui-avatars.com/api/?name=${Uri.encodeComponent("Profesor")}',
                  name: 'Profesor',
                  title: title,
                  isLive: session.isLive,
                ),
                const Divider(height: 1, color: Colors.white12),
                Expanded(
                  child: LiveChatList(
                    subjectId: widget.subjectId,
                    classNumber: widget.classNumber,
                  ),
                ),
                LiveMessageInput(
                  subjectId: widget.subjectId,
                  classNumber: widget.classNumber,
                ),
              ],
            ),
          );

          if (isWide && _showChat && !_isFullScreen) {
            return Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      videoArea,
                      if (_isBuffering)
                        const Center(child: CircularProgressIndicator()),
                      Positioned.fill(
                        child: GestureDetector(onTap: _toggleControls),
                      ),
                      Positioned.fill(child: IgnorePointer(child: controls)),
                      chatToggleBtn,
                    ],
                  ),
                ),
                SizedBox(width: 360, child: chatPanel),
              ],
            );
          }

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: _showChat ? 0 : 1,
                    child: Stack(
                      children: [
                        Align(alignment: Alignment.center, child: videoArea),
                        if (_isBuffering)
                          const Center(child: CircularProgressIndicator()),
                        Positioned.fill(
                          child: GestureDetector(onTap: _toggleControls),
                        ),
                        Positioned.fill(child: IgnorePointer(child: controls)),
                      ],
                    ),
                  ),
                  if (_showChat && !_isFullScreen)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: chatPanel,
                    ),
                ],
              ),
              chatToggleBtn,
            ],
          );
        },
      ),
    );
  }
}

class _VideoControls extends StatelessWidget {
  final VideoPlayerController? controller;
  final String classTitle;
  final VoidCallback onFullScreenToggle;
  final bool isFullScreen;

  const _VideoControls({
    required this.controller,
    required this.classTitle,
    required this.onFullScreenToggle,
    required this.isFullScreen,
  });

  String _formatDuration(Duration d) {
    final h = d.inHours,
        m = d.inMinutes.remainder(60),
        s = d.inSeconds.remainder(60);
    return h > 0
        ? '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}'
        : '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = controller?.value.isPlaying ?? false;
    final position = controller?.value.position ?? Duration.zero;
    final duration = controller?.value.duration ?? Duration.zero;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    classTitle,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                      isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                      color: Colors.white),
                  onPressed: onFullScreenToggle,
                ),
              ]),
            ),
          ),
          // Bottom controls
          Column(
            children: [
              if (controller != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(children: [
                    Text(_formatDuration(position),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                    Expanded(
                      child: Slider(
                        value: position.inSeconds
                            .clamp(0, duration.inSeconds)
                            .toDouble(),
                        max: duration.inSeconds > 0
                            ? duration.inSeconds.toDouble()
                            : 1.0,
                        onChanged: (v) =>
                            controller!.seekTo(Duration(seconds: v.toInt())),
                        activeColor: Colors.white,
                        inactiveColor: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    Text(_formatDuration(duration),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ]),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10,
                          color: Colors.white, size: 32),
                      onPressed: () {
                        final newPos = position - const Duration(seconds: 10);
                        controller?.seekTo(
                            newPos.isNegative ? Duration.zero : newPos);
                      },
                    ),
                    IconButton(
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white, size: 48),
                      onPressed: () {
                        if (isPlaying)
                          controller?.pause();
                        else
                          controller?.play();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10,
                          color: Colors.white, size: 32),
                      onPressed: () {
                        controller
                            ?.seekTo(position + const Duration(seconds: 10));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
