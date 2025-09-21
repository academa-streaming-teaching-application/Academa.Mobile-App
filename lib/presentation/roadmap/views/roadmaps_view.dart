import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../shared/shared_providers/subject_repository_providers.dart';
import '../../../domain/entities/subject_entity.dart';

class RoadmapsView extends ConsumerWidget {
  const RoadmapsView({super.key});

  Future<void> _refreshData(WidgetRef ref) async {
    ref.invalidate(followedSubjectsProvider);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followedSubjectsAsync = ref.watch(followedSubjectsProvider);

    return Scaffold(
      appBar: const RoadmapAppBar(),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(ref),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: followedSubjectsAsync.when(
            loading: () => const _LoadingView(),
            error: (error, stackTrace) => _ErrorView(message: 'Error al cargar materias: $error'),
            data: (subjects) {
              if (subjects.isEmpty) {
                return const _EmptyFollowedSubjectsView();
              }
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 8),
                  const SizedBox(height: 16),
                  ...subjects.map((subject) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: FollowedSubjectCard(subject: subject),
                  )),
                  const SizedBox(height: 32),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class RoadmapAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RoadmapAppBar({
    super.key,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      centerTitle: true,
      title: const Text(
        'Mis Materias',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class FollowedSubjectCard extends StatelessWidget {
  final SubjectEntity subject;

  const FollowedSubjectCard({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final teacherName = _getTeacherName();
    final title = subject.subject.isNotEmpty ? subject.subject : subject.category;

    return InkWell(
      onTap: () {
        context.push('/subject-view/${subject.id}');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xff1D1D1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            // Subject icon
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFE4B7F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  'lib/config/assets/book.svg',
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
              ),
            ),
            // Subject info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      teacherName,
                      style: const TextStyle(
                        color: Color(0xff6C6C6C),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 16,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${subject.studentIds.length} estudiantes',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.star_outline,
                          size: 16,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          subject.averageRating.toStringAsFixed(1),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _getTeacherName() {
    final professor = subject.professor;
    if (professor == null) return 'Profesor';
    final name = '${professor.name} ${professor.lastName}'.trim();
    return name.isNotEmpty ? name : 'Profesor';
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      children: [
        const SizedBox(height: 24),
        ...List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: const TextStyle(color: Colors.redAccent),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _EmptyFollowedSubjectsView extends StatelessWidget {
  const _EmptyFollowedSubjectsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No sigues ninguna materia',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explora materias en la pestaña de búsqueda para comenzar a seguir clases',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/search-view'),
              icon: const Icon(Icons.search_rounded),
              label: const Text('Explorar Materias'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFE4B7F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
