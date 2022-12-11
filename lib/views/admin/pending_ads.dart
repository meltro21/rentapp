import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rentapp/controllers/add_post_controller.dart';
import 'package:rentapp/controllers/my_adds_controller.dart';
import 'package:rentapp/views/home/add_detail_Home.dart';

import '../../controllers/admin_controllers.dart/pending_ads_controller.dart';

class PendingAds extends StatefulWidget {
  const PendingAds({Key? key}) : super(key: key);

  @override
  State<PendingAds> createState() => _PendingAdsState();
}

class _PendingAdsState extends State<PendingAds> {
  PendingAdsController pendingAdsController = Get.put(PendingAdsController());

  int index = 0;
  var items = [
    'pending',
    'approved',
    'rejected',
  ];
  String dropdownvalue = 'pending';

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
    pendingAdsController.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;
    var mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Ads"),
      ),
      body: SafeArea(
        child: Container(
          height: mediaHeight,
          width: mediaWidth,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //list view
            Expanded(
              child: Obx(
                (() => ListView.builder(
                    itemCount: pendingAdsController.postsList.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: (() {
                          Get.to(AddDetailHome(
                              postDetails:
                                  pendingAdsController.postsList[index]));
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
                                        pendingAdsController
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
                                    color: pendingAdsController.dropdownvalue[index]=="rejected"? Colors.red:pendingAdsController.dropdownvalue[index]=="pending"?Colors.yellow:Colors.green,
                                    child: Text(pendingAdsController
                                            .dropdownvalue[index]),
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
                                      Text(pendingAdsController
                                          .postsList[index].subCategory
                                          .toUpperCase()),
                                      Expanded(child: SizedBox()),
                                      DropdownButton<String>(
                                        // Initial Value
                                        value: pendingAdsController
                                            .dropdownvalue[index],

                                        // Down Arrow Icon
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),

                                        // Array list of items
                                        items: pendingAdsController.items
                                            .map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            pendingAdsController
                                                    .dropdownvalue[index] =
                                                newValue!;
                                          });
                                          pendingAdsController.updateStatus(
                                              index, newValue);
                                        },
                                      ),
                                    ]),
                                    SizedBox(
                                      height: mediaHeight * 0.3 * 0.02,
                                    ),
                                    Text(
                                      'Rs ${pendingAdsController.postsList[index].price}',
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
                                          '${pendingAdsController.postsList[index].address}',
                                          style: TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Row(children: [
                                      Expanded(child: SizedBox()),
                                      Text(
                                        DateFormat('d MMM yyyy').format(
                                            pendingAdsController
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
                    }))),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
