import 'package:academa_streaming_platform/presentation/auth/provider/user_provider.dart';
import 'package:academa_streaming_platform/presentation/shared/shared_providers/subject_rating_providers.dart';
import 'package:academa_streaming_platform/presentation/shared/widgets/star_rating_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubjectRatingForm extends ConsumerStatefulWidget {
  final String subjectId;
  final VoidCallback? onRatingSubmitted;

  const SubjectRatingForm({
    super.key,
    required this.subjectId,
    this.onRatingSubmitted,
  });

  @override
  ConsumerState<SubjectRatingForm> createState() => _SubjectRatingFormState();
}

class _SubjectRatingFormState extends ConsumerState<SubjectRatingForm> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadUserRating();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _loadUserRating() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userRatingAsync = ref.read(userRatingProvider(widget.subjectId));
      userRatingAsync.whenData((rating) {
        if (rating != null && mounted) {
          setState(() {
            _selectedRating = rating.score;
            _commentController.text = rating.comment ?? '';
          });
        }
      });
    });
  }

  Future<void> _submitRating() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una calificación'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final notifier = ref.read(ratingSubmissionProvider.notifier);
    await notifier.submitRating(
      subjectId: widget.subjectId,
      score: _selectedRating,
      comment: _commentController.text.trim().isEmpty
          ? null
          : _commentController.text.trim(),
    );

    if (!mounted) return;

    final state = ref.read(ratingSubmissionProvider);
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Calificación enviada exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh the ratings
      ref.read(refreshRatingsProvider)(widget.subjectId);

      // Collapse form
      setState(() {
        _isExpanded = false;
      });

      widget.onRatingSubmitted?.call();
    }
  }

  Future<void> _deleteRating() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar calificación'),
        content: const Text(
            '¿Estás seguro de que quieres eliminar tu calificación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final notifier = ref.read(ratingSubmissionProvider.notifier);
    await notifier.deleteRating(widget.subjectId);

    if (!mounted) return;

    final state = ref.read(ratingSubmissionProvider);
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Calificación eliminada'),
          backgroundColor: Colors.orange,
        ),
      );

      setState(() {
        _selectedRating = 0;
        _commentController.clear();
        _isExpanded = false;
      });

      // Refresh the ratings
      ref.read(refreshRatingsProvider)(widget.subjectId);
      widget.onRatingSubmitted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final submissionState = ref.watch(ratingSubmissionProvider);
    final userRatingAsync = ref.watch(userRatingProvider(widget.subjectId));

    return userAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (user) {
        // Only show rating form for students
        if (user == null || user.role.toLowerCase() != 'student') {
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xff1D1D1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              ListTile(
                title: const Text(
                  'Califica esta materia',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                trailing: userRatingAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (userRating) {
                    if (userRating != null) {
                      return PopupMenuButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: _deleteRating,
                            child: const Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Text('Eliminar calificación'),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),

              // Current rating display (if exists)
              userRatingAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Cargando tu calificación...',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
                data: (userRating) {
                  if (userRating != null && !_isExpanded) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Tu calificación: ',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                              StarRatingWidget(
                                rating: userRating.score,
                                enabled: false,
                                size: 20,
                              ),
                            ],
                          ),
                          if (userRating.comment != null &&
                              userRating.comment!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              '"${userRating.comment}"',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isExpanded = true;
                              });
                            },
                            child: const Text('Editar calificación'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Rating form (when expanded or no rating exists)
              if (_isExpanded ||
                  userRatingAsync.maybeWhen(
                      data: (rating) => rating == null, orElse: () => false))
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Star rating
                      const Text(
                        'Calificación:',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      StarRatingWidget(
                        rating: _selectedRating,
                        onRatingChanged: (rating) {
                          setState(() {
                            _selectedRating = rating;
                          });
                        },
                        enabled: !submissionState.isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Comment field
                      const Text(
                        'Comentario (opcional):',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _commentController,
                        enabled: !submissionState.isLoading,
                        maxLines: 3,
                        maxLength: 1000,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText:
                              'Comparte tu experiencia con esta materia...',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFFE4B7F)),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                        ),
                      ),

                      // Action buttons
                      Row(
                        children: [
                          TextButton(
                            onPressed: submissionState.isLoading
                                ? null
                                : () {
                                    setState(() {
                                      _isExpanded = false;
                                    });
                                  },
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: submissionState.isLoading
                                ? null
                                : _submitRating,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFE4B7F),
                              foregroundColor: Colors.white,
                            ),
                            child: submissionState.isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text('Enviar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
