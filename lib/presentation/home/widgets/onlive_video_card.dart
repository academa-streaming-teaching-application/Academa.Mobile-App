import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnLiveVideoCard extends StatelessWidget {
  final LiveSessionEntity liveStream;
  final VoidCallback? onTap;

  const OnLiveVideoCard({
    super.key,
    required this.liveStream,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 290,
        decoration: BoxDecoration(
          color: Color(0xff1D1D1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xffE4B7FF),
                        borderRadius: BorderRadius.circular(100)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SvgPicture.asset(
                        'lib/config/assets/book.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          child: Text(
                            liveStream.subject,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: Color(0xffE4B7FF),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (liveStream.thumbnailUrl.isNotEmpty)
                    Image.network(
                      liveStream.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          SvgPicture.asset(
                        'lib/config/assets/live_colaboration.svg',
                        fit: BoxFit.contain,
                      ),
                    )
                  else
                    SvgPicture.asset(
                      'lib/config/assets/live_colaboration.svg',
                      fit: BoxFit.contain,
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'EN VIVO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    size: 32,
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Clase ${liveStream.classNumber}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          height: 40,
                          child: Text(
                            liveStream.displayTitle,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
