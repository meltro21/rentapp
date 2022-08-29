import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rentapp/controllers/home_screen_controller.dart';
import 'package:rentapp/models/posts_model.dart';

import '../models/home_screen/featured_deals_model.dart';

class MyAddsController extends GetxController {
  var favouriteAdds = [].obs;
  var selectAdsOrFavourites = 1.obs;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  RxList<PostsModel> postsList = <PostsModel>[].obs;

  changeSelection(int choice) {
    selectAdsOrFavourites.value = choice;
  }

  addToFavourites(FeaturedDeals favoriteAdd) {
    favouriteAdds.add(favoriteAdd);
  }

  removeFromFavouritesUsingHomeScreen(int id) {
    for (int i = 0; i < favouriteAdds.length; i++) {
      if (favouriteAdds[i].id == id) {
        favouriteAdds.remove(favouriteAdds[i]);
      }
    }
  }

  removeFromFavourites(int index) {
    HomeScreenController homeScreenController = Get.find();
    for (int i = 0; i < homeScreenController.featuredDeals.length; i++) {
      if (favouriteAdds[index].id == homeScreenController.featuredDeals[i].id) {
        homeScreenController.featuredDeals[i].favorited.value =
            !homeScreenController.featuredDeals[i].favorited.value;
      }
    }
    favouriteAdds.remove(favouriteAdds[index]);
  }

  getPosts() async {
    try {
      var posts = await _firebaseFirestore.collection('Posts').get();
      for (int i = 0; i < posts.docs.length; i++) {
        PostsModel temp = PostsModel.empty();
        temp.category = posts.docs[i]['category'];
        temp.price = posts.docs[i]['price'];
        temp.model = posts.docs[i]['model'];
        temp.description = posts.docs[i]['description'];
        temp.imagesUrl = posts.docs[i]['imagesUrl'];
        temp.address = posts.docs[i]['address'];
        //temp.createdAt = posts.docs[i]['createdAt'];
        postsList.add(temp);
      }
    } catch (err) {
      print('getPost error $err');
    }
  }
}
