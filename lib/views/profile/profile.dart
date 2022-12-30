import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rentapp/controllers/auth_controller.dart';
import 'package:rentapp/controllers/user_info_controller.dart';
import 'package:rentapp/views/authentication/login.dart';
import 'package:rentapp/views/profile/edit_profile.dart';
import 'package:rentapp/views/profile/sell_orders.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserInfoController _userInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;
    var mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
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
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_userInfoController.currentUserInfo.name),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(EditProfile());
                      },
                      child: Text(
                        'View and edit profile',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                )
              ]),
            ),

            //Orders
            Divider(),
            InkWell(
              onTap: () {
                Get.to(SellOrders());
              },
              child: Row(
                children: [
                  Text(
                    'Sell Orders',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Row(
              children: [
                Text(
                  'Buy Orders',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
