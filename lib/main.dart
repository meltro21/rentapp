import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rentapp/views/addPost/addPost.dart';
import 'package:rentapp/views/authentication/login.dart';
import 'package:rentapp/views/authentication/register.dart';
import 'package:rentapp/views/home/add_detail_Home.dart';
import 'package:rentapp/views/home/home_screen.dart';
import 'package:rentapp/views/home/showroom.dart';
import 'package:rentapp/views/myAds/my_ads.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'hy',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Widget> widgetOptions = [
    HomeScreen(),
    MyAds(),
    AddPost(),
  ];

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
          const BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              backgroundColor: Colors.purple,
              label: 'CHAT'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              backgroundColor: Colors.pink,
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
