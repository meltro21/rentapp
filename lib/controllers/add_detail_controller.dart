import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rentapp/controllers/auth_controller.dart';
import 'package:rentapp/models/user_model.dart';

class AddDetailController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController amountController = TextEditingController();
  var readMore = false.obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  User? currentUser;
  String currentUserId = '';
  UserModel posterInfo = UserModel('', '', '', '', '');
  changeReadMoreValue() {
    readMore.value = !readMore.value;
  }

  changeStartDate(DateTime date) {
    startDate.value = date;
  }

  changeEndDate(DateTime date) {
    endDate.value = date;
  }

  getCurrentUser() {
    currentUser = _auth.currentUser;
    currentUserId = currentUser!.uid;
  }

  Future<void> submitRequest(String toUserId) async {
    await _firestore.collection('SubmitRequests').add({
      'amount': int.parse(amountController.text),
      'startDate': startDate.value,
      'endDate': endDate.value,
      'formUserId': currentUserId,
      'toUserId': toUserId,
      'createdAt': DateTime.now()
    });
  }

  Future<UserModel> getPosterInfo(String posterId) async {
    print('in the get method');
    var a = await _firestore
        .collection("Users")
        .where('userId', isEqualTo: posterId)
        .get();
    posterInfo.eamil = a.docs[0]['email'];
    posterInfo.name = a.docs[0]['name'];
    print('email is $posterInfo');
    print("end");
    return posterInfo;
  }
}
