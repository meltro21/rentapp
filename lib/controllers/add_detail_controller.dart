import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AddDetailController extends GetxController {
  var readMore = false.obs;

  changeReadMoreValue() {
    readMore.value = !readMore.value;
  }
}
