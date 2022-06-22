import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ConstructionCategory {
  String path;
  String name;

  ConstructionCategory(this.path, this.name);
}

class FeaturedDeals {
  String path;
  String name;
  int price;
  String location;
  String date;
  var favorited = false.obs;
  FeaturedDeals(
      {required this.path,
      required this.name,
      required this.price,
      required this.location,
      required this.date,
      required this.favorited});
}

class HomeScreenController extends GetxController {
  List<ConstructionCategory> constructionCategory = [
    ConstructionCategory('assets/images/construction/backhoe.png', 'Backhoe'),
    ConstructionCategory(
        'assets/images/construction/bulldozer.png', 'Bulldozer'),
    ConstructionCategory(
        'assets/images/construction/dumptruck.png', 'Dumptruck'),
    ConstructionCategory(
        'assets/images/construction/excavator.png', 'Excavator'),
    ConstructionCategory('assets/images/construction/grader.png', 'Grader'),
    ConstructionCategory('assets/images/construction/loader.png', 'Loader'),
    ConstructionCategory('assets/images/construction/paver.png', 'Paver'),
    ConstructionCategory('assets/images/construction/trencher.png', 'Trencher'),
  ];
  List<FeaturedDeals> featuredDeals = [
    FeaturedDeals(
        path: 'assets/images/image1.jpeg',
        name: 'Baldozer',
        price: 40000,
        location: 'Faisal Town, Lahore',
        date: '18 May',
        favorited: false.obs),
    FeaturedDeals(
        path: 'assets/images/image1.jpeg',
        name: 'Baldozer',
        price: 30000,
        location: 'Faisal Town, Lahore',
        date: '18 May',
        favorited: false.obs),
    FeaturedDeals(
        path: 'assets/images/image1.jpeg',
        name: 'Baldozer',
        price: 40000,
        location: 'Faisal Town, Lahore',
        date: '18 May',
        favorited: false.obs),
    FeaturedDeals(
        path: 'assets/images/image1.jpeg',
        name: 'Baldozer',
        price: 30000,
        location: 'Faisal Town, Lahore',
        date: '18 May',
        favorited: false.obs),
  ];
  var category = 1.obs;

  void changeCategory(int num) {
    category.value = num;
  }

  void addToFavorites(int index) {
    featuredDeals[index].favorited.value =
        !featuredDeals[index].favorited.value;
  }
}
