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
  TextEditingController amountController = TextEditingController();

  TextEditingController messageController = TextEditingController();
  UserInfoController userInfoController = Get.find();

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

    try {
      await _firebaseFirestore.collection('Chats/$fromId/$toId').add({
        'type': 'M',
        'to': toId,
        'from': fromId,
        'createdAt': DateTime.now(),
        'message': messageController.text
      });

      await _firebaseFirestore.collection('Chats/$toId/$fromId').add({
        'type': 'M',
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
          'type': 'M',
          'to': toId,
          'from': userId,
          'createdAt': DateTime.now(),
          'message': messageController.text,
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
          'message': messageController.text,
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
          'message': messageController.text,
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
          'message': messageController.text,
          'toUserName': userInfoController.currentUserInfo.name,
        });
      }

      messageController.clear();
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
    print('submit');
    try {
      await _firebaseFirestore.collection('Chats/$userId/$toId').add({
        'type': 'R',
        'to': toId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': '1',
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'amount': amountController.text,
        'status': 'pending'
      });
    } catch (err) {
      print('submit request error is $err');
    }

    try {
      await _firebaseFirestore.collection('Chats/$toId/$userId').add({
        'type': 'R',
        'status': 'pending',
        'to': toId,
        'from': userId,
        'createdAt': DateTime.now(),
        'message': '1',
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'amount': amountController.text
      });
    } catch (err) {
      print('submit request error is $err');
    }
  }

  Future<void> rejected(String toId, String docId) async {
    try {
      await _firebaseFirestore
          .collection('Chats/$userId/$toId')
          .doc(docId)
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
      print('submit request error is $err');
    }

    try {
      await _firebaseFirestore
          .collection('Chats/$toId/$userId')
          .doc(docId)
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
      print('submit request error is $err');
    }
  }
}
