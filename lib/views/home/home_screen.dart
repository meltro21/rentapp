import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rentapp/controllers/home_screen_controller.dart';
import 'package:rentapp/controllers/my_adds_controller.dart';
import 'package:rentapp/controllers/search_post_controller.dart';
import 'package:rentapp/controllers/user_info_controller.dart';
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
  UserInfoController userInfoController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeScreenController.getPosts();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // print('in the disposne of homescreen');
    // homeScreenController.clearData();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;
    var mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          //Column
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(children: [
              //search Container
              Container(
                padding: EdgeInsets.only(bottom: 10, top: 20),
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: TextField(
                    onTap: () {
                      Get.to(SearchPost(
                        query: '',
                      ));
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
                    child: Column(
                  children: [
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
                    Obx(
                      () => homeScreenController.category == 1
                          ? Container(
                              margin: EdgeInsets.only(left: mediaWidth * 0.02),
                              height: mediaHeight * 0.22,
                              width: mediaWidth,
                              child: GridView(
                                scrollDirection: Axis.horizontal,
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: mediaWidth / 4 - 5,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                ),
                                children: List.generate(8, (index) {
                                  return InkWell(
                                    onTap: (() {
                                      Get.to(SearchPost(
                                          query: homeScreenController
                                              .constructionCategory[index].name
                                              .toLowerCase()));
                                    }),
                                    child: Card(
                                      elevation: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35)),
                                        child: Column(children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Image.asset(
                                            homeScreenController
                                                .constructionCategory[index]
                                                .path,
                                            height: (mediaWidth / 4) / 2 - 10,
                                          ),
                                          Text(homeScreenController
                                              .constructionCategory[index]
                                              .name),
                                        ]),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            )
                          : SizedBox(),
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
                              // Container(
                              //   margin: EdgeInsets.only(right: 5, top: 5),
                              //   child: Text(
                              //     'view all',
                              //     style: TextStyle(
                              //       color: Colors.purple,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),
                              // Container(
                              //   margin: EdgeInsets.only(right: 20, top: 5),
                              //   child: Transform.rotate(
                              //     angle: 180 * math.pi / 180,
                              //     child: Icon(
                              //       Icons.arrow_back_ios,
                              //       size: 12,
                              //       color: Colors.pink,
                              //     ),
                              //   ),
                              // ),
                            ]),
                          ]),
                    ),
                    //list of adds rows
                    Obx(
                      () => homeScreenController.loading.value == false
                          ? GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: homeScreenController.postsList.length,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1 / 1.2,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: ((context, index) {
                                print(
                                    'status is ${homeScreenController.postsList[index].status}');
                                return Opacity(
                                  opacity: homeScreenController
                                              .postsList[(index)].status ==
                                          'rented'
                                      ? 0.5
                                      : 1,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // for (int j = 0; j < 2; j++)
                                        InkWell(
                                          onTap: () {
                                            userInfoController
                                                .getPostUserAllData(
                                                    homeScreenController
                                                        .postsList[index]
                                                        .userId);
                                            Get.to(AddDetailHome(
                                              postDetails: homeScreenController
                                                  .postsList[(index)],
                                            ));
                                          },
                                          child: Container(
                                            height:
                                                mediaHeight * 0.529 / 1.6 - 30,
                                            width: mediaWidth / 2 - 20,
                                            padding: EdgeInsets.only(left: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.network(
                                                  homeScreenController
                                                      .postsList[(index)]
                                                      .imagesUrl[0],
                                                  fit: BoxFit.fill,
                                                  width: mediaWidth / 2 - 20,
                                                  height: (mediaHeight *
                                                          0.529 /
                                                          2) /
                                                      1.5,
                                                ),
                                                SizedBox(
                                                  height:
                                                      mediaHeight * 0.3 * 0.01,
                                                ),
                                                Row(children: [
                                                  Text(homeScreenController
                                                      .postsList[(index)]
                                                      .subCategory
                                                      .toUpperCase()),
                                                  Expanded(child: SizedBox()),
                                                  Obx(
                                                    () => homeScreenController
                                                                    .favorites[
                                                                index] ==
                                                            false
                                                        ? InkWell(
                                                            onTap: () {
                                                              // print(
                                                              //     'button pressed1');
                                                              // int index =

                                                              // FeaturedDeals
                                                              //     likedAdd =
                                                              //     homeScreenController
                                                              //             .featuredDeals[
                                                              //         index];

                                                              // homeScreenController
                                                              //     .addToFavorites(
                                                              //         index);
                                                              // myAddsController
                                                              //     .addToFavourites(
                                                              //         likedAdd);

                                                              homeScreenController
                                                                  .addTo(index);
                                                            },
                                                            child: Icon(Icons
                                                                .favorite_border))
                                                        : InkWell(
                                                            onTap: () {
                                                              // int index =
                                                              //     j % 2 + i * 2;
                                                              // print(
                                                              //     'button pressed1 index is $index');

                                                              // FeaturedDeals
                                                              //     likedAdd =
                                                              //     homeScreenController
                                                              //             .featuredDeals[
                                                              //         index];
                                                              // homeScreenController
                                                              //     .addToFavorites(
                                                              //         index);
                                                              // myAddsController
                                                              //     .removeFromFavouritesUsingHomeScreen(
                                                              //         likedAdd
                                                              //             .id);
                                                              homeScreenController
                                                                  .removeTo(
                                                                      index);
                                                            },
                                                            child: Icon(
                                                              Icons.favorite,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                  ),
                                                ]),
                                                SizedBox(
                                                  height:
                                                      mediaHeight * 0.3 * 0.02,
                                                ),
                                                Text(
                                                  'Rs ${homeScreenController.postsList[(index)].price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height:
                                                      mediaHeight * 0.3 * 0.01,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '📍${homeScreenController.postsList[index].address}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                                // homeScreenController
                                                //             .postsList[(index)]
                                                //             .status ==
                                                //         'rented'
                                                //     ? Text(
                                                //         'Duration',
                                                //         style: TextStyle(
                                                //             fontWeight:
                                                //                 FontWeight.bold,
                                                //             color: Colors.grey),
                                                //       )
                                                //     : SizedBox(),
                                                // homeScreenController
                                                //             .postsList[(index)]
                                                //             .status ==
                                                //         'rented'
                                                //     ? Row(children: [
                                                //         Text(
                                                //           DateFormat(
                                                //                   'd MMM yyyy')
                                                //               .format(DateTime.parse(
                                                //                   homeScreenController
                                                //                       .postsList[
                                                //                           index]
                                                //                       .startDate)),
                                                //           style: TextStyle(
                                                //               fontSize: 12,
                                                //               color:
                                                //                   Colors.grey),
                                                //         ),
                                                //         SizedBox(
                                                //           width: 10,
                                                //         ),
                                                //         Text(
                                                //           DateFormat(
                                                //                   'd MMM yyyy')
                                                //               .format(DateTime.parse(
                                                //                   homeScreenController
                                                //                       .postsList[
                                                //                           index]
                                                //                       .endDate)),
                                                //           style: TextStyle(
                                                //               fontSize: 12,
                                                //               color:
                                                //                   Colors.grey),
                                                //         ),
                                                //       ])
                                                //     : SizedBox(),
                                                // Row(children: [

                                                //   Text(
                                                //     '18 May',
                                                //     style:
                                                //         TextStyle(fontSize: 12),
                                                //   )
                                                // ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }))
                          : SizedBox(),
                    )

                    // for (int i = 0; i < 2; i++)
                    //   Obx(
                    //     () => homeScreenController.loading.value == false
                    //         ? Container(
                    //             margin: EdgeInsets.only(top: 5),
                    //             child: Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceEvenly,
                    //               children: [
                    //                 for (int j = 0; j < 2; j++)
                    //                   InkWell(
                    //                     onTap: () {
                    //                       Get.to(AddDetailHome(
                    //                         postDetails: homeScreenController
                    //                             .postsList[(j % 2 + i * 2)],
                    //                       ));
                    //                     },
                    //                     child: Container(
                    //                       height:
                    //                           mediaHeight * 0.529 / 1.7 - 30,
                    //                       width: mediaWidth / 2 - 20,
                    //                       padding: EdgeInsets.only(left: 10),
                    //                       decoration: BoxDecoration(
                    //                         color: Colors.grey[200],
                    //                         borderRadius:
                    //                             BorderRadius.circular(10),
                    //                       ),
                    //                       child: Column(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.start,
                    //                         children: [
                    //                           Image.network(
                    //                             homeScreenController
                    //                                 .postsList[(j % 2 + i * 2)]
                    //                                 .imagesUrl[0],
                    //                             fit: BoxFit.fill,
                    //                             width: mediaWidth / 2 - 20,
                    //                             height:
                    //                                 (mediaHeight * 0.529 / 2) /
                    //                                     1.5,
                    //                           ),
                    //                           SizedBox(
                    //                             height:
                    //                                 mediaHeight * 0.3 * 0.01,
                    //                           ),
                    //                           Row(children: [
                    //                             Text(homeScreenController
                    //                                 .postsList[(j % 2 + i * 2)]
                    //                                 .subCategory
                    //                                 .toUpperCase()),
                    //                             Expanded(child: SizedBox()),
                    //                             Obx(
                    //                               () => homeScreenController
                    //                                           .featuredDeals[
                    //                                               (j % 2 +
                    //                                                   i * 2)]
                    //                                           .favorited ==
                    //                                       false
                    //                                   ? InkWell(
                    //                                       onTap: () {
                    //                                         print(
                    //                                             'button pressed1');
                    //                                         int index =
                    //                                             j % 2 + i * 2;
                    //                                         FeaturedDeals
                    //                                             likedAdd =
                    //                                             homeScreenController
                    //                                                     .featuredDeals[
                    //                                                 index];

                    //                                         homeScreenController
                    //                                             .addToFavorites(
                    //                                                 index);
                    //                                         myAddsController
                    //                                             .addToFavourites(
                    //                                                 likedAdd);
                    //                                         homeScreenController
                    //                                             .addTo(index);
                    //                                       },
                    //                                       child: Icon(Icons
                    //                                           .favorite_border))
                    //                                   : InkWell(
                    //                                       onTap: () {
                    //                                         int index =
                    //                                             j % 2 + i * 2;
                    //                                         print(
                    //                                             'button pressed1 index is $index');

                    //                                         FeaturedDeals
                    //                                             likedAdd =
                    //                                             homeScreenController
                    //                                                     .featuredDeals[
                    //                                                 index];
                    //                                         homeScreenController
                    //                                             .addToFavorites(
                    //                                                 index);
                    //                                         myAddsController
                    //                                             .removeFromFavouritesUsingHomeScreen(
                    //                                                 likedAdd
                    //                                                     .id);
                    //                                         homeScreenController
                    //                                             .removeTo(
                    //                                                 index);
                    //                                       },
                    //                                       child: Icon(
                    //                                         Icons.favorite,
                    //                                         color: Colors.red,
                    //                                       ),
                    //                                     ),
                    //                             ),
                    //                           ]),
                    //                           SizedBox(
                    //                             height:
                    //                                 mediaHeight * 0.3 * 0.02,
                    //                           ),
                    //                           Text(
                    //                             'Rs ${homeScreenController.postsList[(j % 2 + i * 2)].price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    //                             style: TextStyle(
                    //                                 fontWeight:
                    //                                     FontWeight.bold),
                    //                           ),
                    //                           SizedBox(
                    //                             height:
                    //                                 mediaHeight * 0.3 * 0.01,
                    //                           ),
                    //                           Expanded(
                    //                             child: Text(
                    //                               '📍${homeScreenController.postsList[(j % 2 + i * 2)].address}',
                    //                               overflow:
                    //                                   TextOverflow.ellipsis,
                    //                               style:
                    //                                   TextStyle(fontSize: 12),
                    //                             ),
                    //                           ),
                    //                           // Row(children: [

                    //                           //   Text(
                    //                           //     '18 May',
                    //                           //     style:
                    //                           //         TextStyle(fontSize: 12),
                    //                           //   )
                    //                           // ]),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //               ],
                    //             ),
                    //           )
                    //         : SizedBox(),
                    //  )
                  ],
                )),
              )
            ]),
          )),
    );
  }
}
