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
    return _firebaseFirestore.collection('Chats/$fromId/$toId').snapshots();
  }

  sendMessage() async {
    String fromId = userId;
    String toId = postDetails.userId;
    String postId = postDetails.id;
    String path = 'Chats/$fromId/$toId/$postId';
    print('from user id is $userId');
    print('to user id is ${postDetails.userId}');
    print('post id is ${postDetails.id}');
    print('final is ${path}');
    try {
      await _firebaseFirestore.collection('Chats/$fromId/$toId').add({
        'to': postDetails.userId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': messageController.text
      });
      await _firebaseFirestore.collection('Chats/$toId/$fromId').add({
        'to': userId,
        'from': postDetails.userId,
        'createdAt': DateTime.now(),
        'message': messageController.text
      });

      var a = await _firebaseFirestore
          .collection('NewMessages')
          .where('from', isEqualTo: userId)
          .where('to', isEqualTo: postDetails.userId)
          .get();
      if (a.docs.isEmpty) {
        _firebaseFirestore.collection('NewMessages').add({
          'to': userId,
          'from': postDetails.userId,
          'createdAt': DateTime.now(),
          'message': messageController.text
        });
        _firebaseFirestore.collection('NewMessages').add({
          'to': postDetails.userId,
          'from': userId,
          'createdAt': DateTime.now(),
          'message': messageController.text
        });
      } else {
        _firebaseFirestore.collection('NewMessages').doc(a.docs[0].id).update({
          'to': userId,
          'from': postDetails.userId,
          'createdAt': DateTime.now(),
          'message': messageController.text
        });
        _firebaseFirestore.collection('NewMessages').doc(a.docs[0].id).update({
          'to': postDetails.userId,
          'from': userId,
          'createdAt': DateTime.now(),
          'message': messageController.text
        });
      }

      // //latest-message
      // await _firebaseFirestore.collection('NewMessages').doc(fromId).set({
      //   '$toId': {
      //     'to': postDetails.userId,
      //     'from': userId,
      //     'createdAt': DateTime.now(),
      //     'message': messageController.text
      //   }
      // });

      // await _firebaseFirestore.collection('NewMessages').doc(toId).set({
      //   '$fromId': {
      //     'to': userId,
      //     'from': postDetails.userId,
      //     'createdAt': DateTime.now(),
      //     'message': messageController.text
      //   }
      // });

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
