import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentapp/controllers/add_detail_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AddDetailHome extends StatefulWidget {
  const AddDetailHome({Key? key}) : super(key: key);

  @override
  State<AddDetailHome> createState() => _AddDetailHomeState();
}

class _AddDetailHomeState extends State<AddDetailHome> {
  AddDetailController addDetailController = Get.put(AddDetailController());
  late ScrollController _controller;
  _moveUp(var mediaWidth) {
    _controller.animateTo(_controller.offset - mediaWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 200));
  }

  _moveDown(var mediaWidth) {
    _controller.animateTo(_controller.offset + mediaWidth,
        curve: Curves.linear, duration: Duration(milliseconds: 200));
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = ScrollController();
    super.initState();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //top images list
                  Container(
                    height: mediaHeight * 0.3,
                    child: Stack(children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _controller,
                        itemCount: 3,
                        itemExtent: mediaWidth,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onPanUpdate: (details) {
                              if (details.delta.direction > 0) {
                                print('swipe left');
                                _moveUp(mediaWidth);
                              }

                              // Swiping in left direction.
                              if (details.delta.direction < 0) {
                                print('swipe right');
                                _moveDown(mediaWidth);
                              }
                            },
                            child: Container(
                              child: Image.asset(
                                'assets/images/image1.jpeg',
                                fit: BoxFit.fill,
                                width: mediaWidth,
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
                                  '1/',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '3',
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
                      'Rs 4,000/day',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  //Name
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      'Buldozer',
                      style: TextStyle(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        Text('Faisal Town, Lahore'),
                        Icon(Icons.location_on),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Text('14-May-2022'),
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
                              "Did you know the word ‘essay’ is derived from a Latin word ‘exagium’, which roughly translates to presenting one’s case? So essays are a short piece of writing representing one’s side of the argument or one’s experiences, stories, etc. Essays are very personalized. So let us learn about types of essays, format, and tips for essay-writing.",
                              maxLines: 4,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              "Did you know the word ‘essay’ is derived from a Latin word ‘exagium’, which roughly translates to presenting one’s case? So essays are a short piece of writing representing one’s side of the argument or one’s experiences, stories, etc. Essays are very personalized. So let us learn about types of essays, format, and tips for essay-writing.",
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
                  Container(
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
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
              child: Container(
                height: mediaHeight * 0.06,
                width: mediaWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.pink),
                margin: EdgeInsets.only(
                    top: mediaHeight * 0.01, bottom: mediaHeight * 0.01),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          ),
        ]),
      ),
    );
  }
}
