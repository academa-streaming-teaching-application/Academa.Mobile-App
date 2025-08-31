import 'package:academa_streaming_platform/presentation/shared/shared_providers/subject_repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/subject_entity.dart';

class SubjectViewRebrand extends ConsumerWidget {
  final String subjectId;
  const SubjectViewRebrand({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSubject = ref.watch(subjectByIdProvider(subjectId));

    return Scaffold(
      appBar: const SubjectViewAppBar(),
      body: asyncSubject.when(
        loading: () => const _LoadingView(),
        error: (e, _) => _ErrorView(message: '$e'),
        data: (subject) => _Content(subject: subject),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final SubjectEntity subject;
  const _Content({required this.subject});

  @override
  Widget build(BuildContext context) {
    final teacherName = _teacherFullName(subject);
    final hasDescription = subject.description.trim().isNotEmpty;
    final hasVideos =
        subject.numberOfClasses > 0; // cuando tengas assets, usa esa lista

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: [
          const SizedBox(height: 8),
          SubjectHeading(subject: subject),
          const SizedBox(height: 16),

          if (hasDescription) ...[
            const Text(
              'Sobre el curso',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subject.description, // ← viene directo del backend
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // No mostramos si no hay
          if (hasVideos)
            ...List.generate(
              subject.numberOfClasses, // luego cámbialo por assets.length
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: SubjectVideoCard(),
              ),
            ),

          const Text(
            'Profesor',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff1D1D1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  teacherName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _teacherFullName(SubjectEntity s) {
    final p = s.professor;
    if (p == null) return 'Profesor';
    final name = '${p.name} ${p.lastName}'.trim();
    return name.isNotEmpty ? name : 'Profesor';
  }
}

/*─────────────────────────── AppBar (sin cambios visuales) ────────────────────────────*/

class SubjectViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SubjectViewAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      ),
      centerTitle: true,
      title: const Text(
        'Clase',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: const [
        IconButton(
          onPressed: null,
          icon: Icon(Icons.add_circle_outline_rounded, color: Colors.white),
        ),
        IconButton(
          onPressed: null,
          icon: Icon(Icons.ios_share_rounded, color: Colors.white),
        ),
      ],
    );
  }
}

/*─────────────────────────── Video card (UI intacta) ────────────────────────────*/

class SubjectVideoCard extends StatelessWidget {
  const SubjectVideoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffFE4B7FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'lib/config/assets/study_view.svg',
              width: 72,
              height: 64,
              placeholderBuilder: (context) => Container(
                decoration: BoxDecoration(
                  color: const Color(0xffFE4B7FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                width: 72,
                height: 64,
                child: const Padding(padding: EdgeInsets.all(8.0)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(
                width: 250,
                child: Text(
                  'Repaso de limites e integrales',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  maxLines: 3,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '10:12 min',
                style: TextStyle(
                  color: Color(0xff6C6C6C),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

/*─────────────────────────── Heading (UI intacta, datos reales) ────────────────────────────*/

class SubjectHeading extends StatelessWidget {
  final SubjectEntity subject;
  const SubjectHeading({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final classes = subject.numberOfClasses;
    final rating = subject.averageRating.clamp(0, 5).toStringAsFixed(1);
    final students =
        subject.studentIds.length; // cuando tengas studentsCount, úsalo aquí
    final title =
        subject.subject.isNotEmpty ? subject.subject : subject.category;

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffFE4B7FF),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'lib/config/assets/book.svg',
              width: 32,
              height: 32,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$classes clases',
                    style: const TextStyle(
                      color: Color(0xff6C6C6C),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 1),
                  const Icon(Icons.star_rate_rounded,
                      size: 18, color: Color(0xff6C6C6C)),
                  const SizedBox(width: 1),
                  Text(
                    '$rating | $students estudiantes',
                    style: const TextStyle(
                      color: Color(0xff6C6C6C),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 350,
                child: Text(
                  title,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

/*─────────────────────────── Loading/Error ────────────────────────────*/

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Error: $message',
          style: const TextStyle(color: Colors.redAccent)),
    );
  }
}
