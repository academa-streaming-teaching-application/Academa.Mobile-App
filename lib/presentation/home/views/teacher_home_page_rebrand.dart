// lib/presentation/home/teacher_home_page_rebrand.dart

import 'package:academa_streaming_platform/presentation/auth/provider/user_provider.dart';
import 'package:academa_streaming_platform/presentation/shared/shared_providers/subject_repository_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/subject_entity.dart';

class TeacherHomePageRebrand extends ConsumerWidget {
  const TeacherHomePageRebrand({super.key});

  Future<void> _refreshData(WidgetRef ref) async {
    ref.invalidate(teacherOwnSubjectsProvider);
    ref.invalidate(currentUserProvider);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            SvgPicture.asset('lib/config/assets/academa_logo.svg',
                width: 16, height: 16),
            const SizedBox(width: 4),
            const Text('Academa',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/create-subject'),
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: Colors.white),
            tooltip: 'Crear nueva materia',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(ref),
        child: userAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (e, _) =>
              _ErrorMessage(message: 'Error al cargar usuario: $e'),
          data: (user) {
            if (user == null) {
              return const Center(
                child: Text('Usuario no autenticado.',
                    style: TextStyle(color: Colors.white70)),
              );
            }

            // Use the teacherOwnSubjectsProvider that calls the new API endpoint
            final teachingSubjectsAsync = ref.watch(teacherOwnSubjectsProvider);

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Hola, ${user.name}!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Gestiona tus materias y clases',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Teacher's Subjects
                    const _SectionTitle('Mis Materias'),
                    teachingSubjectsAsync.when(
                      loading: () => const _MySubjectsLoadingView(),
                      error: (e, _) => _ErrorMessage(
                          message: 'Error al cargar materias: $e'),
                      data: (subjects) {
                        if (subjects.isEmpty) {
                          return const _EmptySubjectsView();
                        }
                        return _MySubjectsGrid(subjects: subjects);
                      },
                    ),

                    // Add some bottom padding
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class _MySubjectsGrid extends StatelessWidget {
  final List<SubjectEntity> subjects;
  const _MySubjectsGrid({required this.subjects});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75, // Make cards taller
        ),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return _TeacherSubjectCard(subject: subject);
        },
      ),
    );
  }
}

class _TeacherSubjectCard extends StatelessWidget {
  final SubjectEntity subject;
  const _TeacherSubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/subject-view/${subject.id}');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff1D1D1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFE4B7F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  'lib/config/assets/book.svg',
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Subject title
              Text(
                subject.subject.isNotEmpty ? subject.subject : subject.category,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Subject category
              if (subject.category.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    subject.category,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              const Spacer(),

              // Subject stats
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${subject.studentIds.length}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.star_outline,
                    size: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    subject.averageRating.toStringAsFixed(1),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
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
    );
  }
}

class _MySubjectsLoadingView extends StatelessWidget {
  const _MySubjectsLoadingView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      ),
    );
  }
}

class _EmptySubjectsView extends StatelessWidget {
  const _EmptySubjectsView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Aún no tienes materias',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crea tu primera materia para comenzar a enseñar',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/create-subject'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Crear Materia'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFE4B7F),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage({required this.message});

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
