import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/subject_entity.dart';
import '../../../domain/repositories/subject_repository.dart';
import '../../shared/shared_providers/subject_repository_providers.dart';

class SubjectSubscriptionState {
  final bool isLoading;
  final String? error;
  final Map<String, bool> subscriptionStatus;

  const SubjectSubscriptionState({
    this.isLoading = false,
    this.error,
    this.subscriptionStatus = const {},
  });

  SubjectSubscriptionState copyWith({
    bool? isLoading,
    String? error,
    Map<String, bool>? subscriptionStatus,
  }) {
    return SubjectSubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
    );
  }
}

class SubjectSubscriptionNotifier extends StateNotifier<SubjectSubscriptionState> {
  final SubjectRepository _repository;

  SubjectSubscriptionNotifier(this._repository) : super(const SubjectSubscriptionState());

  Future<void> subscribeToSubject(String subjectId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.subscribeToSubject(subjectId);

      final updatedStatus = Map<String, bool>.from(state.subscriptionStatus);
      updatedStatus[subjectId] = true;

      state = state.copyWith(
        isLoading: false,
        subscriptionStatus: updatedStatus,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> unsubscribeFromSubject(String subjectId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.unsubscribeFromSubject(subjectId);

      final updatedStatus = Map<String, bool>.from(state.subscriptionStatus);
      updatedStatus[subjectId] = false;

      state = state.copyWith(
        isLoading: false,
        subscriptionStatus: updatedStatus,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> checkSubscriptionStatus(String subjectId) async {
    try {
      final isSubscribed = await _repository.getSubscriptionStatus(subjectId);

      final updatedStatus = Map<String, bool>.from(state.subscriptionStatus);
      updatedStatus[subjectId] = isSubscribed;

      state = state.copyWith(subscriptionStatus: updatedStatus);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  bool isSubscribed(String subjectId) {
    return state.subscriptionStatus[subjectId] ?? false;
  }
}

final subjectSubscriptionProvider = StateNotifierProvider<SubjectSubscriptionNotifier, SubjectSubscriptionState>((ref) {
  final repository = ref.watch(subjectRepositoryProvider);
  return SubjectSubscriptionNotifier(repository);
});

// Note: followedSubjectsProvider has been moved to shared_providers/subject_repository_providers.dart
// to avoid duplication and ensure proper authentication dependency