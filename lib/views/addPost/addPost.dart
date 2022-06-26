import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentapp/controllers/add_post_controller.dart';
import 'package:rentapp/views/addPost/select_location.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController addController = TextEditingController();
  var addPostController = Get.put(AddPostController());
  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;
    var mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //add Images
              GestureDetector(
                onTap: () {
                  addPostController.pickMultipleImagesFromGallery();
                },
                child:
                    Obx(() => addPostController.imageIsSelected.value == false
                        ? Container(
                            height: mediaHeight * 0.18,
                            width: mediaWidth,
                            color: Colors.grey[200],
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50),
                                ),
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Add images',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                            ),
                          )
                        : Container(
                            height: mediaHeight * 0.18,
                            width: mediaWidth,
                            color: Colors.grey[200],
                            child: Obx(
                              () => ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      addPostController.myImages.value.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                padding: EdgeInsets.only(
                                                    top: 20, left: 20),
                                                height: mediaHeight * 0.1,
                                                child: InkWell(
                                                    onTap: () {
                                                      addPostController
                                                          .removeImage(index);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                        ' Remove image')),
                                              );
                                            });
                                      },
                                      child: Obx(
                                        () => Container(
                                          padding: EdgeInsets.only(right: 5),
                                          width: mediaWidth * 0.3,
                                          height: mediaHeight * 0.18,
                                          child: Image.file(
                                            File(addPostController
                                                .myImages.value[index]),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          )),
              ),

              //Category
              SizedBox(
                height: mediaHeight * 0.02,
              ),
              const Text('Select a Category'),
              Container(
                width: mediaWidth,
                child: DropdownButton<String>(
                  value: addPostController.dropDownValue,
                  icon: const SizedBox(),
                  // icon: Align(
                  //   alignment:Alignment.topLeft,
                  //   child: const Icon(Icons.arrow_downward)),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      addPostController.dropDownValue = newValue!;
                    });
                  },
                  items: <String>[
                    '',
                    'Car',
                    'Dump Truck',
                    'Excavator',
                    'Concrete Mixer'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),

              //Price
              TextFormField(
                //controller: addController,
                decoration: const InputDecoration(
                  label: Text('Price/day'),
                ),
              ),
              //Model
              TextFormField(
                // controller: addController,
                decoration: const InputDecoration(
                  label: Text('Model'),
                ),
              ),
              //Description
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: addController,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Description'),
                ),
              ),
              //Location
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Get.to(SelectLocation());
                },
                child: Container(
                  height: mediaHeight * 0.08,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Row(children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Location',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Obx(() => addPostController.address.value == ''
                              ? Text('Choose')
                              : Flexible(
                                  child:
                                      Text(addPostController.address.value))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Icon(Icons.arrow_right)
                  ]),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
