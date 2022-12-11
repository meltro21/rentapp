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

    var diff = startDate.value.difference(endDate.value);

    print('diff in hours ${diff.inHours}');

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
        'status': 'P'
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
        'amount': amountController.text
      });

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
        'toMessageId': toMessageId.id
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
        'toMessageId': toMessageId.id
      });
      //Get.back();
    } catch (err) {}
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

  Future<void> accepted(
    String fromId,
    String fromMessageId,
    String toId,
    String toMessageId,
  ) async {

    print(postDetails.id);
    print('');
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
}
