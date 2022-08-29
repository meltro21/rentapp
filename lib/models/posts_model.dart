class PostsModel {
  late String category;
  late int price;
  late String model;
  late String description;
  late String createdAt;
  late String address;
  late List<dynamic> imagesUrl;

  PostsModel(
      {required this.category,
      required this.price,
      required this.model,
      required this.description,
      required this.createdAt,
      required this.address,
      required this.imagesUrl});

  PostsModel.empty() {
    category = '';
    price = 0;
    model = '';
    description = '';
    createdAt = '';
    address = '';
    imagesUrl = [];
  }
}
