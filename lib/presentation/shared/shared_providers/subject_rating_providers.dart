import 'dart:async';
import 'package:academa_streaming_platform/data/datasource/subject_rating_datasource_impl.dart';
import 'package:academa_streaming_platform/data/repositories/subject_rating_repository_impl.dart';
import 'package:academa_streaming_platform/domain/entities/subject_rating_entity.dart';
import 'package:academa_streaming_platform/domain/repositories/subject_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/provider/auth_repositoy_provider.dart';

// Repository provider
final subjectRatingRepositoryProvider = Provider<SubjectRatingRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SubjectRatingRepositoryImpl(
    SubjectRatingDataSourceImpl(dio),
  );
});

// Rating parameters for pagination
class RatingParams {
  final String subjectId;
  final int page;
  final int limit;

  const RatingParams({
    required this.subjectId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RatingParams &&
          runtimeType == other.runtimeType &&
          subjectId == other.subjectId &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode => subjectId.hashCode ^ page.hashCode ^ limit.hashCode;
}

// Provider to get subject ratings with pagination
final subjectRatingsProvider = FutureProvider.autoDispose
    .family<SubjectRatingsResponseEntity, RatingParams>((ref, params) async {
  final repository = ref.watch(subjectRatingRepositoryProvider);

  final link = ref.keepAlive();
  Timer(const Duration(minutes: 5), link.close);

  return repository.getSubjectRatings(
    subjectId: params.subjectId,
    page: params.page,
    limit: params.limit,
  );
});

// Provider to get user's rating for a specific subject
final userRatingProvider = FutureProvider.autoDispose
    .family<SubjectRatingEntity?, String>((ref, subjectId) async {
  // Wait for auth tokens to be loaded before making the request
  final authTokens = ref.watch(authTokensProvider);

  // If no access token, return null (user not authenticated)
  if (authTokens.accessToken == null) {
    return null;
  }

  final repository = ref.watch(subjectRatingRepositoryProvider);

  final link = ref.keepAlive();
  Timer(const Duration(minutes: 10), link.close);

  return repository.getUserRating(subjectId);
});

// Rating submission state
class RatingSubmissionState {
  final bool isLoading;
  final String? error;
  final SubjectRatingEntity? submittedRating;

  const RatingSubmissionState({
    this.isLoading = false,
    this.error,
    this.submittedRating,
  });

  RatingSubmissionState copyWith({
    bool? isLoading,
    String? error,
    SubjectRatingEntity? submittedRating,
  }) {
    return RatingSubmissionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      submittedRating: submittedRating ?? this.submittedRating,
    );
  }
}

// Rating submission notifier
class RatingSubmissionNotifier extends StateNotifier<RatingSubmissionState> {
  final SubjectRatingRepository _repository;

  RatingSubmissionNotifier(this._repository) : super(const RatingSubmissionState());

  Future<void> submitRating({
    required String subjectId,
    required int score,
    String? comment,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final rating = await _repository.rateSubject(
        subjectId: subjectId,
        score: score,
        comment: comment,
      );

      state = state.copyWith(
        isLoading: false,
        submittedRating: rating,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteRating(String subjectId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.deleteRating(subjectId);

      state = state.copyWith(
        isLoading: false,
        submittedRating: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = const RatingSubmissionState();
  }
}

// Rating submission provider
final ratingSubmissionProvider = StateNotifierProvider<RatingSubmissionNotifier, RatingSubmissionState>((ref) {
  final repository = ref.watch(subjectRatingRepositoryProvider);
  return RatingSubmissionNotifier(repository);
});

// Convenience provider for refreshing ratings
final refreshRatingsProvider = Provider<void Function(String)>((ref) {
  return (String subjectId) {
    ref.invalidate(subjectRatingsProvider);
    ref.invalidate(userRatingProvider(subjectId));
  };
});