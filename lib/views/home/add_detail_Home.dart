import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rentapp/controllers/add_detail_controller.dart';
import 'package:rentapp/controllers/user_info_controller.dart';
import 'package:rentapp/models/posts_model.dart';
import 'package:rentapp/models/user_model.dart';
import 'package:rentapp/views/chat/chat_detail.dart';
import 'package:rentapp/views/home/maps.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AddDetailHome extends StatefulWidget {
  PostsModel postDetails;
  AddDetailHome({Key? key, required this.postDetails}) : super(key: key);

  @override
  State<AddDetailHome> createState() => _AddDetailHomeState();
}

class _AddDetailHomeState extends State<AddDetailHome> {
  AddDetailController addDetailController = Get.put(AddDetailController());
  UserInfoController userInfoController = Get.find();
  int currentPic = 1;

  late ScrollController _controller;
  _moveUp(var mediaWidth, int index) {
    print('index is $index');
    setState(() {
      currentPic = index + 1;
    });
    _controller.animateTo(_controller.offset - mediaWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 200));
  }

  _moveDown(var mediaWidth, int index) {
    print('index is $index');
    setState(() {
      currentPic = index + 1;
    });
    _controller.animateTo(_controller.offset + mediaWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 200));
  }

  DateTime selectedDate = DateTime.now();
  String startDate = '';

  Future<void> _selectDate(BuildContext context, int dateType) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        if (dateType == 1) {
          addDetailController.changeStartDate(selectedDate);
        } else {
          addDetailController.changeEndDate(selectedDate);
        }
        print(addDetailController.startDate);
        // startDate = selectedDate.toString();
        // print('start date is $startDate');
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    userInfoController.getPostUserAllData(widget.postDetails.userId);
    _controller = ScrollController();
    addDetailController.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;
    var mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        //main stack to make the top back button visible
        child: Stack(children: [
          Container(
            height: mediaHeight,
            width: mediaWidth,
            //main Column
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(bottom: mediaHeight * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //top images list
                    Container(
                      // margin: EdgeInsets.only(bottom: 200),
                      height: mediaHeight * 0.3,
                      child: Stack(children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _controller,
                          itemCount: widget.postDetails.imagesUrl.length,
                          itemExtent: mediaWidth,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onPanUpdate: (details) {
                                if (details.delta.direction > 0) {
                                  print('swipe left');
                                  _moveUp(mediaWidth, index);
                                }

                                // Swiping in left direction.
                                if (details.delta.direction < 0) {
                                  print('swipe right');
                                  _moveDown(mediaWidth, index);
                                }
                              },
                              child: Container(
                                height: mediaHeight * 0.14,
                                width: mediaWidth * 0.35,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      widget.postDetails.imagesUrl[index],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Container(
                            height: 20,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color.fromARGB(255, 3, 90, 6),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$currentPic/',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    '${widget.postDetails.imagesUrl.length}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ]),
                          ),
                        ),
                      ]),
                    ),
                    //Price
                    SizedBox(
                      height: mediaHeight * 0.02,
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Rs ${widget.postDetails.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    //Subcategory
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        '${widget.postDetails.subCategory.toUpperCase()}',
                        style: TextStyle(),
                      ),
                    ),
                    SizedBox(
                      height: mediaHeight * 0.01,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on),
                          Expanded(
                              child: Text(
                            '${widget.postDetails.address}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(fontSize: 10),
                          )),
                          Expanded(
                            child: SizedBox(),
                          ),
                          Text(DateFormat('d MMM yyyy')
                              .format(widget.postDetails.createdAt)),
                        ],
                      ),
                    ),
                    //Description

                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Obx(
                      () => addDetailController.readMore.value == false
                          ? Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "${widget.postDetails.description}",
                                maxLines: 4,
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                "${widget.postDetails.description}",
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        addDetailController.changeReadMoreValue();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Obx(
                              () => addDetailController.readMore.value == false
                                  ? Text(
                                      'READ MORE',
                                    )
                                  : Text('READ LESS')),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Ad Posted at',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(MapsSample(
                          lat: widget.postDetails.lat,
                          lng: widget.postDetails.lng,
                          address: widget.postDetails.address,
                        ));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        height: mediaHeight * 0.2,
                        width: mediaWidth,
                        child: Stack(
                          children: [
                            Image(
                              image: AssetImage('assets/images/add_posted.png'),
                              fit: BoxFit.fill,
                            ),
                            Positioned(
                                bottom: 20,
                                child: Center(
                                  child: Container(
                                    color: Colors.white,
                                    child: Text(
                                      'Tap to View',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //add poster details
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Add Poster Info',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder(
                        future: addDetailController
                            .getPosterInfo(widget.postDetails.userId),
                        builder: ((context, AsyncSnapshot<UserModel> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            // If we got an error
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  '${snapshot.error} occurred',
                                  style: TextStyle(fontSize: 12),
                                ),
                              );

                              // if we got our data
                            } else if (snapshot.hasData) {
                              // Extracting data from snapshot object
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(children: [
                                  Divider(),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: AssetImage(
                                            "assets/images/person1.jpeg"),
                                        maxRadius: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '${snapshot.data!.name}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.orange[400],
                                      ),
                                      Text(
                                        addDetailController.avgRating
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.orange[400],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: mediaHeight * 0.01,
                                  ),
                                  Column(
                                    children: [
                                      for (int i = 0;
                                          i <
                                              addDetailController
                                                  .feedbackList.length;
                                          i++)
                                        Column(children: [
                                          Row(children: [
                                            Text(
                                              addDetailController
                                                  .feedbackList[i].name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: Colors.orange[400],
                                            ),
                                            Text(
                                              addDetailController
                                                  .feedbackList[i].rating
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ]),
                                          Text(addDetailController
                                              .feedbackList[i].feedback),
                                          Divider(),
                                        ]),
                                    ],
                                  )
                                  // ListView.builder(
                                  //     itemBuilder: ((context, index) {
                                  //   return Row(
                                  //     children: [
                                  //       Text(addDetailController
                                  //           .feedbackList[index].feedback),
                                  //       Text(addDetailController
                                  //           .feedbackList[index].rating
                                  //           .toString()),
                                  //     ],
                                  //   );
                                  // })),
                                ]),
                              );
                            }
                          }
                          return CircularProgressIndicator();
                        }))
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: mediaHeight * 0.05,
            width: mediaWidth,
            foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 1],
              colors: [
                Color.fromRGBO(0, 0, 0, 0.6),
                Color.fromRGBO(255, 255, 255, 0.2),
              ],
            )),
            child: Row(
              children: [],
            ),
          ),
          //Back button
          Positioned(
              top: 10,
              left: 10,
              child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios, color: Colors.white))),

          //bottom chat button
          Positioned(
            bottom: mediaHeight * 0.0,
            child: Container(
              width: mediaWidth,
              height: mediaHeight * 0.08,
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Chat
                    InkWell(
                      onTap: () {
                        Get.to(ChatDetail(
                          toId: widget.postDetails.userId,
                        ));
                      },
                      child: Container(
                        height: mediaHeight * 0.06,
                        width: mediaWidth / 2 - 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffF4B755)),
                        margin: EdgeInsets.only(
                            top: mediaHeight * 0.01,
                            bottom: mediaHeight * 0.01),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: mediaWidth * 0.02,
                              ),
                              Text(
                                'Chat',
                                style: TextStyle(color: Colors.white),
                              )
                            ]),
                      ),
                    ),
                  ]),
            ),
          )
        ]),
      ),
    );
  }
}
