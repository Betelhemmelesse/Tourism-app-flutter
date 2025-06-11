import 'package:tourism_app/core/api/api_service.dart';
import '../../domain/models/feedback.dart';
import '../../domain/repositories/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final ApiService _apiService;

  FeedbackRepositoryImpl(this._apiService);

  @override
  Future<void> submitFeedback(Feedback feedback) async {
    try {
      await _apiService.post('/api/feedback', feedback.toJson());
    } catch (e) {
      throw Exception('Failed to submit feedback: ${e.toString()}');
    }
  }

  @override
  Future<List<Feedback>> getUserFeedback() async {
    try {
      final response = await _apiService.get('/api/feedback/me');
      return (response as List)
          .map((json) => Feedback.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user feedback: ${e.toString()}');
    }
  }
} 