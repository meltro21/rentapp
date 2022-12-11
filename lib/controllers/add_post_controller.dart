import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';

class AddPostController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  RxList<AutocompletePrediction> predictions = <AutocompletePrediction>[].obs;

  TextEditingController priceController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  var address = ''.obs;
  double? lat = 0.0;
  double? lng = 0.0;
  String userId = '';
  var loading = false.obs;

  late GooglePlace googlePlace;

  Rx<String> dropDownValue = ''.obs;
  String subCategoryDropDownValue = '';

  var myImages = [].obs;
  var imageIsSelected = false.obs;

  pickMultipleImagesFromGallery() async {
    List<XFile>? images;
    final ImagePicker _picker = ImagePicker();
    images = await _picker.pickMultiImage();
    if (images != null) {
      imageIsSelected.value = true;
      for (int i = 0; i < images!.length; i++) {
        myImages.add(images[i].path);
      }
    }
    print('myImagesLength is ${myImages.length}');
  }

  removeImage(int index) {
    myImages.remove(myImages[index]);
    print(myImages.length);
    if (myImages.isEmpty) {
      imageIsSelected.value = false;
    }
  }

  void selectCategory(String value) {
    subCategoryDropDownValue = '';
    dropDownValue.value = value;
  }

  void setGooglePlaceApiKey() {
    String apiKey = "AIzaSyCcAsVWMa5EasKOmtXFMXaZgbILGBLrG0w";
    googlePlace = GooglePlace(apiKey);
  }

  void autoCompleteSearch(String value) async {
    print('start autoComplete');
    var result = await googlePlace.autocomplete.get(value);
    if (result != null) {
      predictions.value = result.predictions!;
      print('predictions length is ${predictions}');
    }
  }

  void addPost() async {
    loading.value = true;
    DateTime createdAt = DateTime.now();
    userId = _firebaseAuth.currentUser!.uid;
    List<String> urlList = [];
    try {
      var post = await _firestore.collection('Posts').add({
        'category': dropDownValue.value,
        'subCategory': subCategoryDropDownValue.toLowerCase(),
        'price': int.parse(priceController.text),
        'model': modelController.text,
        'description': descriptionController.text,
        'createdAt': createdAt,
        'address': address.value,
        'lat': lat,
        'lng': lng,
        'userId': userId,
        'favorites': [],
        'status': 'pending'
      });
      try {
        await _firestore
            .collection('Posts')
            .doc(post.id)
            .update({'id': post.id});

        try {
          //print('myImages path is ${myImages[0]}');

          for (int i = 0; i < myImages.length; i++) {
            Reference ref = _firebaseStorage.ref().child(post.id).child('$i');
            try {
              var a = await ref.putFile(File(myImages[i]));
              var url =
                  await _firebaseStorage.ref(ref.fullPath).getDownloadURL();
              urlList.add(url);
              print('url is $url');
            } catch (err) {
              print('posting single image error $err');
            }
          }
          try {
            await _firestore
                .collection('Posts')
                .doc(post.id)
                .update({'imagesUrl': urlList});
          } catch (err) {
            print('Error post list url $err');
          }
        } catch (err) {
          print('uplaod photos Error $err');
        }
      } catch (err) {
        print('update id error $err');
      }
    } catch (err) {
      print('add post error $err');
    }
    await Future.delayed(Duration(seconds: 3));
    Get.showSnackbar(GetSnackBar(
      title: 'Success',
      message: 'Add uploaded successfully',
      backgroundColor: Colors.green[400] as Color,
      duration: Duration(seconds: 2),
    ));

    loading.value = false;
  }

  bool checkEmptyField() {
    if (myImages.isEmpty) {
      print('1');
      emptyFieldDialogBox('No Image Found', 'Add an image');
      return false;
    } else {
      if (dropDownValue.isEmpty) {
        emptyFieldDialogBox('No Category Selected', 'select a category');

        return false;
      } else {
        if (subCategoryDropDownValue.isEmpty) {
          emptyFieldDialogBox('No Subcategory added', 'add subcategory');
        } else {
          if (priceController.text.isEmpty) {
            emptyFieldDialogBox('No Price Added', 'add a price');

            return false;
          } else {
            if (modelController.text.isEmpty) {
              emptyFieldDialogBox('No Model Added', 'add a model');

              return false;
            } else {
              if (descriptionController.text.isEmpty) {
                emptyFieldDialogBox(
                    'No Description Found', 'add some description');

                return false;
              } else {
                if (address.value.isEmpty) {
                  emptyFieldDialogBox('No Locaiton Found', 'select a location');

                  return false;
                }
              }
            }
          }
        }
      }
    }
    return true;
  }

  void emptyFieldDialogBox(String title, String error) {
    Get.defaultDialog(
        title: title,
        content: Column(
          children: [
            Text(error),
          ],
        ));
  }
}
