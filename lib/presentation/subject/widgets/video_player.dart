// presentation/video/video_player_screen.dart
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:academa_streaming_platform/domain/entities/watch_history_entity.dart';
import 'package:academa_streaming_platform/presentation/shared/shared_providers/watch_history_repository_providers.dart';
import 'package:academa_streaming_platform/presentation/subject/provider/live_session_provider.dart';
import 'package:academa_streaming_platform/presentation/subject/widgets/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

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
  String? _currentSessionId;
  bool _isInitialized = false;
  bool _isFullScreen = false;
  bool _showControls = true;
  bool _isBuffering = false;
  Timer? _progressTimer;
  int _lastReportedPosition = 0;

  static const int _progressUpdateInterval = 10; // seconds

  @override
  void initState() {
    super.initState();
    // Escucha las sesiones y prepara el player cuando haya una reproducible
    ref.listen<AsyncValue<List<LiveSessionEntity>>>(
      subjectLiveSessionsProvider(widget.subjectId),
      (prev, next) {
        next.whenData((sessions) => _tryInitFromSessions(sessions));
      },
    );
    _hideControlsAfterDelay();
  }

  Future<void> _tryInitFromSessions(List<LiveSessionEntity> sessions) async {
    final session = sessions
        .where((s) => s.classNumber == widget.classNumber)
        .cast<LiveSessionEntity?>()
        .firstWhere(
          (s) => s != null,
          orElse: () => null,
        );

    if (session == null) return;

    final url = session.playbackUrl; // ya decide LIVE vs VOD
    final canPlay = session.isPlayable && url.isNotEmpty;

    if (!canPlay) return;
    if (_currentUrl == url && _controller != null && _isInitialized)
      return; // ya está

    // Reemplaza controller si cambia la URL
    final old = _controller;
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));

    try {
      await _controller!.initialize();

      // Resume from saved position for VOD content
      if (session.isRecorded) {
        await _resumeFromWatchHistory(session.id);
      }

      await _controller!.play();
      _controller!.addListener(_onControllerTick);
      setState(() {
        _currentUrl = url;
        _currentSessionId = session.id;
        _isInitialized = true;
      });

      // Start progress tracking for VOD content
      if (session.isRecorded) {
        _startProgressTracking();
      }
    } catch (_) {
      // opcional: mostrar error en UI
    } finally {
      old?.removeListener(_onControllerTick);
      await old?.dispose();
    }
  }

  Future<void> _resumeFromWatchHistory(String sessionId) async {
    try {
      final watchHistoryRepository = ref.read(watchHistoryRepositoryProvider);
      final watchHistoryParams = const WatchHistoryParams(limit: 50);
      final watchHistory = await watchHistoryRepository.getWatchHistory(
        limit: watchHistoryParams.limit,
        offset: watchHistoryParams.offset,
      );

      // Find the watch history entry for this session
      final historyEntry = watchHistory
          .cast<WatchHistoryEntity?>()
          .firstWhere(
            (entry) => entry?.sessionId == sessionId,
            orElse: () => null,
          );

      if (historyEntry != null && historyEntry.watchedDuration > 0) {
        // Seek to the saved position
        final resumePosition = Duration(seconds: historyEntry.watchedDuration);
        await _controller!.seekTo(resumePosition);
      }
    } catch (error) {
      // Silently handle errors to avoid disrupting playback
      debugPrint('Error resuming from watch history: $error');
    }
  }

  void _onControllerTick() {
    final isBuffering = _controller?.value.isBuffering ?? false;
    if (isBuffering != _isBuffering && mounted) {
      setState(() => _isBuffering = isBuffering);
    }

    // Track watch progress for VOD content
    if (_controller != null &&
        _controller!.value.isInitialized &&
        _currentSessionId != null &&
        !_isBuffering) {
      _trackWatchProgress();
    }
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && (_controller?.value.isPlaying ?? false)) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _hideControlsAfterDelay();
  }

  void _toggleFullScreen() {
    setState(() => _isFullScreen = !_isFullScreen);
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  void _showChat() {
    ClassChatBottomSheet.show(context, widget.subjectId, widget.classNumber);
  }

  void _startProgressTracking() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(
      Duration(seconds: _progressUpdateInterval),
      (_) => _trackWatchProgress(),
    );
  }

  void _trackWatchProgress() {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _currentSessionId == null) {
      return;
    }

    final position = _controller!.value.position.inSeconds;
    final duration = _controller!.value.duration.inSeconds;

    // Only update if position changed significantly or if at the end
    if ((position - _lastReportedPosition).abs() >= _progressUpdateInterval ||
        position >= duration - 5) {
      _lastReportedPosition = position;

      // Update watch progress
      final updateWatchProgress = ref.read(updateWatchProgressProvider);
      updateWatchProgress(
        sessionId: _currentSessionId!,
        currentTime: position,
        totalDuration: duration,
      ).catchError((error) {
        // Silently handle errors to avoid disrupting playback
        debugPrint('Error updating watch progress: $error');
      });
    }
  }

  @override
  void dispose() {
    // Pause video before disposing
    _controller?.pause();

    // Cancel progress tracking timer
    _progressTimer?.cancel();

    // Remove listener and dispose controller
    _controller?.removeListener(_onControllerTick);
    _controller?.dispose();

    // Reset system UI when leaving fullscreen
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }

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
          child: Text('Error: $e', style: const TextStyle(color: Colors.white)),
        ),
        data: (sessions) {
          final session = sessions.firstWhere(
            (s) => s.classNumber == widget.classNumber,
            orElse: () => null as LiveSessionEntity, // trick: we'll null-check
          );

          if (session == null) {
            return const Center(
              child: Text('Clase no encontrada',
                  style: TextStyle(color: Colors.white)),
            );
          }

          final title = session.displayTitle;
          // Intentar iniciar si aún no
          _tryInitFromSessions(sessions);

          return GestureDetector(
            onTap: _toggleControls,
            child: Stack(
              children: [
                Center(
                  child: _isInitialized && _controller != null
                      ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio == 0
                              ? 16 / 9
                              : _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        )
                      : const CircularProgressIndicator(),
                ),
                if (_isBuffering)
                  const Center(child: CircularProgressIndicator()),
                if (_showControls)
                  _VideoControls(
                    controller: _controller,
                    classTitle: title,
                    onFullScreenToggle: _toggleFullScreen,
                    isFullScreen: _isFullScreen,
                    onChatPressed: _showChat,
                  ),
              ],
            ),
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
  final VoidCallback onChatPressed;

  const _VideoControls({
    required this.controller,
    required this.classTitle,
    required this.onFullScreenToggle,
    required this.isFullScreen,
    required this.onChatPressed,
  });

  String _formatDuration(Duration duration) {
    final h = duration.inHours;
    final m = duration.inMinutes.remainder(60);
    final s = duration.inSeconds.remainder(60);
    return h > 0
        ? '${h}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}'
        : '${m}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = controller?.value.isPlaying ?? false;
    final position = controller?.value.position ?? Duration.zero;
    final duration = controller?.value.duration ?? Duration.zero;
    final maxSeconds = duration.inSeconds.toDouble();

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
              child: Row(
                children: [
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
                  // Chat button in top right corner
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline_rounded,
                          color: Colors.white),
                      onPressed: onChatPressed,
                      tooltip: 'Chat de la clase',
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom controls
          Column(
            children: [
              // Progress bar
              if (controller != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Text(_formatDuration(position),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                      Expanded(
                        child: Slider(
                          value: position.inSeconds
                              .clamp(0, duration.inSeconds)
                              .toDouble(),
                          max: maxSeconds > 0 ? maxSeconds : 1.0, // evita NaN
                          onChanged: (value) {
                            controller!
                                .seekTo(Duration(seconds: value.toInt()));
                          },
                          activeColor: Colors.white,
                          inactiveColor: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      Text(_formatDuration(duration),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              // Control buttons
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
                        if (isPlaying) {
                          controller?.pause();
                        } else {
                          controller?.play();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10,
                          color: Colors.white, size: 32),
                      onPressed: () {
                        final newPos = position + const Duration(seconds: 10);
                        controller?.seekTo(newPos);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                          isFullScreen
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen,
                          color: Colors.white,
                          size: 32),
                      onPressed: onFullScreenToggle,
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
