import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rentapp/models/posts_model.dart';

class ChatController extends GetxController {
  late User user;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late PostsModel postDetails;
  TextEditingController messageController = TextEditingController();

  Stream<QuerySnapshot> getMessages() {
    String fromId = userId;
    String toId = postDetails.userId;
    String postId = postDetails.id;
    return _firebaseFirestore
        .collection('Chats/$fromId/$toId/$postId/posts')
        .snapshots();
  }

  sendMessage() async {
    String fromId = userId;
    String toId = postDetails.userId;
    String postId = postDetails.id;
    String path = 'Chats/$fromId/$toId/$postId';
    print(userId);
    print(postDetails.userId);
    print(postDetails.id);
    print('final is ${path}');
    try {
      await _firebaseFirestore
          .collection('Chats/$fromId/$toId/$postId/posts')
          .add({
        'to': postDetails.userId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': messageController.text
      });
      await _firebaseFirestore
          .collection('Chats/$toId/$fromId/$postId/posts')
          .add({
        'to': postDetails.userId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': messageController.text
      });
      // _firebaseFirestore
      //     .collection("/Chats").doc(fromId).collection(toId)
      //     .add({
      //   'to': postDetails.userId,
      //   'from': userId,
      //   'createdAt': DateTime.now(),
      //   'message': messageController.text
      // });
    } catch (err) {
      print('Send Message error is $err');
    }
  }
}
