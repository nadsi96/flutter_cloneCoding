import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/main/main_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

/// 주식현재가 - 호가
/// 테이블 왼쪽 아래 공간
class LeftBottomSection extends StatelessWidget {
  final controller = Get.find<MainController>();
  late final pd;
  final fontSize = 14.0;

  final bool showTop;

  LeftBottomSection({Key? key, this.showTop = true}) : super(key: key) {
    print("hello 왼쪽아래");
    print(controller.hogaPage_tradeData.value);
    print(controller.hogaPage_tradeData.value.isEmpty);
    if(controller.hogaPage_tradeData.value.isEmpty) {
      pd = ProduceTradeData(controller.hogaPage_sellHoga.value,
          controller.hogaPage_buyHoga.value, controller);
      controller.hogaPage_setTradeData(pd.data);
    }
    // dataListening();
  }

  /// 두 항목이 양 끝에 위치한 행
  /// [ㅁㅁ]
  Widget rowItem(
      {String? key,
      dynamic value,
      String vTail = "",
      Color kColor = BLACK,
      Color vColor = BLACK}) {
    String v;
    if (value == null) {
      v = "";
    } else {
      if (value is int) {
        v = formatIntToStr(value);
      } else if (value is double) {
        v = "${double.parse(value.toStringAsFixed(2))}";
      } else if (value is String) {
        v = value;
      } else {
        v = "";
      }
    }
    v += vTail;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key ?? "",
            style: TextStyle(color: kColor, fontSize: fontSize),
          ),
          Text(
            v,
            style: TextStyle(color: vColor, fontSize: fontSize),
          ),
        ],
      ),
    );
  }

  Widget tradeDataList() {
    final ran = Random();

    return Obx(() {
      final dataList = controller.hogaPage_tradeData.value;

      return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: List.generate(dataList.length, (idx) {
            final price = dataList[idx].price;
            final pColor = dataList[idx].pColor;
            return rowItem(
                key: formatIntToStr(price),
                value: ran.nextInt(10) + 1,
                kColor: pColor,
                vColor: (dataList[idx].tradeType) ? RED : BLUE);
          }));
    });
  }

  Future<void> dataListening() async {
    final ran = Random();

    var i = 0;
    while (controller.hogaPage_tradDataUpdateFlag) {
      print(++i);
      await Future.delayed(Duration(seconds: ran.nextInt(5) + 1), () {
        pd.newData();
        controller.hogaPage_setTradeData(pd.data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (showTop)
        ? Column(children: [
            Expanded(
              flex: 3,
              child: Container(),
            ),
            Expanded(
              flex: 17,
              child: tradeDataList(),
            )
          ])
        : tradeDataList();
  }
}

class ProduceTradeData {
  List<TradeData> data = [];
  final sellPrices; // HogaData.sellHoga
  final buyPrices; // HogaData.buyHoga
  final ran = Random();
  final MainController controller;

  ProduceTradeData(this.sellPrices, this.buyPrices, this.controller) {
    createData();
  }

  //50개
  void createData() {
    print("create");
    data = List.generate(50, (index) {
      final bool type = (ran.nextInt(2).isOdd) ? true : false;
      final idx = ran.nextInt(10);
      final int price = (type) ? buyPrices[idx].price : sellPrices[idx].price;

      return TradeData(
          tradeType: type,
          price: price,
          standard: controller.hogaPage_standardPrice.value);
    });
  }

  void newData() {
    data.removeLast();

    final bool type = (ran.nextInt(2).isOdd) ? true : false;
    final idx = ran.nextInt(10);
    final int price = (type) ? buyPrices[idx].price : sellPrices[idx].price;

    data.insert(
        0,
        TradeData(
            tradeType: type,
            price: price,
            standard: controller.hogaPage_standardPrice.value));
  }
}

class TradeData {
  final bool tradeType;
  final int price;

  late Color pColor;

  TradeData(
      {required this.tradeType, required this.price, required int standard}) {
    if (standard < price) {
      pColor = RED;
    } else if (standard > price) {
      pColor = BLUE;
    } else {
      pColor = BLACK;
    }
  }
}
