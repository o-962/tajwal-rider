import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;
  final List<({
    Widget screen,
    BottomNavigationBarItem item,
  })> items = [
    (item: BottomNavigationBarItem(icon:  const Icon(Icons.home), label: 'Home'), screen: const Center(child: Text('Home Screen'))),
    (item: BottomNavigationBarItem(icon:  const Icon(Icons.settings), label: 'Settings'), screen: const Center(child: Text('Settings Screen'))),
  ];
  

  void changeIndex(int newIndex) {
    index.value = newIndex;
  }

}