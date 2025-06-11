import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/feedback/presentation/providers/feedback_provider.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> emojis = ['😡', '😕', '😐', '🙂', '😍'];
  final List<String> labels = ['Terrible', 'Bad', 'Okay', 'Good', 'Excellent'];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your feedback')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref.read(feedbackProvider.notifier).submitFeedback(
            _commentController.text.trim(),
            _rating,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback submitted successfully!')),
        );
        _commentController.clear();
        setState(() {
          _rating = 0;
          _isSubmitting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting feedback: ${e.toString()}')),
        );
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedbackState = ref.watch(feedbackProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Feedback 💬',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'How Would You Rate Our App?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Emoji display
            Text(
              _rating > 0 ? emojis[_rating - 1] : '🙂',
              style: const TextStyle(fontSize: 60),
            ),
            Text(
              _rating > 0 ? labels[_rating - 1] : '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // Rating stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star_rounded,
                    size: 32,
                    color: index < _rating ? Colors.amber : Colors.grey[300],
                  ),
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          setState(() => _rating = index + 1);
                        },
                );
              }),
            ),
            const SizedBox(height: 30),

            const Text(
              'Any Additional Comments?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              'Let us Know',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            // Comment Box
            TextField(
              controller: _commentController,
              maxLines: 4,
              enabled: !_isSubmitting,
              decoration: InputDecoration(
                hintText: 'Type your feedback here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF43b0f1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
