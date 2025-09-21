import 'package:academa_streaming_platform/domain/entities/watch_history_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class KeepWatchingCard extends StatelessWidget {
  final WatchHistoryEntity watchHistory;
  final VoidCallback? onTap;

  const KeepWatchingCard({
    super.key,
    required this.watchHistory,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          watchHistory.displayTitle,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Clase ${watchHistory.classNumber} | ${watchHistory.subject}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 110,
                    child: LinearProgressIndicator(
                      backgroundColor: Color.fromARGB(255, 91, 91, 94),
                      valueColor: AlwaysStoppedAnimation(Color(0xffE4B7FF)),
                      value: watchHistory.watchProgress.clamp(0.0, 1.0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    watchHistory.progressText,
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
