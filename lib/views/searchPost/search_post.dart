import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rentapp/controllers/search_post_controller.dart';

import '../home/add_detail_Home.dart';

class SearchPost extends StatefulWidget {
  String query;
  SearchPost({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchPost> createState() => _SearchPostState();
}

class _SearchPostState extends State<SearchPost> {
  SearchPostController searchPostController = Get.put(SearchPostController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchPostController.fromController.text = '0';
    searchPostController.toController.text = '10000';
    if (widget.query.isNotEmpty) {
      print('values is ${widget.query}');
      searchPostController.setPriceInitialValue();
      searchPostController.searchItem = widget.query;
      searchPostController.getPosts(widget.query);
      searchPostController.searchMode.value = SearchMode.afterSearch;
    }
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var mediaHeight = MediaQuery.of(context).size.height;
    mediaHeight -= statusBarHeight;
    statusBarHeight = MediaQuery.of(context).padding.bottom;
    mediaHeight -= statusBarHeight;

    var mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //by default search
          Obx(
            () => searchPostController.searchMode.value ==
                    SearchMode.beforeSearch
                ? Container(
                    margin: EdgeInsets.only(left: 20, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: () {
                              //addPostController.locationController.clear();
                              Get.back();
                            },
                            child: Icon(Icons.arrow_back_ios)),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.white,
                          width: mediaWidth * 0.9,
                          child: TextField(
                            autofocus: true,
                            style: TextStyle(color: Colors.black),
                            controller:
                                searchPostController.searchTextContoller,
                            decoration: InputDecoration(
                              //   filled: true,
                              // fillColor: Color(0xff111C42),

                              labelText: "Search",

                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.black)),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                searchPostController.setPriceInitialValue();
                                searchPostController.searchItem = value;
                                searchPostController.getPosts(value);
                                searchPostController.searchMode.value =
                                    SearchMode.afterSearch;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                :
                //after user searched
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    //addPostController.locationController.clear();
                                    Get.back();
                                  },
                                  child: Icon(Icons.arrow_back_ios)),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: (() {
                                  searchPostController.searchMode.value =
                                      SearchMode.beforeSearch;
                                }),
                                child: Container(
                                    color: Colors.white,
                                    width: mediaWidth * 0.8,
                                    height: mediaHeight * 0.05,
                                    child: Row(
                                      children: [
                                        Icon(Icons.search),
                                        Text('Search')
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          InkWell(
                            onTap: (() {
                              filter(mediaHeight, mediaWidth);
                            }),
                            child: Container(
                              width: 75,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black,
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.filter,
                                      color: Colors.white,
                                      size: mediaHeight * 0.02,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Filters',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ]),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Obx(() => searchPostController
                                      .searchFilterEnabled.value ==
                                  true
                              ? Flexible(
                                  child: Container(
                                    height: 23,
                                    width: mediaWidth * 0.3,
                                    color: Colors.teal,
                                    child: Row(children: [
                                      Text(
                                        '${searchPostController.fromController.text} - ${searchPostController.toController.text}',
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            searchPostController
                                                .fromController.text = '0';
                                            searchPostController
                                                .toController.text = '10000';
                                            searchPostController.getPosts(
                                                searchPostController
                                                    .searchItem);
                                            searchPostController
                                                .searchFilterEnabled
                                                .value = false;
                                          },
                                          child: Icon(Icons.close))
                                    ]),
                                  ),
                                )
                              : SizedBox()),
                        ]),
                        SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                            text: 'showing results for ',
                            children: <InlineSpan>[
                              TextSpan(
                                text: searchPostController.searchItem,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ])),
                      ],
                    ),
                  ),
          ),
          //listview builder
          Obx(() => searchPostController.searchMode.value ==
                  SearchMode.afterSearch
              ? Expanded(
                  child: ListView.builder(
                    itemCount: searchPostController.postsList.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: (() {
                          Get.to(AddDetailHome(
                              postDetails:
                                  searchPostController.postsList[index]));
                        }),
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                                        searchPostController
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
                                    color: Colors.yellow,
                                    child: Text('Pending'),
                                  ),
                                ),
                              ]),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(''),
                                    Row(children: [
                                      Text(searchPostController
                                          .postsList[index].model),
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
                                      'Rs ${searchPostController.postsList[index].price}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: mediaHeight * 0.3 * 0.01,
                                    ),
                                    Row(children: [
                                      Expanded(
                                        child: Container(
                                          // width: mediaWidth / 2,
                                          child: Text(
                                            '${searchPostController.postsList[index].address}',
                                            style: TextStyle(fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text(
                                        DateFormat('d MMM yyyy').format(
                                            searchPostController
                                                .postsList[index].createdAt),
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
                    }),
                  ),
                )
              : SizedBox())
        ],
      )),
    );
  }

  filter(double height, double width) {
    searchPostController.setPriceInitialValue();
    Get.bottomSheet(BottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onClosing: () {},
        builder: (context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              return Container(
                height: height * 0.3,
                margin: EdgeInsets.only(left: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            'Filters',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      //Price Filter
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('From'),
                                        TextField(
                                          keyboardType: TextInputType.number,
                                          controller: searchPostController
                                              .fromController,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: null),
                                        )
                                      ]),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('To'),
                                        TextField(
                                          keyboardType: TextInputType.number,
                                          onSubmitted: (value) {
                                            print('onsaved');
                                            if (value.isEmpty) {
                                              searchPostController
                                                  .toController.text = '10,000';
                                            }
                                          },
                                          controller:
                                              searchPostController.toController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                          ),
                                        )
                                      ]),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                searchPostController
                                    .getPosts(searchPostController.searchItem);
                                Get.back();
                              },
                              child: Center(
                                child: Container(
                                  height: height * 0.06,
                                  width: width / 2 - 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xffF4B755)),
                                  margin: EdgeInsets.only(
                                      top: height * 0.01, bottom: width * 0.01),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.filter_alt,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        Text(
                                          'Apply',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // TextField(
                      //   decoration: InputDecoration(
                      //     label: Text('Amount/day'),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Text(
                      //   'Start Date',
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     //_selectDate(context, 1);
                      //   },
                      //   child: Container(
                      //     margin: EdgeInsets.only(left: 30),
                      //     padding: EdgeInsets.only(left: 5),
                      //     height: height * 0.06,
                      //     width: width / 3 + 20,
                      //     decoration: BoxDecoration(
                      //         border: Border.all(),
                      //         borderRadius: BorderRadius.circular(10)),
                      //     child: Row(children: [
                      //       // Obx(
                      //       //   () => Text(DateFormat
                      //       //           .yMMMd()
                      //       //       .format(
                      //       //           addDetailController
                      //       //               .startDate
                      //       //               .value)),
                      //       // ),
                      //       Icon(
                      //         Icons.calendar_month,
                      //         color: Color(0xffF4B755),
                      //       ),
                      //     ]),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Text(
                      //   'End Date',
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     //_selectDate(context, 2);
                      //   },
                      //   child: Container(
                      //     margin: EdgeInsets.only(left: 30),
                      //     padding: EdgeInsets.only(left: 5),
                      //     height: height * 0.06,
                      //     width: width / 3 + 20,
                      //     decoration: BoxDecoration(
                      //       border: Border.all(),
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: Row(children: [
                      //       // Obx(
                      //       //   () => Text(DateFormat
                      //       //           .yMMMd()
                      //       //       .format(
                      //       //           addDetailController
                      //       //               .endDate
                      //       //               .value)),
                      //       // ),
                      //       Icon(
                      //         Icons.calendar_month,
                      //         color: Color(0xffF4B755),
                      //       ),
                      //     ]),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Center(
                      //   child: Container(
                      //     height: height * 0.06,
                      //     width: width / 2 - 20,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: Color(0xffF4B755)),
                      //     margin: EdgeInsets.only(
                      //         top: height * 0.01, bottom: width * 0.01),
                      //     child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Icon(
                      //             Icons.send,
                      //             color: Colors.white,
                      //           ),
                      //           SizedBox(
                      //             width: width * 0.02,
                      //           ),
                      //           Text(
                      //             'Submit Request',
                      //             style: TextStyle(color: Colors.white),
                      //           ),
                      //         ]),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            }),
          );
        }));
  }
}
