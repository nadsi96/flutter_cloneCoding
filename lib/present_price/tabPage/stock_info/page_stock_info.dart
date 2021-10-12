import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

/// 주식현재가 - 종목정보
class StockInfo extends StatelessWidget {
  final controller = Get.find<MainController>();
  final data = StockInfoData();

  final fontSize = 12.0;
  final cellHeight = 40.0;

  final border = Border.all(color: GRAY, width: 0.5);

  /// 타이틀 부분
  /// 회색바탕
  Widget title(String item) {
    return Container(
      height: cellHeight,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: LIGHTGRAY,
        border: border,
      ),
      child: Text(
        item,
        style: TextStyle(color: BLACK, fontSize: fontSize),
      ),
    );
  }

  /// 테이블 값부분
  Widget value(String? item, {Color fontColor = BLACK}) {
    return Container(
      height: cellHeight,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: border,
      ),
      child: Text(
        item ?? "",
        style: TextStyle(color: fontColor, fontSize: fontSize),
      ),
    );
  }

  Color getColor(dynamic v) {
    if (v is Color) {
      return v;
    } else {
      if (v is int || v is double) {
        if (v > 0)
          return RED;
        else if (v < 0) {
          return BLUE;
        } else {
          return BLACK;
        }
      } else {
        return BLACK;
      }
    }
  }

  /// 테두리 없는 테이블셀
  Widget itemNoBorder(String item, {dynamic fontColor, bool alignLeft = true}) {
    final Color color = getColor(fontColor);

    return Container(
      // height: cellHeight,
      alignment: (alignLeft) ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.all(10),
      child: Text(
        item,
        style: TextStyle(color: color, fontSize: fontSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.stockInfoPage_setData(data);

    final bgLightgray = BoxDecoration(color: LIGHTGRAY, border: border);
    final bgBorder = BoxDecoration(border: border);

    return Row(
      children: [
        Expanded(
          child: Column(children: [
            Container(
              height: cellHeight * 3,
              decoration: bgLightgray,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  itemNoBorder("거래량"),
                  itemNoBorder("(전일대비)"),
                  itemNoBorder("(전일동시간비)"),
                ],
              ),
            ),
            Container(
              height: cellHeight * 2,
              decoration: bgLightgray,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  itemNoBorder("거래대금"),
                  itemNoBorder("(종합대비)"),
                ],
              ),
            ),
            title("체결강도"),
            title("매수비율"),
            Container(
              height: cellHeight * 2,
              decoration: bgLightgray,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  itemNoBorder("외국인보유"),
                  itemNoBorder("(증감)"),
                ],
              ),
            ),
            title("외국계추정"),
            title('프로그램'),
          ]),
        ),
        Expanded(
          child: Column(
            children: [
              // 거래량, (전일대비), (전일동시간비)
              Container(
                height: cellHeight * 3,
                decoration: bgBorder,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    itemNoBorder(
                        controller.stockInfoPage_data.value.getAmount(),
                        alignLeft: false),
                    itemNoBorder(
                        controller.stockInfoPage_data.value
                            .getCompareYesterday(),
                        alignLeft: false),
                    itemNoBorder(
                        controller.stockInfoPage_data.value
                            .getCompareEqualTime(),
                        alignLeft: false),
                  ],
                ),
              ),
              // 거래대금, (종합대비)
              Container(
                height: cellHeight * 2,
                decoration: bgBorder,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    itemNoBorder(
                        controller.stockInfoPage_data.value.getTradeBal(),
                        alignLeft: false),
                    itemNoBorder(
                        controller.stockInfoPage_data.value
                            .getTotalCompareRate(),
                        alignLeft: false),
                  ],
                ),
              ),
              // 체결강도
              value(controller.stockInfoPage_data.value.getCRate(),
                  fontColor: getColor(
                      controller.stockInfoPage_data.value.dataL["체결강도"])),
              // 매수비율
              value(
                controller.stockInfoPage_data.value.getBuyRate(),
              ),
              // 외국인보유, (증감)
              Container(
                height: cellHeight * 2,
                decoration: bgBorder,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    itemNoBorder(
                        controller.stockInfoPage_data.value.getForeign(),
                        alignLeft: false),
                    itemNoBorder(
                        controller.stockInfoPage_data.value.getIncreDecre(),
                        alignLeft: false,
                        fontColor:
                            controller.stockInfoPage_data.value.dataL["(증감)"]),
                  ],
                ),
              ),
              // 외국계추정
              value(controller.stockInfoPage_data.value.getForeignPred(),
                  fontColor: getColor(
                      controller.stockInfoPage_data.value.dataL["외국계추정"])),
              // 프로그램
              value(controller.stockInfoPage_data.value.getProgram(),
                  fontColor: getColor(
                      controller.stockInfoPage_data.value.dataL["프로그램"])),
            ],
          ),
        ),
        Expanded(
          child: Column(
              children: List.generate(
                  controller.stockInfoPage_data.value.dataR.keys.length,
                  (idx) => title(controller.stockInfoPage_data.value.dataR.keys
                      .elementAt(idx)))),
        ),
        Expanded(
          child: Obx(() {
            return Column(
              children: List.generate(
                  controller.stockInfoPage_data.value.dataR.values.length,
                  (idx) => value(controller
                      .stockInfoPage_data.value.dataR.values
                      .elementAt(idx))),
            );
          }),
        ),
      ],
    );
  }
}

