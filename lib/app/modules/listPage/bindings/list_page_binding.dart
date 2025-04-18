import 'package:get/get.dart';

import '../controllers/list_page_controller.dart';

class ListPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListPageController>(() => ListPageController());
  }
}
