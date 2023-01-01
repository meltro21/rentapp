import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rentapp/models/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late UserCredential userCredential;
  late User user;
  UserModel currentUser = UserModel('', '', '', '', '');
  var loading = false.obs;

  Future<bool> registerWithEmailAndPassword(
      String email, String password, String name, String mobileNumber) async {
    // userLoggedIn.value = !userLoggedIn.value;
    print(email);
    print(password);
    //print('userLoggedIn value is ${userLoggedIn.value}');

    loading.value = true;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(userCredential);
      user = userCredential.user!;

      if (user == null) {
        loading.value = false;
        print('cannot sign in with those credentials');
        return false;
      } else {
        try {
          await _firestore.collection('Users').add({
            'userId': user.uid,
            'name': name,
            'email': email,
            'password': password,
            'mobileNumber': mobileNumber
          });
          try {
            var a = await _firestore
                .collection('Users')
                .where('userId', isEqualTo: user.uid)
                .get();
            print('value of a is $a');

            a.docs.forEach((element) {
              print('email is ${element.data()['email']}');
              currentUser.userId = element.id;
              currentUser.name = element.data()['name'];
              currentUser.password = element.data()['password'];
              currentUser.eamil = element.data()['email'];
              currentUser.mobileNumber = element.data()['mobileNumber'];
            });

            //await user.sendEmailVerification();
            //userLoggedIn.value = true;

            loading.value = false;
            return true;
            print('a is $a');
          } catch (error) {
            print(error);
            loading.value = false;
            return false;
          }

          print('User Uploaded');
        } catch (error) {
          loading.value = false;
          return false;
          print('Error');
        }
        loading.value = false;
        //print('userLoggedIn value is ${userLoggedIn.value}');

        //  print('UserLogged in value is ${userLoggedIn.value}');
      }
    } catch (error) {
      loading.value = false;
      print(error);
      var er = error.toString();
      var err = er.split(']');
      print('er is $er');
      print('err is ${err[1]}');
      Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 3),
        title: 'Error',
        message: '${err[1]}',
      ));
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    loading.value = true;
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (err) {
      loading.value = false;
      Get.defaultDialog(title: 'Signin Error', content: Text('$err'));
      print('signIN error is $err');
    }
    loading.value = false;
    if (userCredential.isBlank == true) {
      return false;
    }
    return true;
  }

  Future<bool> forgotPassword(String email) async {
    loading.value = true;
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) {
        String s = "Password reset link is send to ${email}";
        Get.showSnackbar(GetSnackBar(
          title: 'Success',
          message: 'Password Reset Link is sent successfully',
          duration: Duration(seconds: 3),
          borderColor: Colors.green,
          backgroundColor: Colors.green,
        ));

        //Navigator.pop(context);
      }).catchError((onError) {
        print("Error is $onError");
        String s = "Unable to send link, Error: $onError";
        Get.showSnackbar(GetSnackBar(
          title: 'Failure',
          message: 'Unable to send password reset link',
          duration: Duration(seconds: 3),
          borderColor: Colors.green,
          backgroundColor: Colors.red,
        ));
      });
    } catch (err) {
      loading.value = false;
      print('signIN error is $err');
    }
    loading.value = false;
    return true;
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } catch (err) {
      print('logout error is $err');
      return false;
    }
  }
}
