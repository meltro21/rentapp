import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentapp/controllers/home_screen_controller.dart';
import 'package:rentapp/controllers/my_adds_controller.dart';
import 'package:rentapp/controllers/search_post_controller.dart';
import 'package:rentapp/models/posts_model.dart';
import 'dart:math' as math;

import 'package:rentapp/views/home/add_detail_Home.dart';
import 'package:rentapp/views/searchPost/search_post.dart';

import '../../models/home_screen/featured_deals_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  MyAddsController myAddsController = Get.put(MyAddsController());

  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;
    var mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          //Column
          child: SingleChildScrollView(
            child: Column(children: [
              //search Container
              Container(
                padding: EdgeInsets.only(bottom: 10, top: 20),
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: TextField(
                    onTap: () {
                      Get.to(SearchPost());
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.only(
                        left: 30,
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 24.0, left: 16.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //Category : Construction and Agriculture
              SizedBox(
                height: 5,
              ),
              Container(
                height: mediaHeight * 0.8,
                child: SingleChildScrollView(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            homeScreenController.changeCategory(1);
                          },
                          child: Column(
                            children: [
                              Text(
                                'Construction',
                                style: TextStyle(),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Obx(
                                () => homeScreenController.category == 1
                                    ? Container(
                                        height: 2,
                                        width: mediaWidth / 4,
                                        color: Colors.purple[400],
                                      )
                                    : SizedBox(),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            homeScreenController.changeCategory(2);
                          },
                          child: Column(
                            children: [
                              Text('Agriculture'),
                              SizedBox(
                                height: 5,
                              ),
                              Obx(
                                () => homeScreenController.category == 2
                                    ? Container(
                                        height: 2,
                                        width: mediaWidth / 4,
                                        color: Colors.purple[400],
                                      )
                                    : SizedBox(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    //Subcategory: Construction
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: mediaWidth * 0.02),
                      height: mediaHeight * 0.22,
                      width: mediaWidth,
                      child: GridView(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: mediaWidth / 4 - 5,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        children: List.generate(8, (index) {
                          return Card(
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35)),
                              child: Column(children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  homeScreenController
                                      .constructionCategory[index].path,
                                  height: (mediaWidth / 4) / 2 - 10,
                                ),
                                Text(homeScreenController
                                    .constructionCategory[index].name),
                              ]),
                            ),
                          );
                        }),
                      ),
                    ),
                    //Featured Ads Container
                    Container(
                      height: mediaHeight * 0.04,
                      width: mediaWidth,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, top: 5),
                                child: Text(
                                  'Featured Deals',
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 5, top: 5),
                                child: Text(
                                  'view all',
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20, top: 5),
                                child: Transform.rotate(
                                  angle: 180 * math.pi / 180,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 12,
                                    color: Colors.pink,
                                  ),
                                ),
                              ),
                            ]),
                          ]),
                    ),
                    //list of adds rows
                    for (int i = 0; i < 2; i++)
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (int j = 0; j < 2; j++)
                              InkWell(
                                onTap: () {
                                  Get.to(AddDetailHome(
                                    postDetails: PostsModel.empty(),
                                  ));
                                },
                                child: Container(
                                  height: mediaHeight * 0.529 / 1.7 - 30,
                                  width: mediaWidth / 2 - 20,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        homeScreenController
                                            .featuredDeals[(j % 2 + i * 2)]
                                            .path,
                                        fit: BoxFit.fill,
                                        width: mediaWidth / 2 - 20,
                                        height: (mediaHeight * 0.529 / 2) / 1.5,
                                      ),
                                      SizedBox(
                                        height: mediaHeight * 0.3 * 0.01,
                                      ),
                                      Row(children: [
                                        Text('Baldozer'),
                                        Expanded(child: SizedBox()),
                                        Obx(
                                          () => homeScreenController
                                                      .featuredDeals[
                                                          (j % 2 + i * 2)]
                                                      .favorited ==
                                                  false
                                              ? InkWell(
                                                  onTap: () {
                                                    print('button pressed1');
                                                    int index = j % 2 + i * 2;
                                                    FeaturedDeals likedAdd =
                                                        homeScreenController
                                                                .featuredDeals[
                                                            index];

                                                    homeScreenController
                                                        .addToFavorites(index);
                                                    myAddsController
                                                        .addToFavourites(
                                                            likedAdd);
                                                  },
                                                  child: Icon(
                                                      Icons.favorite_border))
                                              : InkWell(
                                                  onTap: () {
                                                    int index = j % 2 + i * 2;
                                                    print(
                                                        'button pressed1 index is $index');

                                                    FeaturedDeals likedAdd =
                                                        homeScreenController
                                                                .featuredDeals[
                                                            index];
                                                    homeScreenController
                                                        .addToFavorites(index);
                                                    myAddsController
                                                        .removeFromFavouritesUsingHomeScreen(
                                                            likedAdd.id);
                                                  },
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                        ),
                                      ]),
                                      SizedBox(
                                        height: mediaHeight * 0.3 * 0.02,
                                      ),
                                      Text(
                                        'Rs ${homeScreenController.featuredDeals[(j % 2 + i * 2)].price}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: mediaHeight * 0.3 * 0.01,
                                      ),
                                      Row(children: [
                                        Text(
                                          'Faisal Town, Lahore',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Expanded(child: SizedBox()),
                                        Text(
                                          '18 May',
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                  ]),
                ),
              ),
            ]),
          )),
    );
  }
}
