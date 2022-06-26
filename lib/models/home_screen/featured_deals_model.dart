import 'package:get/get.dart';

class FeaturedDeals {
  int id;
  String path;
  String name;
  int price;
  String location;
  String date;
  var favorited = false.obs;
  FeaturedDeals(
      {required this.id,
      required this.path,
      required this.name,
      required this.price,
      required this.location,
      required this.date,
      required this.favorited});
}
