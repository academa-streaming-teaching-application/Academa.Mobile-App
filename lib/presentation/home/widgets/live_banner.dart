import 'package:academa_streaming_platform/domain/entities/class_entity.dart';
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LiveBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final double height;

  const LiveBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.height = 200,
  });

  static const TextStyle _titleStyle = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle _subtitleStyle = TextStyle(
    color: Colors.white70,
    fontSize: 16,
  );

  static const TextStyle _liveLabelStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: _titleStyle),
                  const SizedBox(height: 8),
                  Text(subtitle,
                      style: _subtitleStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                width: 56,
                height: 32,
                decoration: BoxDecoration(
                  color: Color(0xFFB300FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Live',
                    style: _liveLabelStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveStreamSwiper extends StatelessWidget {
  // ⬅️
  final List<LiveStreamingEntity> liveStreams;
  final double height;

  const LiveStreamSwiper({
    // ⬅️
    super.key,
    required this.liveStreams,
    this.height = 210.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      height: height,
      child: Swiper(
        duration: 2000,
        viewportFraction: 1,
        scale: 0.95,
        autoplay: true,
        itemCount: liveStreams.length,
        itemBuilder: (context, index) {
          final stream = liveStreams[index];

          return GestureDetector(
            // ⬅️
            onTap: () =>
                context.push('/player?playbackId=${stream.playbackId}'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: LiveBanner(
                title: stream.title,
                subtitle: 'Clase en vivo',
                imageUrl: 'lib/config/assets/productivity_square.png',
              ),
            ),
          );
        },
      ),
    );
  }
}
