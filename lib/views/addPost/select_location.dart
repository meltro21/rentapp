// import 'package:flutter/material.dart';

// class SelectLocation extends StatefulWidget {
//   const SelectLocation({Key? key}) : super(key: key);

//   @override
//   State<SelectLocation> createState() => _SelectLocationState();
// }

// class _SelectLocationState extends State<SelectLocation> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentapp/controllers/add_post_controller.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({Key? key}) : super(key: key);

  @override
  State<SelectLocation> createState() => _EnterAddressState();
}

class _EnterAddressState extends State<SelectLocation> {
  AddPostController addPostController = Get.find();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    AddPostController addPostController = Get.find();
    addPostController.setGooglePlaceApiKey();
  }

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    var mediaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.only(top: 20, left: 20),
        height: mediaHeight,
        width: mediaWidth,
        color: Colors.grey[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {
                  addPostController.locationController.clear();
                  Get.back();
                },
                child: Icon(Icons.arrow_back)),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.white,
              width: mediaWidth * 0.9,
              child: TextField(
                autofocus: true,
                style: TextStyle(color: Colors.black),
                controller: addPostController.locationController,
                decoration: InputDecoration(
                  //   filled: true,
                  // fillColor: Color(0xff111C42),

                  labelText: "Address",

                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black)),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    addPostController.autoCompleteSearch(value);
                    print('length is ${addPostController.predictions.length}');
                  } else {
                    addPostController.predictions.value = [];
                    print('length is ${addPostController.predictions.length}');
                  }
                },
              ),
            ),
            Obx(() => addPostController.predictions.value.length > 0
                ? Expanded(
                    child: Obx(
                      () => ListView.builder(
                        itemCount: addPostController.predictions.value.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                Icons.pin_drop,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              addPostController.predictions[index].description
                                  as String,
                              style: TextStyle(color: Colors.black),
                            ),
                            onTap: () async {
                              //print('index is $index');
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus &&
                                  currentFocus.focusedChild != null) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                              var result = await addPostController
                                  .googlePlace.details
                                  .get(addPostController
                                      .predictions[index].placeId
                                      .toString());
                              print(
                                  'result is ${result!.result!.geometry!.location!.lat}');
                              var a = addPostController
                                  .predictions[index].description as String;
                              print('a is $a');
                              // addPostController.latitude = result!.result!.geometry!.location!.lat!;
                              // addPostController.longitude = result.result!.geometry!.location!.lng!;
                              // setState(() {
                              //   var a = addPostController
                              //       .predictions[index].description as String;
                              //   int count = 0;
                              //   List<int> commaIndex = [];
                              //   for (int i = 0; i < a.length; i++) {
                              //     if (a[i] == ',') {
                              //       count++;
                              //       commaIndex.add(i);
                              //     }
                              //   }
                              //   double midIndex = count / 2;
                              //   int roundedIndex = midIndex.toInt();
                              //   String modifiedAddress = '';
                              //   for (int i = 0; i < a.length; i++) {
                              //     if (i == commaIndex[roundedIndex]) {
                              //       modifiedAddress += '\n';
                              //     } else {
                              //       modifiedAddress += a[i];
                              //     }
                              //   }
                              //   print('comma count is $count');
                              //   print('comma index is $commaIndex');
                              //   print('modified address is $modifiedAddress');
                              //   addPostController.locationController.text =
                              //       modifiedAddress;
                              //   addPostController.predictions.value = [];

                              //   print('address is $modifiedAddress');
                              //   addPostController.address.value = a;
                              // });
                              addPostController.address.value = a;
                              addPostController.locationController.text = a;

                              Get.back();
                              FocusManager.instance.primaryFocus?.unfocus();
                              //   print('predictions index is ${predictions[index].placeId.toString()}');

                              //   print('result is $result');
                              // //  print('lattitude is ${result!.result!.geometry!.location!.lat}');
                              //   print(result.result!.geometry!.location!.lng);
                            },
                          );
                        },
                      ),
                    ),
                  )
                : SizedBox()),
          ],
        ),
      )),
    );
  }
}
