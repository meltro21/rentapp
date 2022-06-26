import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';

class AddPostController extends GetxController {
  RxList<AutocompletePrediction> predictions = <AutocompletePrediction>[].obs;
  TextEditingController locationController = TextEditingController();
  var address = ''.obs;

  late GooglePlace googlePlace;

  String dropDownValue = '';
  var myImages = [].obs;
  var imageIsSelected = false.obs;

  pickMultipleImagesFromGallery() async {
    late final List<XFile>? images;
    final ImagePicker _picker = ImagePicker();
    images = await _picker.pickMultiImage();
    imageIsSelected.value = true;
    for (int i = 0; i < images!.length; i++) {
      myImages.add(images[i].path);
    }
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
}
