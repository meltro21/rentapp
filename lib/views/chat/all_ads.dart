import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rentapp/controllers/chat_controller.dart';

class AllAds extends StatefulWidget {
  String toId;
  AllAds({Key? key, required this.toId}) : super(key: key);

  @override
  State<AllAds> createState() => _AllAdsState();
}

class _AllAdsState extends State<AllAds> {
  ChatController chatController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatController.getAllAds(widget.toId);
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Select an Add',
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
        body: SafeArea(
            child: Column(children: [
          Obx(
            () => Expanded(
                child: ListView.builder(
              itemCount: chatController.postsList.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: (() {
                    chatController.selectedAdDetails.value =
                        chatController.postsList[index];
                    Get.back();
                  }),
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    height: mediaHeight * 0.14,
                    width: mediaWidth,
                    child: Row(children: [
                      Stack(children: [
                        Container(
                          height: mediaHeight * 0.14,
                          width: mediaWidth * 0.35,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                chatController.postsList[index].imagesUrl[0],
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
                            color: chatController.postsList[index].status ==
                                    "approved"
                                ? Colors.green
                                : chatController.postsList[index].status ==
                                        "rejected"
                                    ? Colors.red
                                    : chatController.postsList[index].status ==
                                            "rented"
                                        ? Colors.orange
                                        : Colors.yellow,
                            child: Text(chatController.postsList[index].status),
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
                              Text(chatController.postsList[index].subCategory
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
                              'Rs ${chatController.postsList[index].price}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: mediaHeight * 0.3 * 0.01,
                            ),
                            Expanded(
                              child: Container(
                                width: mediaWidth / 2,
                                child: Text(
                                  '${chatController.postsList[index].address}',
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Row(children: [
                              Expanded(child: SizedBox()),
                              Text(
                                DateFormat('d MMM yyyy').format(
                                    chatController.postsList[index].createdAt),
                                style: TextStyle(fontSize: 12),
                              )
                            ]),
                          ],
                        ),
                      ),
                    ]),
                  ),
                );
              }),
            )),
          )
        ])));
  }
}
