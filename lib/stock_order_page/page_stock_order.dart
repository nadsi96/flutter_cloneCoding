import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/commons/commons.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/controllers/tab_page_controller.dart';
import 'package:get/get.dart';

class StockOrder extends StatelessWidget {
  final mainController = Get.find<MainController>();
  final pageController = Get.find<TabPageController>();

  StockOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(title: '주식주문'),
      body: Column(
        children: [stockInfo(mainController.getSelectedStockData())],
      ),
    );
  }
}
