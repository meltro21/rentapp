import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rentapp/controllers/add_post_controller.dart';
import 'package:rentapp/controllers/my_adds_controller.dart';
import 'package:rentapp/views/home/add_detail_Home.dart';

class MyAds extends StatefulWidget {
  const MyAds({Key? key}) : super(key: key);

  @override
  State<MyAds> createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  MyAddsController myAddsController = Get.put(MyAddsController());
  var _height1 = 2.0;
  var _width1 = 200.0;
  var _height2 = 0.0;
  var _width2 = 0.0;
  int index = 0;

  void changeLength1(double width) {
    setState(() {
      _height1 = 3;
      _width1 = width / 2;
      _height2 = 0.0;
      _width2 = 0.0;
    });
  }

  void changeLength2(double width) {
    setState(() {
      _height1 = 0;
      _width1 = 0;
      _height2 = 3;
      _width2 = width / 2;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('myads on dispose');
    MyAddsController addsController = Get.find();
    addsController.selectAdsOrFavourites.value = 1;
    Get.delete<MyAddsController>();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myAddsController.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;
    var mediaWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        height: mediaHeight,
        width: mediaWidth,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: mediaHeight * 0.06,
            width: mediaWidth,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      myAddsController.changeSelection(1);
                      changeLength1(mediaWidth);
                      index++;
                      myAddsController.getPosts();
                      print('index is $index');
                    },
                    child: Column(
                      children: [
                        Container(
                          width: mediaWidth / 2 - 5,
                          height: mediaHeight * 0.05,
                          child: Center(
                              child: Text(
                            'ADS',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.fastOutSlowIn,
                          height: _height1,
                          width: _width1,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      myAddsController.changeSelection(2);
                      changeLength2(mediaWidth);
                      myAddsController.getFavouritedPosts();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: mediaWidth / 2 - 5,
                          height: mediaHeight * 0.05,
                          child: Center(
                              child: Text('FAVOURITES',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.fastOutSlowIn,
                          height: _height2,
                          width: _width2,
                          color: Colors.black,
                        )
                      ],
                    ),
                  )
                ]),
          ),
          //list view
          Obx(() => myAddsController.selectAdsOrFavourites.value == 1
              ? Expanded(
                  child: Obx(
                    (() => ListView.builder(
                        itemCount: myAddsController.postsList.length,
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onTap: (() {
                              Get.to(AddDetailHome(
                                  postDetails:
                                      myAddsController.postsList[index]));
                            }),
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              height: mediaHeight * 0.14,
                              width: mediaWidth,
                              child: Row(
                                children: [
                                  Stack(children: [
                                    Container(
                                      height: mediaHeight * 0.14,
                                      width: mediaWidth * 0.35,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            myAddsController
                                                .postsList[index].imagesUrl[0],
                                          ),
                                        ),
                                      ),
                                      // child: Image(
                                      //   image: AssetImage(
                                      //     'assets/images/image1.jpeg',
                                      //   ),
                                      //   fit: BoxFit.fill,
                                      //   height: mediaHeight,
                                      //   width: mediaWidth * 0.3,
                                      // ),
                                    ),
                                    Positioned(
                                      child: Container(
                                        color: myAddsController
                                                .postsList[index].status=="approved"?  Colors.green:myAddsController
                                                .postsList[index].status=="rejected"?Colors.red:Colors.yellow,
                                        child: Text(myAddsController
                                                .postsList[index].status),
                                      ),
                                    ),
                                  ]),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(''),
                                        Row(children: [
                                          Text(myAddsController
                                              .postsList[index].subCategory
                                              .toUpperCase()),
                                          // Expanded(child: SizedBox()),
                                          // Icon(
                                          //   Icons.favorite,
                                          //   color: Colors.red,
                                          // ),
                                        ]),
                                        SizedBox(
                                          height: mediaHeight * 0.3 * 0.02,
                                        ),
                                        Text(
                                          'Rs ${myAddsController.postsList[index].price}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: mediaHeight * 0.3 * 0.01,
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: mediaWidth / 2,
                                            child: Text(
                                              '${myAddsController.postsList[index].address}',
                                              style: TextStyle(fontSize: 12),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Row(children: [
                                          Expanded(child: SizedBox()),
                                          Text(
                                            DateFormat('d MMM yyyy').format(
                                                myAddsController
                                                    .postsList[index]
                                                    .createdAt),
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ]),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }))),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                      itemCount: myAddsController.postsList.length,
                      itemBuilder: ((context, index) {
                        return Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          height: mediaHeight * 0.14,
                          width: mediaWidth,
                          child: Row(
                            children: [
                              Container(
                                height: mediaHeight * 0.14,
                                width: mediaWidth * 0.35,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      myAddsController
                                          .postsList[index].imagesUrl[0],
                                    ),
                                  ),
                                ),
                                // child: Image(
                                //   image: AssetImage(
                                //     'assets/images/image1.jpeg',
                                //   ),
                                //   fit: BoxFit.fill,
                                //   height: mediaHeight,
                                //   width: mediaWidth * 0.3,
                                // ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(''),
                                    Row(children: [
                                      Text(myAddsController
                                          .postsList[index].subCategory
                                          .toUpperCase()),
                                      Expanded(child: SizedBox()),
                                      InkWell(
                                        onTap: () {
                                          myAddsController
                                              .removeFromFavourites(index);
                                        },
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ]),
                                    SizedBox(
                                      height: mediaHeight * 0.3 * 0.02,
                                    ),
                                    Text(
                                      myAddsController.postsList[index].price
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: mediaHeight * 0.3 * 0.01,
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: mediaWidth / 2,
                                        child: Text(
                                          '${myAddsController.postsList[index].address}',
                                          style: TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Row(children: [
                                      Expanded(child: SizedBox()),
                                      Text(
                                        DateFormat('d MMM yyyy').format(
                                            myAddsController
                                                .postsList[index].createdAt),
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ]),
                                    // Row(children: [
                                    //   Text(
                                    //     '${myAddsController.postsList[index].address}',
                                    //     style: TextStyle(fontSize: 12),
                                    //   ),
                                    //   Expanded(child: SizedBox()),
                                    //   // Text(
                                    //   //   '18 May',
                                    //   //   style: TextStyle(fontSize: 12),
                                    //   // )
                                    // ]),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      })),
                ))
        ]),
      ),
    );
  }
}
