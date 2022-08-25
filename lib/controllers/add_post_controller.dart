import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';

class AddPostController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  RxList<AutocompletePrediction> predictions = <AutocompletePrediction>[].obs;

  TextEditingController priceController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  var address = ''.obs;

  late GooglePlace googlePlace;

  String dropDownValue = '';
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

  void setGooglePlaceApiKey() {
    String apiKey = "AIzaSyCcAsVWMa5EasKOmtXFMXaZgbILGBLrG0w";
    googlePlace = GooglePlace(apiKey);
  }

  void autoCompleteSearch(String value) async {
    print('start autoComplete');
    var result = await googlePlace.autocomplete.get(value);
    if (result != null) {
      predictions.value = result.predictions!;
      print('predictions length is ${predictions.length}');
    }
  }

  void addPost() async {
    DateTime createdAt = DateTime.now();
    try {
      var post = await _firestore.collection('Posts').add({
        'category': dropDownValue,
        'price': priceController.text,
        'model': modelController.text,
        'description': descriptionController.text,
        'createdAt': createdAt
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
            var a = await ref.putFile(File(myImages[i]));
            print('ref is $ref');
            print('put file $a');
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
  }
}
