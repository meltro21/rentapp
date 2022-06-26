import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AddDetailController extends GetxController {
  var readMore = false.obs;
  var startDate = DateTime.now().obs;
  var endDate = DateTime.now().obs;
  changeReadMoreValue() {
    readMore.value = !readMore.value;
  }

  changeStartDate(DateTime date) {
    startDate.value = date;
  }

  changeEndDate(DateTime date) {
    endDate.value = date;
  }
}
