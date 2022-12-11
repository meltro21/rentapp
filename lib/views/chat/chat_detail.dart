import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rentapp/controllers/chat_controller.dart';
import 'package:rentapp/controllers/user_info_controller.dart';
import 'package:rentapp/models/posts_model.dart';

class ChatDetail extends StatefulWidget {
  // PostsModel postDetails;

  String toId;
  ChatDetail({Key? key, required this.toId}) : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  DateTime selectedDate = DateTime.now();
  String startDate = '';

  ChatController chatController = Get.put(ChatController());
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  UserInfoController userInfoController = Get.find();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfoController.getPostUserAllData(widget.toId);
    //chatController.postDetails = widget.postDetails;
  }

  // void _scrollDown() {
  //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  // }
  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;
    var mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/person1.jpeg"),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        userInfoController.postUserInfo.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            StreamBuilder(
                stream: chatController.getMessages(widget.toId),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 60),
                      child: ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return snapshot.data!.docs[index]['type'] == "M"
                                ? chatController.userId ==
                                        snapshot.data!.docs[index]['from']
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            right: 5, bottom: 5),
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.indigo.shade800,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    snapshot.data!.docs[index]
                                                        ['message'],
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                      '${DateFormat.jm().format(snapshot.data!.docs[index]['createdAt'].toDate())}',
                                                      textScaleFactor: 0.7,
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontFeatures: [
                                                          FontFeature.enable(
                                                              'subs'),
                                                        ],
                                                      )),
                                                )
                                              ]),
                                        ),
                                      )
                                    : Container(
                                        margin:
                                            EdgeInsets.only(left: 5, bottom: 5),
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.lightBlue,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['message'],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    '${DateFormat.jm().format(snapshot.data!.docs[index]['createdAt'].toDate())}',
                                                    textScaleFactor: 0.7,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontFeatures: [
                                                        FontFeature.enable(
                                                            'subs'),
                                                      ],
                                                    ))
                                              ]),
                                        ),
                                      )
                                :
                                //if message type is request show this
                                snapshot.data!.docs[index]['status'] == 'P'
                                    ? Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        height: mediaHeight * 0.2,
                                        //color: Colors.red,
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          padding:
                                              EdgeInsets.only(top: 5, left: 10),
                                          width: mediaWidth * 0.6,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Rent Request',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Start Date : ${DateFormat('d MMM yyyy').format(DateTime.parse(snapshot.data!.docs[index]['startDate']))}',
                                                  style: TextStyle(),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    'End Date   : ${DateFormat('d MMM yyyy').format(DateTime.parse(snapshot.data!.docs[index]['startDate']))}'),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    'Amount     : ${snapshot.data!.docs[index]['amount']}'),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                chatController.userId !=
                                                        snapshot.data!
                                                            .docs[index]['from']
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary:
                                                                          Colors
                                                                              .green),
                                                              onPressed: () {
                                                                chatController.accepted(snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      ['from'],
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'fromMessageId'],
                                                                  snapshot.data!
                                                                          .docs[
                                                                      index]['to'],
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'toMessageId'],);
                                                              },
                                                              child: Text(
                                                                  'Accept')),
                                                          ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary: Colors
                                                                              .red[
                                                                          400]),
                                                              onPressed: () {
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .id;
                                                                chatController
                                                                    .rejected(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      ['from'],
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'fromMessageId'],
                                                                  snapshot.data!
                                                                          .docs[
                                                                      index]['to'],
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'toMessageId'],
                                                                );
                                                              },
                                                              child: Text(
                                                                  'Reject')),
                                                        ],
                                                      )
                                                    : SizedBox(),
                                                //withdraw request
                                                chatController.userId ==
                                                        snapshot.data!
                                                            .docs[index]['from']
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          ElevatedButton(
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      primary:
                                                                          Colors
                                                                              .green),
                                                              onPressed: () {
                                                                chatController
                                                                    .withDrawRequest(
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      ['from'],
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'fromMessageId'],
                                                                  snapshot.data!
                                                                          .docs[
                                                                      index]['to'],
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'toMessageId'],
                                                                );
                                                              },
                                                              child: Text(
                                                                  'Withdraw Request')),
                                                        ],
                                                      )
                                                    : SizedBox()
                                              ]),
                                        ),
                                      )
                                    : snapshot.data!.docs[index]['status'] ==
                                            'R'
                                        ? IgnorePointer(
                                            ignoring: snapshot.data!.docs[index]
                                                        ['status'] ==
                                                    'R'
                                                ? true
                                                : false,
                                            child: Opacity(
                                              opacity:
                                                  snapshot.data!.docs[index]
                                                              ['status'] ==
                                                          'R'
                                                      ? 0.5
                                                      : 1,
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 5),
                                                height: mediaHeight * 0.2,
                                                //color: Colors.red,
                                                alignment: Alignment.center,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  padding: EdgeInsets.only(
                                                      top: 5, left: 10),
                                                  width: mediaWidth * 0.6,
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Rent Request',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          'Start Date : ${DateFormat('d MMM yyyy').format(DateTime.parse(snapshot.data!.docs[index]['startDate']))}',
                                                          style: TextStyle(),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                            'End Date   : ${DateFormat('d MMM yyyy').format(DateTime.parse(snapshot.data!.docs[index]['startDate']))}'),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                            'Amount     : ${snapshot.data!.docs[index]['amount']}'),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        chatController.userId ==
                                                                snapshot.data!
                                                                        .docs[
                                                                    index]['from']
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          primary: Colors
                                                                              .green),
                                                                      onPressed:
                                                                          () {},
                                                                      child: Text(
                                                                          'Accept')),
                                                                  ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          primary: Colors.red[
                                                                              400]),
                                                                      onPressed:
                                                                          () {
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .id;
                                                                        chatController
                                                                            .rejected(
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]['from'],
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]['fromMessageId'],
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]['to'],
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]['toMessageId'],
                                                                        );
                                                                      },
                                                                      child: Text(
                                                                          'Reject')),
                                                                ],
                                                              )
                                                            : SizedBox(),
                                                        //withdraw request
                                                        chatController.userId !=
                                                                snapshot.data!
                                                                        .docs[
                                                                    index]['from']
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          primary: Colors
                                                                              .green),
                                                                      onPressed:
                                                                          () {
                                                                        chatController
                                                                            .withDrawRequest(
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]['from'],
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]['fromMessageId'],
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]['to'],
                                                                          snapshot
                                                                              .data!
                                                                              .docs[index]['toMessageId'],
                                                                        );
                                                                      },
                                                                      child: Text(
                                                                          'Withdraw Request')),
                                                                ],
                                                              )
                                                            : SizedBox()
                                                      ]),
                                                ),
                                              ),
                                            ),
                                          )
                                        :
                                        //if it is withdrawn
                                        Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            //color: Colors.red,
                                            width: 50,
                                            child: Center(
                                              child: Container(
                                                  height: 50,
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: Colors.grey[300]),
                                                  child: Center(
                                                    child: Text(
                                                      'Request Withdrawn',
                                                      style: GoogleFonts.ubuntu(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey),
                                                    ),
                                                  )),
                                            ),
                                          );
                          }),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        showBookingOption(mediaHeight, mediaWidth);
                        print('Hello');
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        onTap: () {
                          // print('Hello');
                          // _scrollDown();
                        },
                        controller: chatController.messageController,
                        scrollPadding: EdgeInsets.only(bottom: 50),
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        chatController.sendMessage(widget.toId);
                        //await chatController.getLatestMessagess();
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ].reversed.toList(),
        ),
      ),
    );
  }

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
          chatController.changeStartDate(selectedDate);
        } else {
          chatController.changeEndDate(selectedDate);
        }
        print(chatController.startDate);
        // startDate = selectedDate.toString();
        // print('start date is $startDate');
      });
    }
  }

  showBookingOption(mediaHeight, mediaWidth) {
    Get.bottomSheet(BottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onClosing: () {},
        builder: (context) {
          return StatefulBuilder(
            builder: ((context, setState) {
              return Container(
                margin: EdgeInsets.only(left: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            'Enter Details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      //Text('Amount/day'),
                      TextField(
                        controller: chatController.amountController,
                        decoration: InputDecoration(
                          label: Text('Amount/day'),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Start Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context, 1);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 30),
                          padding: EdgeInsets.only(left: 5),
                          height: mediaHeight * 0.06,
                          width: mediaWidth / 3 + 20,
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(children: [
                            Obx(
                              () => Text(DateFormat.yMMMd()
                                  .format(chatController.startDate.value)),
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
                        'End Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context, 2);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 30),
                          padding: EdgeInsets.only(left: 5),
                          height: mediaHeight * 0.06,
                          width: mediaWidth / 3 + 20,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(children: [
                            Obx(
                              () => Text(DateFormat.yMMMd()
                                  .format(chatController.endDate.value)),
                            ),
                            Icon(
                              Icons.calendar_month,
                              color: Color(0xffF4B755),
                            ),
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          chatController.submitRequest(widget.toId);
                        },
                        child: Center(
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
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: mediaWidth * 0.02,
                                  ),
                                  Text(
                                    'Submit Request',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        }));
  }
}
