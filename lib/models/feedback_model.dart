class FeedbackModel {
  late String feedback;
  late int rating;
  late String name;

  FeedbackModel(
      {required this.feedback, required this.rating, required this.name});

  FeedbackModel.empty() {
    feedback = '';
    rating = 0;
    name = '';
  }
}
