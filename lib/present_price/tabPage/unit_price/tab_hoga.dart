import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/hoga/data/produce_hoga_data.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/hoga/widget_table.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

class TabHoga extends StatelessWidget {
  final controller = Get.find<MainController>();
  final scrollController = ScrollController();
  final double cellHeight = 40;
  final int rowCnt = 7;
  final double cellBigFont = 16;
  final double cellSmallFont = 14;
  final double sideFont = 12;

  TabHoga({Key? key}) : super(key: key) {
    if (controller.hogaPage_sellHoga.value.isEmpty) {
      controller.hogaPage_setHoga(
          ProduceHogaData(), controller.getSelectedStockData().price ?? 0);
    }

    final ptd = ProduceTabHogaSomeData();
    controller.unitPage_setHogaTabLeftBottomData(ptd.setData(controller.hogaPage_standardPrice.value));

  }

  String getRate(int a, int b) {
    return formatDoubleToStr(((a / b) - 1) * 100);
  }

  /// price, standard 비교해서
  /// price가 크면 빨강 작으면 파랑, 같으면 검정 반환
  Color getColor(int price, int standard) => (price > standard)
      ? RED
      : (price < standard)
      ? BLUE
      : BLACK;

  /// 두 항목이 양 끝에 위치한 행
  /// [ㅁㅁ]
  Widget rowItem(
      {String? key,
        dynamic value,
        String vTail = "",
        Color kColor = BLACK,
        Color vColor = BLACK}) {
    var v;
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
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key ?? "",
          style: TextStyle(color: kColor, fontSize: sideFont),
        ),
        Text(
          v,
          style: TextStyle(color: vColor, fontSize: sideFont),
        ),
      ],
    ),);
  }

  /// 테이블 오른쪽 위 공간
  Widget rightTop(){
    final ran = Random();

    final stock = stockData[controller.getSelectedStock()]; // 주식정보(현재가, 예상가, 단일가)
    final prePrice = controller.getSelectedStockData().price ?? 0;
    final predictPrice = stock?.elementAt(2).price ?? 0;
    final standard = controller.hogaPage_standardPrice.value; // 기준가
    Widget icon = Spacer();
    Color fontColor = BLACK;
    final dist = stock?.elementAt(1).vari ?? 0;
    final rate = stock?.elementAt(1).getRate() ?? 0;

    if(rate < 0){
      icon = const Icon(Icons.arrow_drop_down_sharp, color: BLUE, size: 20,);
      fontColor = BLUE;
    }else if(rate > 0){
      icon = const Icon(Icons.arrow_drop_down_sharp, color: RED);
      fontColor = RED;
    }

    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          rowItem(key: "상한가", value: 9999999, vColor: RED),
          rowItem(key: "하한가", value: 100, vColor: BLUE),
          Container(height: 10),
          rowItem(key: '예상가', value: stock![1].price, vColor: ((standard > predictPrice) ? RED : (standard < predictPrice) ? BLUE : BLACK)), // 단일가내용
          rowItem(key: '예상량', value: 0),
          Container(height: 10),
          rowItem(key: '정규장', value: standard, vColor: fontColor), // 기준가
          Container(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: icon,
                ),
                Expanded(
                  child: Text(formatIntToStr(dist), style: TextStyle(fontSize: sideFont, color: fontColor),textAlign: TextAlign.right,),),
              ],
            ),
          ),
          rowItem(value: formatDoubleToStr(rate), vColor: fontColor),
          rowItem(value: ran.nextInt(500000)),
        ],
      ),
    );
  }
  /// 테이블 왼쪽 아래 공간
  Widget leftBottom(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      child: Obx((){
        final dataList = controller.unitPage_hogaTab_leftBottom_data.value;

        return ListView(
            children: List.generate(
              dataList.length,
                (idx) {
                Color color = BLACK;
                if(dataList[idx].price > controller.hogaPage_standardPrice.value){
                  color = RED;
                }else if(dataList[idx].price < controller.hogaPage_standardPrice.value){
                  color = BLUE;
                }

                return rowItem(key: formatIntToStr(dataList[idx].price), value: dataList[idx].cnt, kColor: color);
                }
            ),
        );
      }),
    );
  }

  /// 테이블 아래 줄 (잔량합계)
  Widget bottom() {
    final ran = Random();

    return Container(
      height: cellHeight,
      decoration: BoxDecoration(
        color: LIGHTGRAY,
        border: Border.all(color: GRAY, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: cellHeight,
              padding: const EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              child: Text(
                formatIntToStr(ran.nextInt(100000)),
                style: TextStyle(color: BLACK, fontSize: cellBigFont),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: cellHeight,
              decoration: const BoxDecoration(
                color: WHITE,
                border: Border.symmetric(
                  vertical: BorderSide(color: GRAY, width: 1),
                ),
              ),
              child: Center(
                child: Text(
                  "잔량합계",
                  style: TextStyle(color: BLACK, fontSize: cellSmallFont),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: cellHeight,
              padding: const EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              child: Text(
                formatIntToStr(ran.nextInt(100000)),
                style: TextStyle(color: BLACK, fontSize: cellBigFont),
              ),
            ),
          ),
        ],
      ),
    );
  }

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

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Obx(() {
              final sellData = controller.hogaPage_sellHoga.value;
              final buyData = controller.hogaPage_buyHoga.value;

              return Column(
                children: [
                  SizedBox(
                    height: cellHeight * rowCnt,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: List.generate(rowCnt, (idx) {
                              final dif = (sellData.length > rowCnt)? (sellData.length - rowCnt).abs() : 0;
                              return sellRow(sellData[idx+dif], cellHeight, cellBigFont: cellBigFont, cellSmallFont: cellSmallFont);
                            }),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: rightTop(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: cellHeight * rowCnt,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: leftBottom(),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: List.generate(rowCnt,
                                (idx) => buyRow(buyData[idx], cellHeight, cellBigFont: cellBigFont, cellSmallFont: cellSmallFont)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        bottom(), // 잔량합계
      ],
    );
  }
}

class ProduceTabHogaSomeData{
  // 10개 생성
  List<TabHogaSomeData> setData(int price){
    final ran = Random();

    return List.generate(10, (idx){
      final p = price + (ran.nextInt(10)-5)*100;
      final cnt = ran.nextInt(20000);
      return TabHogaSomeData(price: p, cnt: cnt);
    });
  }
}
class TabHogaSomeData{
  final int price;
  final int cnt;

  TabHogaSomeData({required this.price, required this.cnt});
}