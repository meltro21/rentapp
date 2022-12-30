import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rentapp/controllers/user_info_controller.dart';

class SellOrders extends StatefulWidget {
  const SellOrders({Key? key}) : super(key: key);

  @override
  State<SellOrders> createState() => _SellOrdersState();
}

class _SellOrdersState extends State<SellOrders> {
  UserInfoController userInfoController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    userInfoController.getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;
    var mediaWidth = MediaQuery.of(context).size.width;
    return Obx(
      () => LoadingOverlay(
        isLoading: userInfoController.loading.value,
        child: Scaffold(
          body: Container(
            height: mediaHeight,
            width: mediaWidth,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Flexible(
                child: Obx(
                  (() => ListView.builder(
                      shrinkWrap: true,
                      itemCount: userInfoController.postsList.length,
                      itemBuilder: ((context, index) {
                        var now = DateTime.now();
                        var endDate = DateTime.parse(
                            userInfoController.postsList[index].endDate);
                        var flag = true;
                        flag = now.isAfter(endDate);
                        print('flag is $flag');
                        // userInfoController.postsList[index].endDate
                        return GestureDetector(
                          onTap: (() {
                            if (flag) {
                              showBookingOption(mediaHeight, mediaWidth, index);
                            }
                          }),
                          child: Container(
                            //color: Colors.orange,
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            height: flag == true
                                ? mediaHeight * 0.24
                                : mediaHeight * 0.14,
                            width: mediaWidth,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  flag == true
                                      ? Column(children: [
                                          Row(children: [
                                            Image.asset(
                                              'assets/images/check.png',
                                              height: 40,
                                              width: 40,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Congratulations, Order is completed',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 18),
                                            )
                                          ]),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Click, and fill the feedback, so that this add is available again for rent.',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ])
                                      : SizedBox(),
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Stack(children: [
                                          Container(
                                            height: mediaHeight * 0.14,
                                            width: mediaWidth * 0.35,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  userInfoController
                                                      .postsList[index]
                                                      .imagesUrl[0],
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
                                              color: userInfoController
                                                          .postsList[index]
                                                          .status ==
                                                      "approved"
                                                  ? Colors.green
                                                  : userInfoController
                                                              .postsList[index]
                                                              .status ==
                                                          "rejected"
                                                      ? Colors.red
                                                      : userInfoController
                                                                  .postsList[
                                                                      index]
                                                                  .status ==
                                                              "rented"
                                                          ? Colors.orange
                                                          : Colors.yellow,
                                              child: Text(userInfoController
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
                                                Text(userInfoController
                                                    .postsList[index]
                                                    .subCategory
                                                    .toUpperCase()),
                                                // Expanded(child: SizedBox()),
                                                // Icon(
                                                //   Icons.favorite,
                                                //   color: Colors.red,
                                                // ),
                                              ]),
                                              SizedBox(
                                                height:
                                                    mediaHeight * 0.3 * 0.02,
                                              ),
                                              Text(
                                                'Rs ${userInfoController.postsList[index].price}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height:
                                                    mediaHeight * 0.3 * 0.01,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  width: mediaWidth / 2,
                                                  child: Text(
                                                    '${userInfoController.postsList[index].address}',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Duration',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                              ),
                                              Row(children: [
                                                Text(
                                                  DateFormat('d MMM yyyy')
                                                      .format(DateTime.parse(
                                                          userInfoController
                                                              .postsList[index]
                                                              .startDate)),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  DateFormat('d MMM yyyy')
                                                      .format(DateTime.parse(
                                                          userInfoController
                                                              .postsList[index]
                                                              .endDate)),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                              ]),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        );
                      }))),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  showBookingOption(mediaHeight, mediaWidth, int index) {
    Get.bottomSheet(BottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onClosing: () {},
        builder: (context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              return Container(
                height: mediaHeight * 0.5,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ExpansionTileCard(
                  title: Text('Feedback'),
                  subtitle: Text(
                      'Please provide feedback so that your vehicel is available again for Rent!'),
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text('Rate your experience',
                            style: TextStyle(color: Colors.grey))),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () {
                                userInfoController.setRating(1);
                              },
                              child: userInfoController.rating.value >= 1
                                  ? Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    )
                                  : Icon(Icons.star_outline)),
                          InkWell(
                              onTap: () {
                                userInfoController.setRating(2);
                              },
                              child: userInfoController.rating.value >= 2
                                  ? Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    )
                                  : Icon(Icons.star_outline)),
                          InkWell(
                              onTap: () {
                                userInfoController.setRating(3);
                              },
                              child: userInfoController.rating.value >= 3
                                  ? Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    )
                                  : Icon(Icons.star_outline)),
                          InkWell(
                              onTap: () {
                                userInfoController.setRating(4);
                              },
                              child: userInfoController.rating.value >= 4
                                  ? Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    )
                                  : Icon(Icons.star_outline)),
                          InkWell(
                              onTap: () {
                                userInfoController.setRating(5);
                              },
                              child: userInfoController.rating.value >= 5
                                  ? Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    )
                                  : Icon(Icons.star_outline)),
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Describe your experience',
                          style: TextStyle(color: Colors.grey),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: userInfoController.descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter description';
                        }
                        return null;
                      },
                      //controller: addPostController.descriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Description'),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Get.back();
                          userInfoController.submitFeedback(index);
                        },
                        child: Text('Submit')),
                  ],
                ),
              );
            }),
          );
        }));
  }
}
