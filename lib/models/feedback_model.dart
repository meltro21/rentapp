class FeedbackModel {
  late String feedback;
  late int rating;

  FeedbackModel({
    required this.feedback,
    required this.rating,
  });

  FeedbackModel.empty() {
    feedback = '';
    rating = 0;
  }
}
