import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/posts_model.dart';

class PendingAdsController extends GetxController {
  RxList<PostsModel> postsList = <PostsModel>[].obs;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  var items = [
    'pending',
    'approved',
    'rejected',
  ];
  List<String> dropdownvalue = [];

  getPosts() async {
    postsList.clear();

    try {
      var posts = await _firebaseFirestore
          .collection('Posts')
          // .where('status', isEqualTo: "pending")
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
        dropdownvalue.add(posts.docs[i]['status']);
        //temp.createdAt = posts.docs[i]['createdAt'];
        postsList.add(temp);
      }
    } catch (err) {
      print('getPost error $err');
    }
  }

  updateStatus(int index, String? status) async {
    var post = await _firebaseFirestore
        .collection('Posts')
        .doc(postsList[index].id)
        .update({
      'category': postsList[index].category,
      'subCategory': postsList[index].subCategory,
      'price': postsList[index].price,
      'model': postsList[index].model,
      'description': postsList[index].description,
      'createdAt': postsList[index].createdAt,
      'address': postsList[index].address,
      'lat': postsList[index].lat,
      'lng': postsList[index].lng,
      'userId': postsList[index].userId,
      'favorites': postsList[index].favorites,
      'status': status
    });
  }
}
