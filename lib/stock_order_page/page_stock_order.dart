import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/commons/commons.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/controllers/my_page_controller.dart';
import 'package:flutter_prac_jongmock/controllers/tab_page_controller.dart';
import 'package:get/get.dart';

/// 주식주문
class StockOrder extends StatelessWidget {
  final mainController = Get.find<MainController>();
  final pageController = Get.find<TabPageController>();
  final myPageController = Get.find<MyPageController>();

  StockOrder({Key? key}) : super(key: key) {
    // 로그인 상태 체크 후 진행
  }

  List<Widget> topBarActions() {
    return [
      InkWell(
        onTap: () {},
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.more_vert, color: BLACK, size: 30),
        ),
      ),
    ];
  }

  Widget top() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(() {
                  return searchStock(mainController.getSelectedStock());
                }),
              ),
              Container(
                width: 60,
                height: 40,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: LLIGHTGRAY),
                  color: LLLIGHTGRAY,
                ),
                child: const Text(
                  '예수금',
                  style: TextStyle(
                      fontSize: 14, color: BLACK, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 60,
                height: 40,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: LLIGHTGRAY),
                  color: LLLIGHTGRAY,
                ),
                child: const Text(
                  '이체',
                  style: TextStyle(
                      fontSize: 14, color: BLACK, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Obx(() {
            return stockInfo(mainController.getSelectedStockData());
          }),
        ],
      ),
    );
  }

  Widget account() {
    const double innerWidgetHeight = 40;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: LIGHTGRAY, width: 0.5)),
        color: LLLIGHTGRAY,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            // 계좌정보
            child: InkWell(
              onTap: () {},
              child: Container(
                height: innerWidgetHeight,
                color: LLIGHTGRAY,
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Obx(() {
                          return RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: myPageController.user.value.account,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: BLACK,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      ' [위탁계좌] 국내${myPageController.user.value.name} 가나다라마바사아자차카타파하',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: BLACK,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down,
                        color: GRAY, size: 18),
                  ],
                ),
              ),
            ),
          ), // 계좌정보
          Container(
            // 비밀번호
            height: innerWidgetHeight,
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(color: GRAY),
              color: WHITE,
              borderRadius: BorderRadius.circular(3),
            ),
            padding: const EdgeInsets.all(3),
            margin: const EdgeInsets.only(left: 5),
            alignment: Alignment.center,
            child: Row(
              children: [
                const Expanded(
                  child: Text('비밀번호',
                      style: TextStyle(fontSize: 14, color: GRAY),
                      textAlign: TextAlign.center),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: LLIGHTGRAY,
                    border: Border.all(color: GRAY),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  alignment: Alignment.center,
                  child:
                      const Icon(Icons.lock_outline, color: DARKGRAY, size: 20),
                ), // 비밀번호
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabs() {
    final texts = ['매수', '매도', '정정/취소', '미체결'];
    return Container(
      decoration: const BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: GRAY)),
      ),
      child: Row(
        children: List.generate(texts.length, (idx) {
          return InkWell(
            onTap: () {
              mainController.stockOrderPage_tabIdx.value = idx;
            },
            child: Container(
              width: 80,
              alignment: Alignment.center,
              child: Obx(() {
                if (mainController.stockOrderPage_tabIdx.value == idx) {
                  return Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: BLACK, width: 2))),
                    child: Text(texts[idx],
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  );
                } else {
                  return Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(texts[idx],
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: GRAY)),
                  );
                }
              }),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(title: '주식주문', actions: topBarActions()),
      body: Column(
        children: [
          top(), // 종목검색, 종목정보
          account(), // 계좌정보
          tabs(),
        ],
      ),
    );
  }
}
