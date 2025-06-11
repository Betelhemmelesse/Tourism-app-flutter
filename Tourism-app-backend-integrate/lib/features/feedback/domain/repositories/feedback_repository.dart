import '../models/feedback.dart';
 
abstract class FeedbackRepository {
  Future<void> submitFeedback(Feedback feedback);
  Future<List<Feedback>> getUserFeedback();
} 