import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rentapp/controllers/user_info_controller.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DateTime selectedDate = DateTime.now();
  UserInfoController _userInfoController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userInfoController.nameController.text =
        _userInfoController.currentUserInfo.name;
    _userInfoController.dateController.text = DateTime.now.toString();
  }

  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;
    var mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //App bar
            Container(
              color: Colors.grey[300],
              height: 50,
              width: mediaWidth,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.close)),
                    InkWell(
                        onTap: () {
                          _userInfoController.updateUserData();
                        },
                        child: Text('Save'))
                  ]),
            ),
            //Basic Information
            SizedBox(
              height: 20,
            ),
            Text(
              'Basic Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Enter your name',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[500]),
            ),
            SizedBox(
              height: 5,
            ),

            TextField(
              controller: _userInfoController.nameController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Something about you',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[500]),
            ),
            SizedBox(
              height: 5,
            ),

            TextField(
              controller: _userInfoController.somethingController,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            //Date of Birth
            SizedBox(
              height: 10,
            ),
            Text(
              'Date of birth',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[500]),
            ),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                _selectDate(context, 1);
              },
              child: Container(
                padding: EdgeInsets.only(left: 5),
                height: mediaHeight * 0.06,
                width: mediaWidth / 3 + 20,
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  Obx(
                    () => Text(DateFormat.yMMMd()
                        .format(_userInfoController.startDate.value)),
                  ),
                  Icon(
                    Icons.calendar_month,
                    color: Color(0xffF4B755),
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Email',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[500]),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: mediaWidth,
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  _userInfoController.currentUserInfo.eamil,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> _selectDate(BuildContext context, int dateType) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        if (dateType == 1) {
          print('date $selectedDate');
          _userInfoController.changeStartDate(selectedDate);
        }
      });
    }
  }
}
