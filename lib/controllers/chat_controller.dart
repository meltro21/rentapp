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
  late PostsModel postDetails;
  TextEditingController messageController = TextEditingController();
  UserInfoController userInfoController = Get.find();

  Stream<QuerySnapshot> getMessages(String toId) {
    String fromId = userId;
    // String toId = toId;
    // String postId = postDetails.id;
    return _firebaseFirestore
        .collection('Chats/$fromId/$toId')
        .orderBy('createdAt', descending: false)
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

    try {
      await _firebaseFirestore.collection('Chats/$fromId/$toId').add({
        'to': toId,
        'from': fromId,
        'createdAt': DateTime.now(),
        'message': messageController.text
      });

      await _firebaseFirestore.collection('Chats/$toId/$fromId').add({
        'to': toId,
        'from': fromId,
        'createdAt': DateTime.now(),
        'message': messageController.text
      });

      var a = await _firebaseFirestore
          .collection('NewMessages')
          .where('from', isEqualTo: userId)
          .where('to', isEqualTo: toId)
          .get();
      if (a.docs.isEmpty) {
        await _firebaseFirestore.collection('NewMessages').add({
          'to': toId,
          'from': userId,
          'createdAt': DateTime.now(),
          'message': messageController.text,
          'toUserName': userInfoController.postUserInfo.name,
        });
        // await _firebaseFirestore.collection('NewMessages').add({
        //   'to': fromId,
        //   'from': toId,
        //   'createdAt': DateTime.now(),
        //   'message': messageController.text,
        //   'toUserName': userInfoController.userInfo.name,
        // });
      } else {
        await _firebaseFirestore
            .collection('NewMessages')
            .doc(a.docs[0].id)
            .update({
          'to': toId,
          'from': userId,
          'createdAt': DateTime.now(),
          'message': messageController.text,
          'toUserName': userInfoController.postUserInfo.name,
        });
        // await _firebaseFirestore
        //     .collection('NewMessages')
        //     .doc(a.docs[0].id)
        //     .update({
        //   'to': fromId,
        //   'from': toId,
        //   'createdAt': DateTime.now(),
        //   'message': messageController.text,
        //   'toUserName': userInfoController.userInfo.name,
        // });
      }
      a = await _firebaseFirestore
          .collection('NewMessages')
          .where('to', isEqualTo: userId)
          .where('from', isEqualTo: toId)
          .get();
      if (a.docs.isEmpty) {
        // await _firebaseFirestore.collection('NewMessages').add({
        //   'to': userId,
        //   'from': toId,
        //   'createdAt': DateTime.now(),
        //   'message': messageController.text,
        //   'toUserName': userInfoController.userInfo.name,
        // });
        await _firebaseFirestore.collection('NewMessages').add({
          'to': fromId,
          'from': toId,
          'createdAt': DateTime.now(),
          'message': messageController.text,
          'toUserName': userInfoController.currentUserInfo.name,
        });
      } else {
        // await _firebaseFirestore
        //     .collection('NewMessages')
        //     .doc(a.docs[0].id)
        //     .update({
        //   'to': userId,
        //   'from': toId,
        //   'createdAt': DateTime.now(),
        //   'message': messageController.text,
        //   'toUserName': userInfoController.userInfo.name,
        // });
        await _firebaseFirestore
            .collection('NewMessages')
            .doc(a.docs[0].id)
            .update({
          'to': fromId,
          'from': toId,
          'createdAt': DateTime.now(),
          'message': messageController.text,
          'toUserName': userInfoController.currentUserInfo.name,
        });
      }

      messageController.clear();

      // //latest-message
      // await _firebaseFirestore.collection('NewMessages').doc(fromId).set({
      //   '$toId': {
      //     'to': toId,
      //     'from': userId,
      //     'createdAt': DateTime.now(),
      //     'message': messageController.text
      //   }
      // });

      // await _firebaseFirestore.collection('NewMessages').doc(toId).set({
      //   '$fromId': {
      //     'to': userId,
      //     'from': toId,
      //     'createdAt': DateTime.now(),
      //     'message': messageController.text
      //   }
      // });

      // _firebaseFirestore
      //     .collection("/Chats").doc(fromId).collection(toId)
      //     .add({
      //   'to': toId,
      //   'from': userId,
      //   'createdAt': DateTime.now(),
      //   'message': messageController.text
      // });
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

  Future<void> getLatestMessagess() async {
    // String fromId = userId;
    // print('in');
    // var a = _firebaseFirestore.collection('NewMessages').doc(userId);
  }
}
