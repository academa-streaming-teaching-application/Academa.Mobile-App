import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/subject_entity.dart';

class TopRatedSubjectCard extends StatelessWidget {
  final SubjectEntity subject;
  final double? width;
  final VoidCallback? onTap;

  const TopRatedSubjectCard({
    super.key,
    required this.subject,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double avg = (subject.averageRating ?? 0).toDouble().clamp(0.0, 5.0);
    final String rating = avg.toStringAsFixed(1);
    final String teacherName = _teacherFullName(subject);
    final double cardWidth = width ?? 290;

    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap ?? () => context.push('/subject-view/${subject.id}'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xffE4B7FF),
                  ),
                  width: double.infinity,
                  height: 160,
                  child: SvgPicture.asset(
                    'lib/config/assets/education_gathering.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                const Positioned(
                  left: 0,
                  top: 0,
                  child: _RatingPill(),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: SizedBox(
                    width: 48,
                    height: 32,
                    child: Row(
                      children: [
                        const SizedBox(width: 22),
                        Text(
                          rating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffE4B7FF),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SvgPicture.asset(
                      'lib/config/assets/book.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.subject,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 0),
                      Text(
                        'Impartido por $teacherName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _teacherFullName(SubjectEntity s) {
    final p = s.professor;
    if (p == null) return 'Profesor';
    final full = '${p.name} ${p.lastName}'.trim();
    return full.isNotEmpty ? full : 'Profesor';
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xff1D1D1E),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(8),
        ),
      ),
      child: const Row(
        children: [
          SizedBox(width: 6),
          Icon(Icons.star, color: Colors.amber, size: 16),
          SizedBox(width: 2),
        ],
      ),
    );
  }
}
