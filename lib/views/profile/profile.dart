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
  //AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;
    var mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          //child: RaisedButton(
          //   onPressed: (() async {
          //     // var logOut = await authController.logout();
          //     // if (logOut == true) {
          //     //   Get.off(LoginScreen());
          //     // }
          //   }),
          child: Column(children: [
            //profile seciton
            Container(
              height: mediaHeight * 0.1,
              width: mediaWidth,
              child: Row(children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/person1.jpeg"),
                  maxRadius: 30,
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
