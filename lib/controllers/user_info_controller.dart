import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rentapp/models/user_model.dart';

class UserInfoController extends GetxController {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel currentUserInfo = UserModel('', '', '', '', '');
  UserModel postUserInfo = UserModel('', '', '', '', '');
  TextEditingController nameController = TextEditingController();
  TextEditingController somethingController = TextEditingController();
  TextEditingController dateController = TextEditingController();

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
}
