import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/main/main_controller.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/hoga/ten_hoga.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

/// 주식현재가 - 호가
/// 테이블 오른쪽 위 공간
class RightTopSection extends StatelessWidget {
  final ran = Random();

  final controller = Get.find<MainController>();
  final tabCnt = 3;

  final bool showTop;

  final double fontSize = 12;

  RightTopSection({Key? key, this.showTop=true}) : super(key: key);

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

    return Row(
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
    );
  }

  Widget firstTab() {
    return Obx(() {
      final stock = controller.getSelectedStockData();
      final standard = controller.hogaPage_standardPrice.value; // 기준
      final price = (stock.price != null) ? stock.price! : 0; // 현재가
      final pPrice = price + (ran.nextInt(2000) - 1000); // 시가
      final hPrice = pPrice + (ran.nextInt(2000) ~/ 100 * 100); // 고가
      final lPrice = pPrice - (ran.nextInt(2000) ~/ 100 * 100); // 저가
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          rowItem(key: "52주고", value: ran.nextInt(10000) + price, vColor: RED),
          rowItem(key: "52주저", value: price - ran.nextInt(10000), vColor: BLUE),
          rowItem(key: "5이평", value: price),
          rowItem(key: "20이평", value: price),
          Container(height: 5),
          rowItem(key: "기준", value: standard),
          rowItem(key: "시가", value: pPrice, vColor: getColor(pPrice, standard)),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              getRate(pPrice, standard),
              style: TextStyle(
                  color: getColor(pPrice, standard), fontSize: fontSize - 2),
            ),
          ),
          rowItem(key: "고가", value: hPrice, vColor: getColor(hPrice, standard)),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              getRate(hPrice, standard),
              style: TextStyle(
                color: getColor(hPrice, standard),
                fontSize: fontSize - 2,
              ),
            ),
          ),
          rowItem(key: "저가", value: lPrice, vColor: getColor(lPrice, standard)),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              getRate(lPrice, standard),
              style: TextStyle(
                color: getColor(lPrice, standard),
                fontSize: fontSize - 2,
              ),
            ),
          ),
          rowItem(
              key: "상한", value: (standard + 30000), kColor: RED, vColor: RED),
          rowItem(
              key: "하한", value: (standard - 30000), kColor: BLUE, vColor: BLUE),
          rowItem(
              key: "상VI", value: (standard + 20000), kColor: RED, vColor: RED),
          rowItem(
              key: "하VI",
              value: (standard - 20000),
              kColor: BLUE,
              vColor: BLUE),
        ],
      );
    });
  }

  Widget secondTab() {
    return Column(children: [
      Expanded(
        child: Container(),
      ),
      Expanded(
        child: Obx(() {
          final stock =
              stockData[controller.getSelectedStock()]?.elementAt(1) ??
                  controller.getSelectedStockData(); // 예상가
          final standard = controller.hogaPage_standardPrice.value;
          final price = stock.price ?? 0;
          final dist = price - standard;
          final rate = (price / standard - 1) * 100;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              rowItem(key: "예상체결", value: null),
              rowItem(
                  key: null, value: price, vColor: getColor(dist, standard)),
              Row(
                children: [
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: (dist > 0)
                              ? const Icon(
                                  Icons.arrow_drop_up_sharp,
                                  color: RED,
                                  size: 18,
                                )
                              : (dist < 0)
                                  ? const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      color: BLUE,
                                      size: 18,
                                    )
                                  : null)),
                  Expanded(
                    child: Text(
                      formatIntToStr(dist),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: getColor((stock.vari ?? 0), 0),
                          fontSize: fontSize),
                    ),
                  ),
                ],
              ),
              rowItem(value: rate, vTail: "%", vColor: getColor(dist, 0)),
              rowItem(value: stock.count),
              const SizedBox(),
              rowItem(key: "시간외잔량"),
              rowItem(key: "매도", value: ran.nextInt(100000)),
              rowItem(key: "매수", value: ran.nextInt(100000)),
            ],
          );
        }),
      ),
    ]);
  }

  Widget thirdTab() {
    return Column(children: [
      const Spacer(flex: 2),
      Expanded(
          flex: 7,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                rowItem(key: "시가총액"),
                rowItem(value: ran.nextInt(5000000), vTail: "억"),
                rowItem(key: '액면가', value: 100, vTail: "원"),
                rowItem(key: 'PER', value: ran.nextDouble() * 100, vTail: "배"),
                rowItem(key: 'PBR', value: ran.nextDouble() * 10, vTail: '배'),
                const SizedBox(height: 5),
                rowItem(key: '외국인', value: ran.nextDouble() * 100, vTail: '%'),
                rowItem(key: '신용', value: ran.nextDouble(), vTail: '%'),
                const SizedBox(height: 5),
                rowItem(key: '체결합'),
                rowItem(key: '매도', value: ran.nextInt(10000000), vColor: BLUE),
                rowItem(key: '매수', value: ran.nextInt(10000000), vColor: RED),
                rowItem(
                    key: '체결강도',
                    value: ran.nextDouble() * 100,
                    vTail: '%',
                    vColor: RED),
              ]))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          // 전체화면 만듦
          (showTop) ? InkWell(
            onTap: () {
              Get.dialog(TenHoga());
              // showDialog(context: context, builder: (context) => TenHoga(),);
            },
            child: Container(
              height: 40,
              color: BLUE,
              child: const Center(
                child: Text(
                  "10호가",
                  style: TextStyle(color: WHITE, fontSize: 14),
                ),
              ),
            ),
          ) : Container(),
          Expanded(
            child: InkWell(
              onTap: () {
                controller.hogaPage_rightTopTabIdx.value =
                    ++controller.hogaPage_rightTopTabIdx.value % tabCnt;
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                child: Obx(() {
                  switch (controller.hogaPage_rightTopTabIdx.value) {
                    case 0:
                      return firstTab();
                    case 1:
                      return secondTab();
                    case 2:
                      return thirdTab();
                    default:
                      controller.hogaPage_rightTopTabIdx.value = 0;
                      return firstTab();
                  }
                }),
              ),
            ),
          ),
          Builder(builder: (context) {
            final width = context.width / 3 / 3;
            // print(Get.width); // 전체화면 너비
            // print(context.width); // 전체화면 너비
            // print(context.width/3);
            // print(width);
            return SizedBox(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    tabCnt,
                    (idx) => Obx(() => ColoredSignBox(
                        idx == controller.hogaPage_rightTopTabIdx.value))),
              ),
            );
          }),
        ],
      ),
    );
  }
}