class StockInfoData {
  final ran = Random();

  Map<String, dynamic> dataL = {};
  Map<String, String> dataR = {};


  void setData() {
    dataL = {
      "거래량": ran.nextInt(100000000),
      "(전일대비)": ran.nextDouble() * 100,
      "(전일동시간비)": ran.nextDouble() * 100,
      "거래대금": ran.nextInt(10000000),
      "(종합대비)": ran.nextDouble() * 100,
      "체결강도": ran.nextDouble() * 200 - 100,
      "매수비율": ran.nextDouble() * 100,
      "외국인보유": ran.nextDouble() * 100,
      "(증감)": ran.nextInt(20000000) - 10000000,
      "외국계추정": ran.nextInt(20000000) - 10000000,
      "프로그램": ran.nextInt(2000000) - 1000000,
    };

    dataR = {
      "시가총액": "${formatIntToStr(ran.nextInt(10000000))}억",
      "자본금": "${formatIntToStr(ran.nextInt(10000))}억",
      "상장주식수": getBigInt(),
      "액면가": "${ran.nextInt(100) + 1}원",
      "결산월": "${ran.nextInt(12) + 1}월",
      "PER": "${ran.nextInt(10000) / 100}배",
      "EPS": "${ran.nextInt(10000)}원",
      "PBR": "${formatDoubleToStr(ran.nextDouble() * 10)}배",
      "매출액": "${formatIntToStr(ran.nextInt(10000000))}억",
      "ROE": formatDoubleToStr(ran.nextInt(1000) / 100),
      "배당수익률": formatDoubleToStr(ran.nextInt(1000) / 100)
    };
  }

  String getBigInt() {
    final c = ran.nextInt(5);
    var item = "";
    for (var i = 0; i < c + 5; i++) {
      if (i % 3 == 0 && i > 0) {
        item = ",$item";
      }
      item = ran.nextInt(10).toString() + item;
    }
    print(item);
    return item;
  }

  String getAmount() => formatIntToStr(dataL["거래량"]);

  String getCompareYesterday() => formatDoubleToStr(dataL["(전일대비)"]);

  String getCompareEqualTime() => formatDoubleToStr(dataL["(전일동시간비)"]);

  String getTradeBal() => "${formatIntToStr(dataL["거래대금"])}백만";

  String getTotalCompareRate() => formatDoubleToStr(dataL["(종합대비)"]);

  String getCRate() => formatDoubleToStr(dataL["체결강도"]);

  String getBuyRate() => formatDoubleToStr(dataL["매수비율"]);

  String getForeign() => formatDoubleToStr(dataL["외국인보유"]);

  String getIncreDecre() => formatIntToStr(dataL["(증감)"]);

  String getForeignPred() => formatIntToStr(dataL["외국계추정"]);

  String getProgram() => formatIntToStr(dataL["프로그램"]);
}
