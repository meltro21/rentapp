import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rentapp/controllers/auth_controller.dart';

class AddDetailController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController amountController = TextEditingController();
  var readMore = false.obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  User? currentUser;
  String currentUserId = '';
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
}
