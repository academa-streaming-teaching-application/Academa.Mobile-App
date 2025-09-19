// lib/presentation/subject/subject_view_rebrand.dart
import 'package:academa_streaming_platform/domain/entities/live_streaming_entity.dart';
import 'package:academa_streaming_platform/presentation/auth/provider/user_provider.dart';
import 'package:academa_streaming_platform/presentation/shared/shared_providers/subject_repository_providers.dart';
import 'package:academa_streaming_platform/domain/entities/subject_entity.dart';
import 'package:academa_streaming_platform/domain/entities/user_entity.dart';
import 'package:academa_streaming_platform/presentation/subject/provider/live_session_provider.dart';
import 'package:academa_streaming_platform/presentation/subject/widgets/subscription_button.dart';
import 'package:academa_streaming_platform/presentation/subject/provider/subject_subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SubjectViewRebrand extends ConsumerWidget {
  final String subjectId;
  const SubjectViewRebrand({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSubject = ref.watch(subjectByIdProvider(subjectId));
    final asyncSessions = ref.watch(subjectLiveSessionsProvider(subjectId));
    final meAsync = ref.watch(currentUserProvider);

    return asyncSubject.when(
      loading: () => const Scaffold(body: _LoadingView()),
      error: (e, _) => Scaffold(body: _ErrorView(message: '$e')),
      data: (subject) {
        final me = meAsync.maybeWhen(data: (u) => u, orElse: () => null);
        final sessions = asyncSessions.maybeWhen(
          data: (s) => s,
          orElse: () => <LiveSessionEntity>[],
        );

        return Scaffold(
          appBar: SubjectViewAppBar(
            subject: subject,
            me: me,
          ),
          body: _Content(
            subject: subject,
            sessions: sessions,
            me: me,
            isLoadingSessions: asyncSessions.isLoading,
          ),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  final SubjectEntity subject;
  final List<LiveSessionEntity> sessions;
  final UserEntity? me;
  final bool isLoadingSessions;

  const _Content({
    required this.subject,
    required this.sessions,
    required this.me,
    required this.isLoadingSessions,
  });

  bool _isProfessorOwner(SubjectEntity s, UserEntity? me) {
    if (me == null) return false;

    final professorId = (s.professor?.id?.toString().trim().isNotEmpty ?? false)
        ? s.professor!.id.toString()
        : (s.professor?.id.toString() ?? '');

    return professorId.isNotEmpty && professorId == me.id;
  }

  int _nextClassNumber(List<LiveSessionEntity> sessions) {
    if (sessions.isEmpty) return 1;
    final maxNumber =
        sessions.map((s) => s.classNumber).reduce((a, b) => a > b ? a : b);
    return maxNumber + 1;
  }

  @override
  Widget build(BuildContext context) {
    final teacherName = _teacherFullName(subject);
    final hasDescription = subject.description.trim().isNotEmpty;
    final canStartLive = _isProfessorOwner(subject, me);
    final hasSessions = sessions.isNotEmpty;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        children: [
          const SizedBox(height: 8),
          SubjectHeading(subject: subject, sessionCount: sessions.length),
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
              subject.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (canStartLive)
            _StartLiveButton(
              subjectId: subject.id,
              classNumber: _nextClassNumber(sessions),
            ),
          const SizedBox(height: 32),

          // Classes section
          if (isLoadingSessions)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (hasSessions) ...[
            const Text(
              'Clases',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            ...sessions
                .map((session) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SubjectVideoCard(
                        session: session,
                        onTap: () {
                          if (session.isPlayable) {
                            context.push(
                                '/video-player/${subject.id}/${session.classNumber}');
                          }
                        },
                      ),
                    ))
                .toList(),
          ] else ...[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.video_library_outlined,
                      size: 64,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aún no hay clases disponibles',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),
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
          const SizedBox(height: 24),
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

class SubjectVideoCard extends StatelessWidget {
  final LiveSessionEntity session;
  final VoidCallback? onTap;

  const SubjectVideoCard({
    super.key,
    required this.session,
    this.onTap,
  });

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: session.status.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        session.status.displayName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPlayable = session.isPlayable;

    return InkWell(
      onTap: isPlayable ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Opacity(
        opacity: isPlayable ? 1.0 : 0.6,
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 88,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFE4B7F),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: session.thumbnailUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            session.thumbnailUrl,
                            width: 88,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholder(),
                          ),
                        )
                      : _buildPlaceholder(),
                ),
                if (session.status != LiveSessionStatus.ended)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: _buildStatusChip(),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.displayTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (session.duration.isNotEmpty)
                          Text(
                            session.duration,
                            style: const TextStyle(
                              color: Color(0xff6C6C6C),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        if (session.endedAt != null) ...[
                          const Text(' • ',
                              style: TextStyle(color: Color(0xff6C6C6C))),
                          Text(
                            _formatDate(session.endedAt!),
                            style: const TextStyle(
                              color: Color(0xff6C6C6C),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset(
        'lib/config/assets/study_view.svg',
        width: 72,
        height: 56,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace $weeks semana${weeks > 1 ? 's' : ''}';
    } else {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months mes${months > 1 ? 'es' : ''}';
    }
  }
}

class SubjectHeading extends StatelessWidget {
  final SubjectEntity subject;
  final int sessionCount;
  const SubjectHeading({
    super.key,
    required this.subject,
    required this.sessionCount,
  });

  @override
  Widget build(BuildContext context) {
    final rating = subject.averageRating.clamp(0, 5).toStringAsFixed(1);
    final students = subject.studentIds.length;
    final title =
        subject.subject.isNotEmpty ? subject.subject : subject.category;

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFE4B7F),
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
                    '$sessionCount clases',
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

// Keep other widgets unchanged
class _StartLiveButton extends StatelessWidget {
  final String subjectId;
  final int classNumber;
  const _StartLiveButton({
    super.key,
    required this.subjectId,
    required this.classNumber,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        context.push('/live?subjectId=$subjectId&classNumber=$classNumber');
      },
      icon: const Icon(Icons.videocam_rounded),
      label: const Text('Iniciar transmisión'),
    );
  }
}

class SubjectViewAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final SubjectEntity subject;
  final UserEntity? me;

  const SubjectViewAppBar({
    super.key,
    required this.subject,
    required this.me,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<SubjectViewAppBar> createState() => _SubjectViewAppBarState();
}

class _SubjectViewAppBarState extends ConsumerState<SubjectViewAppBar> {
  @override
  void initState() {
    super.initState();
    if (widget.me != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(subjectSubscriptionProvider.notifier)
            .checkSubscriptionStatus(widget.subject.id);
      });
    }
  }

  bool _isProfessorOwner() {
    if (widget.me == null) return false;
    final professorId = widget.subject.professor?.id?.toString() ?? '';
    return professorId.isNotEmpty && professorId == widget.me!.id;
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subjectSubscriptionProvider);
    final subscriptionNotifier = ref.read(subjectSubscriptionProvider.notifier);
    final isSubscribed = subscriptionNotifier.isSubscribed(widget.subject.id);
    final isLoading = subscriptionState.isLoading;
    final isProfessor = _isProfessorOwner();
    final canSubscribe = widget.me != null && !isProfessor;

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
      actions: [
        if (canSubscribe)
          IconButton(
            onPressed: isLoading
                ? null
                : () async {
                    if (isSubscribed) {
                      await subscriptionNotifier
                          .unsubscribeFromSubject(widget.subject.id);
                    } else {
                      await subscriptionNotifier
                          .subscribeToSubject(widget.subject.id);
                    }
                  },
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(
                    isSubscribed
                        ? Icons.check_circle
                        : Icons.add_circle_outline_rounded,
                    color: isSubscribed ? Colors.green : Colors.white,
                  ),
          )
        else
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.add_circle_outline_rounded, color: Colors.grey),
          ),
      ],
    );
  }
}

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
