import 'package:get/get.dart';

class BottomNavController extends GetxController {
  // Observable variable to hold the current index
  var currentIndex = 0.obs;

  // Method to update the current index
  void updateIndex(int index) {
    currentIndex.value = index;
  }
}
