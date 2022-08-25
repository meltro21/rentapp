import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rentapp/controllers/auth_controller.dart';
import 'package:rentapp/views/authentication/login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: RaisedButton(
        onPressed: (() async {
          var logOut = await authController.logout();
          if (logOut == true) {
            Get.off(LoginScreen());
          }
        }),
      )),
    );
  }
}
