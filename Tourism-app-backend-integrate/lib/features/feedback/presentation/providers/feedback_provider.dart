import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/providers/api_service_provider.dart';
import '../../data/repositories/feedback_repository_impl.dart';
import '../../domain/repositories/feedback_repository.dart';
import '../../domain/models/feedback.dart';

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return FeedbackRepositoryImpl(apiService);
});

final feedbackProvider = StateNotifierProvider<FeedbackNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(feedbackRepositoryProvider);
  return FeedbackNotifier(repository);
});

class FeedbackNotifier extends StateNotifier<AsyncValue<void>> {
  final FeedbackRepository _repository;

  FeedbackNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> submitFeedback(String content, int rating) async {
    state = const AsyncValue.loading();
    try {
      final feedback = Feedback(content: content, rating: rating);
      await _repository.submitFeedback(feedback);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
} 