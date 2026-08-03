import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  final List<({
    Widget screen,
    BottomNavigationBarItem item,
  })> items = [
    (item: BottomNavigationBarItem(icon:  Icon(Icons.home), label: 'home'.tr), screen: Center(child: Text('home_screen'.tr))),
    (item: BottomNavigationBarItem(icon:  Icon(Icons.settings), label: 'settings'.tr), screen: Center(child: Text('settings_screen'.tr))),
  ];
  

  void changeIndex(int newIndex) {
    index.value = newIndex;
  }

}