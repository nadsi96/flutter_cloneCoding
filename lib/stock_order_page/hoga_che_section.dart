import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/controllers/stock_order_controller.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/hoga/data/hoga_data.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/hoga/data/produce_hoga_data.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/hoga/section_left_bottom.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

class Hoga_Che_Table extends StatelessWidget {
  final mainController = Get.find<MainController>();
  final stockOrderController = Get.find<StockOrderController>();

  final hogaScrollController = ScrollController();

  final double cellHeight = 52;

  final cellPadding = const EdgeInsets.all(5);

  final ran = Random();

  Hoga_Che_Table({Key? key}) : super(key: key) {
    mainController.hogaPage_setHoga(ProduceHogaData()); // 데이터 받
    mainController.hogaPage_setTradeData(ProduceTradeData(
            mainController.hogaPage_sellHoga.value,
            mainController.hogaPage_buyHoga.value,
            mainController.getSelectedStockData())
        .data);
  }

  /// 셀 배경
  /// 테두리 - 하단, 우
  /// 배경색 - bool sell에 따라
  ///       true - 연파랑, false - 연빨강
  BoxDecoration cellBorder(bool sell) {
    return BoxDecoration(
      border: const Border(
        bottom: BorderSide(
          color: LIGHTGRAY,
        ),
        right: BorderSide(
          color: LIGHTGRAY,
        ),
      ),
      color: (sell) ? LIGHTBLUE : LIGHTRED,
    );
  }

  /// 상/하한가 부분 셀
  /// high - true - 상한가
  ///        false - 하한가
  Widget hogaCellLimit(int stockPrice, bool high) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
              height: 40,
              padding: cellPadding,
              decoration: cellBorder(high),
              alignment: Alignment.centerRight,
              child: (high)
                  ? Text(
                      formatIntToStr((stockPrice * 1.3).toInt()),
                      style: const TextStyle(
                          fontSize: 15,
                          color: RED,
                          fontWeight: FontWeight.bold),
                    )
                  : Text(
                      formatIntToStr((stockPrice * 0.7).toInt()),
                      style: const TextStyle(
                          fontSize: 15,
                          color: BLUE,
                          fontWeight: FontWeight.bold),
                    )),
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: 40,
            padding: cellPadding,
            decoration: cellBorder(high),
            alignment: Alignment.centerRight,
            child: (high)
                ? const Text(
                    '상한가',
                    style: TextStyle(fontSize: 14, color: RED),
                  )
                : const Text(
                    '하한가',
                    style: TextStyle(fontSize: 14, color: BLUE),
                  ),
          ),
        ),
      ],
    );
  }

  /// 호가테이블 셀
  /// 호가, 등락률, 잔량, 체결
  /// iSSell - 매도하는 것인지
  Widget hogaCell(HogaData data, int stockPrice, bool isSell) {
    Color fontColor = BLACK;
    if (data.rate > 0) {
      fontColor = RED;
    } else if (data.rate < 0) {
      fontColor = BLUE;
    }

    int tr = 0;
    if (ran.nextInt(6) == 5) {
      tr = ran.nextInt(200) - 100;
    }

    return Row(children: [
      Expanded(
        flex: 5,
        child: Container(
          height: cellHeight,
          padding: (stockPrice == data.price) ? null : cellPadding,
          decoration: cellBorder(isSell),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (stockPrice == data.price)
                  ? Container(
                      width: double.infinity,
                      padding: cellPadding,
                      decoration:
                          BoxDecoration(border: Border.all(color: BLACK)),
                      alignment: Alignment.centerRight,
                      child: Text(
                        formatIntToStr(data.price),
                        style: TextStyle(
                            fontSize: 16,
                            color: fontColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Text(
                      formatIntToStr(data.price),
                      style: TextStyle(
                          fontSize: 16,
                          color: fontColor,
                          fontWeight: FontWeight.bold),
                    ),
              Text(
                formatDoubleToStr(data.rate, needSign: false),
                style: TextStyle(fontSize: 14, color: fontColor),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        flex: 4,
        child: Container(
          height: cellHeight,
          padding: cellPadding,
          decoration: cellBorder(isSell),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(formatIntToStr(data.cnt),
                  style: const TextStyle(fontSize: 14)),
              Text(
                (tr != 0) ? '$tr' : '',
                style: TextStyle(fontSize: 14, color: (tr > 0) ? RED : BLUE),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  /// 호가 테이블 (10호가)
  Widget hoga() {
    return Obx(() {
      final stockPrice = mainController.getSelectedStockData().getPriceInt(); // 현재가
      final sellHoga = mainController.hogaPage_sellHoga.value; // 매도호가
      final buyHoga = mainController.hogaPage_buyHoga.value; // 매수호가

      // 매도호가
      List<Widget> hoga = List.generate(
          sellHoga.length, (idx) => hogaCell(sellHoga[idx], stockPrice, true));
      // 매수호가
      hoga.addAll(List.generate(
          buyHoga.length, (idx) => hogaCell(buyHoga[idx], stockPrice, false)));
      //상한가
      hoga.insert(0, hogaCellLimit(stockPrice, true));
      //하한가
      hoga.add(hogaCellLimit(stockPrice, false));

      return Column(
        children: hoga,
      );
    });
  }

  /// 체결 정보
  Widget tradeData() {
    final dataList = mainController.hogaPage_tradeData.value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Scrollbar(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: List.generate(dataList.length, (idx) {
              final price = dataList[idx].price;
              final pColor = dataList[idx].pColor;
              return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatIntToStr(price),
                          style: TextStyle(fontSize: 14, color: pColor)),
                      Text('${ran.nextInt(100)}',
                          style: TextStyle(
                              fontSize: 14,
                              color: (dataList[idx].tradeType) ? RED : BLUE)),
                    ],
                  )
              );
            }),
          )
      )
    );
  }

  /// 화면 처음 열 때, 스크롤을 가운데로 이동
  void scrollToCenter() {
    if (hogaScrollController.hasClients) {
      print('hello');
      hogaScrollController.jumpTo(hogaScrollController.position.maxScrollExtent / 2);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Obx(() {
          if (stockOrderController.hoga_che_toggle.value) {
            // 화면 그려지고 난 뒤 동작
            // 스크롤 가운데로 이동
            WidgetsBinding.instance!.addPostFrameCallback((_) => scrollToCenter());
            return SingleChildScrollView(
              controller: hogaScrollController,
              child: hoga(),
            );
          } else {
            return Column(
              children: [
                Container(
                  height: 80,
                  color: BLUE,
                ),
                Expanded(
                  child: tradeData(),
                ),
              ],
            );
          }
        }),
        Positioned(
          left: 0,
          bottom: 10,
          child: InkWell(
            onTap: () => stockOrderController.hoga_che_toggle.toggle(),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                color: Color.fromARGB(200, 120, 120, 120),
              ),
              padding: const EdgeInsets.all(10),
              child: Obx(() {
                final text =
                    (stockOrderController.hoga_che_toggle.value)
                        ? '체\n결'
                        : '호\n가';
                return Text(
                  text,
                  style: const TextStyle(
                      color: WHITE, fontSize: 16, fontWeight: FontWeight.bold),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
