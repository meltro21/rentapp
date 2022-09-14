import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rentapp/models/home_screen/featured_deals_model.dart';
import 'package:rentapp/models/posts_model.dart';

class ConstructionCategory {
  String path;
  String name;

  ConstructionCategory(this.path, this.name);
}

class HomeScreenController extends GetxController {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  RxList<PostsModel> postsList = <PostsModel>[].obs;
  RxList<bool> favorites = <bool>[].obs;
  late User user;
  String userId = '';
  Rx<bool> loading = false.obs;

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

  getPosts() async {
    user = _firebaseAuth.currentUser!;
    userId = user.uid;
    loading.value = true;
    try {
      var posts = await _firebaseFirestore.collection('Posts').get();
      print('posts is $posts');
      for (int i = 0; i < posts.docs.length; i++) {
        if (posts.docs[i]['userId'] != userId) {
          PostsModel temp = PostsModel.empty();
          temp.id = posts.docs[i]['id'];
          temp.category = posts.docs[i]['category'];
          temp.subCategory = posts.docs[i]['subCategory'];
          temp.price = posts.docs[i]['price'];
          temp.model = posts.docs[i]['model'];
          temp.description = posts.docs[i]['description'];
          temp.imagesUrl = posts.docs[i]['imagesUrl'];
          temp.address = posts.docs[i]['address'];
          temp.lat = posts.docs[i]['lat'];
          temp.lng = posts.docs[i]['lng'];
          temp.userId = posts.docs[i]['userId'];
          //temp.createdAt = posts.docs[i]['createdAt'];
          temp.favorites = posts.docs[i]['favorites'];
          postsList.add(temp);

          if (temp.favorites.contains(userId)) {
            favorites.add(true);
          } else {
            favorites.add(false);
          }
        }
      }
      loading.value = false;
    } catch (err) {
      print('getPost error $err');
    }
  }

  List<FeaturedDeals> featuredDeals = [
    FeaturedDeals(
        id: 1,
        path: 'assets/images/image1.jpeg',
        name: 'Baldozer',
        price: 40000,
        location: 'Faisal Town, Lahore',
        date: '18 May',
        favorited: false.obs),
    FeaturedDeals(
        id: 2,
        path: 'assets/images/image2.jpeg',
        name: 'Baldozer',
        price: 30000,
        location: 'Faisal Town, Lahore',
        date: '18 May',
        favorited: false.obs),
    FeaturedDeals(
        id: 3,
        path: 'assets/images/image4.jpeg',
        name: 'Baldozer',
        price: 40000,
        location: 'Faisal Town, Lahore',
        date: '18 May',
        favorited: false.obs),
    FeaturedDeals(
        id: 4,
        path: 'assets/images/image5.jpeg',
        name: 'Excavator',
        price: 15000,
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

  Future<void> addTo(int index) async {
    print('in add to favorites');
    try {
      var a =
          await _firebaseFirestore.collection("Posts").doc(postsList[index].id);
      a.update({
        'favorites': FieldValue.arrayUnion([userId])
      });
      favorites[index] = true;
    } catch (err) {
      print('add to favorites error is $err');
    }
  }

  Future<void> removeTo(int index) async {
    print('in add to favorites');
    try {
      var a =
          await _firebaseFirestore.collection("Posts").doc(postsList[index].id);
      a.update({
        'favorites': FieldValue.arrayRemove([userId])
      });
      favorites[index] = false;
    } catch (err) {
      print('remove to favorites error is $err');
    }
  }
}
