import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rentapp/controllers/user_info_controller.dart';
import 'package:rentapp/models/posts_model.dart';

class ChatController extends GetxController {
  late User user;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Rx<PostsModel> selectedAdDetails = PostsModel.empty().obs;
  TextEditingController amountController = TextEditingController();

  TextEditingController messageController = TextEditingController();
  UserInfoController userInfoController = Get.find();

  RxList<PostsModel> postsList = <PostsModel>[].obs;

  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;

  changeStartDate(DateTime date) {
    startDate.value = date;
  }

  changeEndDate(DateTime date) {
    endDate.value = date;
  }

  Stream<QuerySnapshot> getMessages(String toId) {
    String fromId = userId;
    // String toId = toId;
    // String postId = postDetails.id;
    return _firebaseFirestore
        .collection('Chats/$fromId/$toId')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  sendMessage(String toId) async {
    String fromId = userId;
    // String postId = postDetails.id;
    // String path = 'Chats/$fromId/$toId/$postId';
    print('from user id is $userId');
    print('to user id is ${toId}');
    //print('post id is ${postDetails.id}');
    // print('final is ${path}');
    FocusManager.instance.primaryFocus?.unfocus();
    var message = messageController.text;
    messageController.clear();

    try {
      var message1 =
          await _firebaseFirestore.collection('Chats/$fromId/$toId').add({
        'type': 'M',
        'to': toId,
        'from': fromId,
        'createdAt': DateTime.now(),
        'message': message
      });
      print("message 1 id is ${message1.id}");

      var message2 =
          await _firebaseFirestore.collection('Chats/$toId/$fromId').add({
        'type': 'M',
        'to': toId,
        'from': fromId,
        'createdAt': DateTime.now(),
        'message': message
      });

      print("message 2 id is ${message2.id}");

      await _firebaseFirestore
          .collection('Chats/$fromId/$toId')
          .doc(message1.id)
          .update({
        'type': 'M',
        'to': toId,
        'from': fromId,
        'createdAt': DateTime.now(),
        'message': message,
        'toMessageId': message1.id,
        'fromMessageId': message2.id
      });

      await _firebaseFirestore
          .collection('Chats/$toId/$fromId')
          .doc(message2.id)
          .update({
        'type': 'M',
        'to': toId,
        'from': fromId,
        'createdAt': DateTime.now(),
        'message': message,
        'id': message2.id,
        'toMessageId': message1.id,
        'fromMessageId': message2.id
      });

      var a = await _firebaseFirestore
          .collection('NewMessages')
          .where('from', isEqualTo: userId)
          .where('to', isEqualTo: toId)
          .get();
      if (a.docs.isEmpty) {
        await _firebaseFirestore.collection('NewMessages').add({
          'type': 'M',
          'to': toId,
          'from': userId,
          'createdAt': DateTime.now(),
          'message': message,
          'toUserName': userInfoController.postUserInfo.name,
        });
      } else {
        await _firebaseFirestore
            .collection('NewMessages')
            .doc(a.docs[0].id)
            .update({
          'type': 'M',
          'to': toId,
          'from': userId,
          'createdAt': DateTime.now(),
          'message': message,
          'toUserName': userInfoController.postUserInfo.name,
        });
      }
      a = await _firebaseFirestore
          .collection('NewMessages')
          .where('to', isEqualTo: userId)
          .where('from', isEqualTo: toId)
          .get();
      if (a.docs.isEmpty) {
        await _firebaseFirestore.collection('NewMessages').add({
          'type': 'M',
          'to': fromId,
          'from': toId,
          'createdAt': DateTime.now(),
          'message': message,
          'toUserName': userInfoController.currentUserInfo.name,
        });
      } else {
        await _firebaseFirestore
            .collection('NewMessages')
            .doc(a.docs[0].id)
            .update({
          'type': 'M',
          'to': fromId,
          'from': toId,
          'createdAt': DateTime.now(),
          'message': message,
          'toUserName': userInfoController.currentUserInfo.name,
        });
      }

      //messageController.clear();
    } catch (err) {
      print('Send Message error is $err');
    }
  }

  Stream<QuerySnapshot> getLatestMessages() {
    String fromId = userId;

    return _firebaseFirestore
        .collection('NewMessages/')
        .where('from', isEqualTo: userId)
        .snapshots();
  }

  Future<void> submitRequest(String toId) async {
    Get.back();

    print('submit');
    print('fromId is $userId toId is $toId');
    print(startDate);
    print(endDate);

    var diff = startDate.value.difference(endDate.value);
    String imageUrl = selectedAdDetails.value.imagesUrl[0];
    print('diff in hours ${diff.inHours}');

    print('selectedAdDetails ${selectedAdDetails.value.imagesUrl[0]}');
    try {
      var fromMessageId =
          await _firebaseFirestore.collection('Chats/$userId/$toId').add({
        'type': 'R',
        'to': toId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': '1',
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'amount': amountController.text,
        'status': 'P',
        'adId': selectedAdDetails.value.id,
        'imgUrl': imageUrl,
        'price': selectedAdDetails.value.price,
        'subCategory': selectedAdDetails.value.subCategory
      });

      var toMessageId =
          await _firebaseFirestore.collection('Chats/$toId/$userId').add({
        'type': 'R',
        'status': 'P',
        'to': toId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': '1',
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'amount': amountController.text,
        'adId': selectedAdDetails.value.id,
        'imgUrl': imageUrl,
        'price': selectedAdDetails.value.price,
        'subCategory': selectedAdDetails.value.subCategory
      });

      //print('selectedAdDetails ${selectedAdDetails.value.imagesUrl[0]}');

      await _firebaseFirestore
          .collection('Chats/$userId/$toId')
          .doc(fromMessageId.id)
          .update({
        'type': 'R',
        'to': toId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': '1',
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'amount': amountController.text,
        'status': 'P',
        'fromMessageId': fromMessageId.id,
        'toMessageId': toMessageId.id,
        'adId': selectedAdDetails.value.id,
        'imgUrl': selectedAdDetails.value.imagesUrl[0],
        'price': selectedAdDetails.value.price,
        'subCategory': selectedAdDetails.value.subCategory
      });

      await _firebaseFirestore
          .collection('Chats/$toId/$userId')
          .doc(toMessageId.id)
          .update({
        'type': 'R',
        'status': 'P',
        'to': toId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': '1',
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'amount': amountController.text,
        'fromMessageId': fromMessageId.id,
        'toMessageId': toMessageId.id,
        'adId': selectedAdDetails.value.id,
        'imgUrl': selectedAdDetails.value.imagesUrl[0],
        'price': selectedAdDetails.value.price,
        'subCategory': selectedAdDetails.value.subCategory
      });
      //Get.back();
    } catch (err) {
      print('err is $err');
    }
  }

  Future<void> rejected(
    String fromId,
    String fromMessageId,
    String toId,
    String toMessageId,
  ) async {
    print('');
    try {
      print('form $fromId');
      print('formMessageId $fromMessageId');
      print('toMessageId $toId');
      print('toMessageId $toMessageId');
      await _firebaseFirestore
          .collection('Chats/$fromId/$toId')
          .doc(fromMessageId)
          .update({
        'type': 'R',
        'to': toId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': '1',
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'amount': amountController.text,
        'status': 'R'
      });
    } catch (err) {
      print('reject request error is $err');
    }

    try {
      await _firebaseFirestore
          .collection('Chats/$toId/$fromId')
          .doc(toMessageId)
          .update({
        'type': 'R',
        'to': toId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': '1',
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'amount': amountController.text,
        'status': 'R'
      });
    } catch (err) {
      print('reject request error is $err');
    }
  }

  Future<void> accepted(String adId, String fromId, String fromMessageId,
      String toId, String toMessageId, String startDate, String endDate) async {
    print('start accepted:');
    // try {
    //   print('form $fromId');
    //   print('formMessageId $fromMessageId');
    //   print('toMessageId $toId');
    //   print('toMessageId $toMessageId');
    //   await _firebaseFirestore
    //       .collection('Chats/$fromId/$toId')
    //       .doc(fromMessageId)
    //       .update({
    //     'type': 'R',
    //     'to': toId,
    //     'from': userId,
    //     'createdAt': DateTime.now(),
    //     'message': '1',
    //     'startDate': startDate.toString(),
    //     'endDate': endDate.toString(),
    //     'amount': amountController.text,
    //     'status': 'R'
    //   });
    // } catch (err) {
    //   print('reject request error is $err');
    // }

    // try {
    //   await _firebaseFirestore
    //       .collection('Chats/$toId/$fromId')
    //       .doc(toMessageId)
    //       .update({
    //     'type': 'R',
    //     'to': toId,
    //     'from': userId,
    //     'createdAt': DateTime.now(),
    //     'message': '1',
    //     'startDate': startDate.toString(),
    //     'endDate': endDate.toString(),
    //     'amount': amountController.text,
    //     'status': 'R'
    //   });
    // } catch (err) {
    //   print('reject request error is $err');
    // }
    print('ad id is $adId');
    print('toid is $toId');
    print('from id is $fromId');
    try {
      await _firebaseFirestore.collection('Posts').doc(adId).update({
        "status": "rented",
        "renteeId": fromId,
        "startDate": startDate,
        "endDate": endDate
      });

      await _firebaseFirestore
          .collection('Chats/$fromId/$toId')
          .doc(fromMessageId)
          .update({
        'type': 'R',
        'to': toId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': '1',
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'amount': amountController.text,
        'status': 'A'
      });

      await _firebaseFirestore
          .collection('Chats/$toId/$fromId')
          .doc(toMessageId)
          .update({
        'type': 'R',
        'to': toId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': '1',
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'amount': amountController.text,
        'status': 'A'
      });
    } catch (err) {}
  }

  Future<void> withDrawRequest(
    String fromId,
    String fromMessageId,
    String toId,
    String toMessageId,
  ) async {
    print('form $fromId');
    print('formMessageId $fromMessageId');
    print('toMessageId $toId');
    print('toMessageId $toMessageId');
    try {
      await _firebaseFirestore
          .collection('Chats/$fromId/$toId')
          .doc(fromMessageId)
          .update({
        'type': 'R',
        'to': toId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': '1',
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'amount': amountController.text,
        'status': 'W'
      });
    } catch (err) {
      print('submit request error is $err');
    }

    try {
      await _firebaseFirestore
          .collection('Chats/$toId/$fromId')
          .doc(toMessageId)
          .update({
        'type': 'R',
        'to': toId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': '1',
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'amount': amountController.text,
        'status': 'W'
      });
    } catch (err) {
      print('submit request error is $err');
    }
  }

  Future<void> getAllAds(String userId) async {
    print("Start getAllAds:");
    print("id is $userId");

    postsList.clear();
    try {
      var posts = await _firebaseFirestore
          .collection('Posts')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'approved')
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
        //temp.createdAt = posts.docs[i]['createdAt'];
        postsList.add(temp);
      }
    } catch (err) {
      print('getPost error $err');
    }
  }

  clearDataAfterSubmit() {
    amountController.clear();
    selectedAdDetails.value = PostsModel.empty();
    startDate.value = DateTime.now();
    endDate.value = DateTime.now();
  }
}
