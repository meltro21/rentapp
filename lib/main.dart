import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rentapp/controllers/user_info_controller.dart';
import 'package:rentapp/views/addPost/addPost.dart';
import 'package:rentapp/views/authentication/login.dart';
import 'package:rentapp/views/authentication/register.dart';
import 'package:rentapp/views/chat/chat_home.dart';
import 'package:rentapp/views/home/add_detail_Home.dart';
import 'package:rentapp/views/home/home_screen.dart';
import 'package:rentapp/views/myAds/my_ads.dart';
import 'package:rentapp/views/profile/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  UserInfoController userInfoController = Get.put(UserInfoController());
  List<Widget> widgetOptions = [
    HomeScreen(),
    MyAds(),
    AddPost(),
    ChatHome(),
    Profile()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfoController.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            backgroundColor: Colors.grey[300],
            label: 'HOME',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              backgroundColor: Colors.grey[300],
              label: 'MY ADS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              backgroundColor: Colors.grey[300],
              label: 'SELL'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              backgroundColor: Colors.grey[300],
              label: 'CHAT'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              backgroundColor: Colors.grey[300],
              label: 'ACCOUNT'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[300],
        onTap: (index) {
          print('index is $index');
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
