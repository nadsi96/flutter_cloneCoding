import 'dart:math';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/hoga/section_left_bottom.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/hoga/section_right_top.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

import 'data/hoga_data.dart';
import 'widget_table.dart';

/// 주식현재가 - 호가에서 10호가 버튼 클릭시 나타날 화면
/// Obx 문제 (테이블 오른쪽 상단, 왼쪽 하단 내용
///
class TenHoga extends StatelessWidget {
  final double topBarHeight = 40;
  final border = Border.all(color: LIGHTGRAY, width: 1);

  final double tableBigFont = 16;
  final double tableSmallFont = 14;

  final double cellHeight = 25;
  final double cellBigFont = 16;
  final double cellSmallFont = 14;

  final controller = Get.find<MainController>();

  late final int rightTopTabIdx; // 테이블 오른쪽 상단 탭 인덱스
  // 화면 닫을 때, controller의 idx 원래대로 돌려주기 위함

  TenHoga({Key? key}) : super(key: key) {
    rightTopTabIdx = controller.hogaPage_rightTopTabIdx.value;
    controller.hogaPage_rightTopTabIdx.value = 0;
  }

  AppBar topBar() {
    return AppBar(
      toolbarHeight: topBarHeight,
      leading: InkWell(
        onTap: () {
          controller.hogaPage_rightTopTabIdx.value = rightTopTabIdx;
          Get.back();
        },
        child: const TitleBarBackButton(color: BLUE),
      ),
      backgroundColor: WHITE,
      titleSpacing: 0,
      shadowColor: TRANSPARENT,
      title: Row(
        children: [
          // 검색창
          Expanded(
            child: Container(
              height: topBarHeight,
              decoration: BoxDecoration(border: border),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: const Icon(Icons.search, color: DARKGRAY),
                  ),
                  Text(
                    controller.getSelectedStock(),
                    style: const TextStyle(color: DARKGRAY, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          // 주식 설명?, 매수,매도 버튼
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  // 주식 설명
                  Container(
                    height: topBarHeight,
                    width: topBarHeight,
                    padding: const EdgeInsets.all(3),
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(border: border),
                    child: Image.asset(
                      'assets/images/i.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: tradeBtn(text: "매수", textColor: RED),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: tradeBtn(text: "매도", textColor: BLUE),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tradeBtn({String text = "", Color textColor = BLACK}) {
    return Container(
      height: topBarHeight,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(color: LLIGHTGRAY, border: border),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 14),
        ),
      ),
    );
  }

  /// 상단바, 테이블 사이
  /// 주식 정보 (현재가, 등략폭, 잔량, 대비)
  Widget stockInfo() {
    final double priceFont = 30;
    final double smallFont = 14;
    final double rateFont = 26;

    return Container(
      height: this.topBarHeight + 10,
      margin: const EdgeInsets.all(10),
      child: Obx(() {
        final stock = controller.getSelectedStockData();

        // 그래프부분 설정
        final imgPath =
            "assets/images/img${(stock.getRate() > 0) ? 1 : (stock.getRate() < 0) ? 2 : 3}.png";

        final icon = (stock.getRate() > 0)
            ? const Icon(Icons.arrow_drop_up_sharp, color: RED)
            : (stock.getRate() < 0)
                ? const Icon(Icons.arrow_drop_down_sharp, color: BLUE)
                : Spacer();
        // 글자 색 설정
        Color fontColor = BLACK;
        if (stock.getRate() > 0) {
          fontColor = RED;
        } else if (stock.getRate() < 0) {
          fontColor = BLUE;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 주식 가격
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: topBarHeight,
                    height: topBarHeight,
                    child: Image.asset(imgPath, fit: BoxFit.fitHeight),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        stock.getPrice(),
                        style: TextStyle(fontSize: priceFont, color: fontColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 등락폭, 잔량, 대비
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // textBaseline: TextBaseline.alphabetic,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            icon, // 등락기호
                            Text(
                              stock.getVarStr(),
                              style: TextStyle(
                                  color: fontColor, fontSize: smallFont),
                            ),
                          ],
                        ),
                        Text(
                          stock.getCount(),
                          style: TextStyle(color: BLACK, fontSize: smallFont),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          stock.getRate().abs().toString(),
                          style:
                              TextStyle(color: fontColor, fontSize: rateFont),
                        ),
                        Text(
                          '%',
                          style:
                              TextStyle(color: fontColor, fontSize: smallFont),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  /// 2 3 2
  ///
  /// 매도호가()
  /// ()매수호가
  Widget table() {
    return Column(
      children: [
        Row(
          children: [
            // 주식 잔량, 호가, 대비
            Expanded(
              flex: 5,
              child: Obx(() {
                var sellData = List.generate(
                    controller.hogaPage_sellHoga.value.length,
                    (idx) => controller.hogaPage_sellHoga.value[idx]);
                sellData.insert(0, null);
                sellData.insert(0, null);
                return Column(
                  children: List.generate(
                      sellData.length,
                      (idx) => sellRow(sellData[idx], cellHeight,
                          cellBigFont: 14, cellSmallFont: 12)),
                );
              }),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: cellHeight * 12,
                decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: GRAY, width: 0.5),
                      right: BorderSide(color: GRAY, width: 0.5)),
                ),
                child: RightTopSection(showTop: false),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: cellHeight * 12,
                decoration: const BoxDecoration(
                  border: Border(
                      left: BorderSide(color: GRAY, width: 0.5),
                      bottom: BorderSide(color: GRAY, width: 0.5)),
                ),
                child: LeftBottomSection(
                  showTop: false,
                ),
              ),
            ),
            // 주식잔량, 호가
            Expanded(
              flex: 5,
              child: Obx(() {
                var buyData = List.generate(
                    controller.hogaPage_buyHoga.value.length,
                    (idx) => controller.hogaPage_buyHoga.value[idx]);
                print("len: ${controller.hogaPage_buyHoga.value.length}");
                buyData.add(null);
                buyData.add(null);
                return Column(
                  children: List.generate(
                      buyData.length,
                      (idx) => buyRow(buyData[idx], cellHeight,
                          cellBigFont: 14, cellSmallFont: 12)),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  /// 테이블 아래부분
  /// 정규장/시간외종가
  Widget bottom() {
    final ran = Random();

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: cellHeight,
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: LIGHTGRAY,
              border: Border.all(color: GRAY, width: 0.5),
            ),
            child: Text(
              formatIntToStr(ran.nextInt(1000000)),
              style: TextStyle(color: BLACK, fontSize: cellSmallFont),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () {
              controller.hogaPage_tenHoga_bottomClick();
            },
            child: Obx(() {
              final text = controller.hogaPage_tenHoga_bottoms[
                  controller.hogaPage_tenHoga_bottomIdx.value];
              return Container(
                height: cellHeight,
                decoration: BoxDecoration(
                  color: WHITE,
                  border: Border.all(color: GRAY, width: 0.5),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        text,
                        style: TextStyle(color: BLACK, fontSize: cellSmallFont),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 5),
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                            controller.hogaPage_tenHoga_bottoms.length,
                            (idx) => ColoredSignBox(idx ==
                                controller.hogaPage_tenHoga_bottomIdx.value)),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: cellHeight,
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: LIGHTGRAY,
              border: Border.all(color: GRAY, width: 0.5),
            ),
            child: Text(
              formatIntToStr(ran.nextInt(1000000)),
              style: TextStyle(color: BLACK, fontSize: cellSmallFont),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                stockInfo(),
                table(),
              ],
            ),
          ),
          bottom(),
        ],
      ),
    );
  }
}
