import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/hoga/data/hoga_data.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/hoga/data/produce_hoga_data.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

class Hoga_Che_Table extends StatelessWidget {
  final mainController = Get.find<MainController>();

  final scrollController = ScrollController();

  final double cellHeight = 52;

  final cellPadding = const EdgeInsets.all(5);

  final ran = Random();

  Hoga_Che_Table({Key? key}) : super(key: key) {
    mainController.hogaPage_setHoga(ProduceHogaData()); // 데이터 받
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
                      '${(stockPrice * 1.3).toInt()}',
                      style: const TextStyle(
                          fontSize: 15,
                          color: RED,
                          fontWeight: FontWeight.bold),
                    )
                  : Text(
                      '${(stockPrice * 0.7).toInt()}',
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
      final stockPrice = mainController.getSelectedStockData().getPriceInt();
      final sellHoga = mainController.hogaPage_sellHoga.value;
      final buyHoga = mainController.hogaPage_buyHoga.value;
      List<Widget> hoga = List.generate(
          sellHoga.length, (idx) => hogaCell(sellHoga[idx], stockPrice, true));
      hoga.addAll(List.generate(
          buyHoga.length, (idx) => hogaCell(buyHoga[idx], stockPrice, false)));
      hoga.insert(0, hogaCellLimit(stockPrice, true)); // 상한가
      hoga.add(hogaCellLimit(stockPrice, false)); // 하한가

      return Column(
        children: hoga,
      );
    });
  }

  /// 화면 처음 열 때, 스크롤을 가운데로 이동
  void scrollToCenter() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent / 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 화면 그려지고 난 뒤 동작
    // 스크롤 가운데로 이동
    WidgetsBinding.instance!.addPostFrameCallback((_) => scrollToCenter());
    
    return Stack(
      children: [
        SingleChildScrollView(
          controller: scrollController,
          child: Obx(() {
            if (mainController.stockOrderPage_hoga_che_toggle.value) {
              // 호가
              return hoga();
            } else {
              // 체결
              return Container();
            }
          }),
        ),
      ],
    );
  }
}
