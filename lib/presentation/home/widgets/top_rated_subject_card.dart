import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/subject_entity.dart';

class TopRatedSubjectCard extends StatelessWidget {
  final SubjectEntity subject;

  const TopRatedSubjectCard({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    // rating con 1 decimal como en tu UI "5.2"
    final rating = subject.averageRating.clamp(0, 5).toStringAsFixed(1);

    // Si más adelante agregas teacherName al entity, úsalo; si no, deja el placeholder.
    // final teacherText =
    //     'Impartido por ${subject is dynamic && (subject as dynamic).teacherName != null && ((subject as dynamic).teacherName as String).isNotEmpty ? (subject as dynamic).teacherName : 'Profesor'}';

    return InkWell(
      onTap: () {
        // navega tal cual tu UI original (sin pasar id si no quieres)
        context.push('/subject-view');
      },
      child: Container(
        width: 290,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                // Header ilustración
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
                // Botón + (tal cual tu UI)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(50, 0, 0, 0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_circle_outline_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                // Badge de rating (mismo ancho/alto)
                Positioned(
                  child: Container(
                    width: 48,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xff1D1D1E),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 2),
                        Text(
                          rating, // e.g. "4.8"
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
                // Chip del libro (color normalizado a 0xffE4B7FF para compilar)
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título (misma caja 200x40)
                      SizedBox(
                        width: 200,
                        // height: 40,
                        child: Text(
                          subject.subject, // dinamizado
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      // Subtítulo "Impartido por ..."
                      const SizedBox(height: 0),
                      SizedBox(
                        width: 220,
                        child: Text(
                          "Impartido por Hugo Duque",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),
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
}
