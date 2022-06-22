import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
class AddPostController extends GetxController{

  String dropDownValue = '';
  var myImages = [].obs;
  var imageIsSelected = false.obs;

  pickMultipleImagesFromGallery()async{
    late final List<XFile>? images;
    final ImagePicker _picker = ImagePicker();
    images = await _picker.pickMultiImage();
    imageIsSelected.value = true;
    for(int i=0;i<images!.length;i++){
      myImages.add(images[i].path);
    }
  }
  removeImage(int index){
    myImages.remove(myImages[index]);
    print(myImages.length);
    if(myImages.isEmpty){
      imageIsSelected.value = false;
    }
  }
}