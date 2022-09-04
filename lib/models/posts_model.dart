class PostsModel {
  late String id;
  late String category;
  late String subCategory;
  late int price;
  late String model;
  late String userId;
  late String description;
  late DateTime createdAt;
  late String address;
  late double lat;
  late double lng;
  late List<dynamic> imagesUrl;

  PostsModel(
      {required this.id,
      required this.category,
      required this.subCategory,
      required this.price,
      required this.model,
      required this.userId,
      required this.description,
      required this.createdAt,
      required this.address,
      required this.lat,
      required this.lng,
      required this.imagesUrl});

  PostsModel.empty() {
    id = '';
    category = '';
    subCategory = '';
    price = 0;
    model = '';
    userId = '';
    description = '';
    createdAt = DateTime.now();
    address = '';
    lat = 0.0;
    lng = 0.0;
    imagesUrl = [];
  }
}
