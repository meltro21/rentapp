import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rentapp/models/posts_model.dart';
import 'package:rentapp/models/user_model.dart';

class UserInfoController extends GetxController {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel currentUserInfo = UserModel('', '', '', '', '');
  UserModel postUserInfo = UserModel('', '', '', '', '');
  TextEditingController nameController = TextEditingController();
  TextEditingController somethingController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  var favouriteAdds = [].obs;
  var selectAdsOrFavourites = 1.obs;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late User user;
  RxList<PostsModel> postsList = <PostsModel>[].obs;
  String userId = '';
  RxList<bool> favorites = <bool>[].obs;
  Rx<bool> loading = false.obs;

//Feedback
  Rx<int> rating = 0.obs;
  TextEditingController descriptionController = TextEditingController();

  var startDate = DateTime.now().obs;

  changeStartDate(DateTime date) {
    startDate.value = date;
  }

  Future<void> getUserInfo() async {
    String currentUserId = _auth.currentUser!.uid;
    print('currentUser id is $currentUserId');
    var a;
    try {
      a = await _firebaseFirestore
          .collection('Users')
          .where('userId', isEqualTo: currentUserId)
          .get();
    } catch (err) {
      print('get user data $err');
    }
    currentUserInfo.eamil = a.docs[0]['email'];
    currentUserInfo.name = a.docs[0]['name'];
    currentUserInfo.userId = a.docs[0]['userId'];
  }

  Future<void> getPostUserAllData(String toUserId) async {
    print('currentUser id is $toUserId');
    var a;
    try {
      a = await _firebaseFirestore
          .collection('Users')
          .where('userId', isEqualTo: toUserId)
          .get();
      postUserInfo.eamil = a.docs[0]['email'];
      postUserInfo.name = a.docs[0]['name'];
      print('name is ${postUserInfo.name}');
    } catch (err) {
      print('get user data $err');
    }
    //postUserInfo.name = a.docs[0]['name'];
  }

  Future<void> updateUserData() async {
    String currentUserId = _auth.currentUser!.uid;
  }

  setRating(int rate) {
    rating.value = rate;
  }

  Future<void> submitFeedback(int index) async {
    loading.value = true;
    var fromId = currentUserInfo.userId;
    var toId = postsList[index].renteeId;
    var adId = postsList[index].id;

    print('fromid is $fromId');
    print('to id is $toId');

    try {
      await _firebaseFirestore
          .collection('Posts')
          .doc('$adId')
          .update({'status': 'approved'});

      await _firebaseFirestore.collection('Feedback').add({
        'toId': toId,
        'fromId': fromId,
        'rating': rating.value,
        'description': descriptionController.text,
        'name': currentUserInfo.name
      });
      rating.value = 0;
      descriptionController.clear();

      Get.showSnackbar(GetSnackBar(
        title: 'Success',
        message: 'Feedback submitted successfully',
        duration: Duration(seconds: 3),
        borderColor: Colors.green,
        backgroundColor: Colors.green,
      ));
    } catch (err) {
      print('err is $err');
    }
    loading.value = false;
  }

  getPosts() async {
    postsList.clear();
    user = _firebaseAuth.currentUser!;
    userId = user.uid;
    try {
      var posts = await _firebaseFirestore
          .collection('Posts')
          .where(
            'userId',
            isEqualTo: userId,
          )
          .where('status', isEqualTo: 'rented')
          .get();
      print('posts is $posts');
      for (int i = 0; i < posts.docs.length; i++) {
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
        temp.status = posts.docs[i]['status'];
        temp.startDate = posts.docs[i]['startDate'];
        temp.endDate = posts.docs[i]['endDate'];
        temp.renteeId = posts.docs[i]['renteeId'];
        //temp.createdAt = posts.docs[i]['createdAt'];
        postsList.add(temp);
      }
    } catch (err) {
      print('getPost error $err');
    }
  }
}
