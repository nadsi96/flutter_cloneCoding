import 'dart:math';
import 'dart:ui';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/main/main_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

import 'data/hoga_data.dart';
import 'data/produce_hoga_data.dart';
import 'section_left_bottom.dart';
import 'section_right_top.dart';
import 'widget_table.dart';

class Hoga extends StatelessWidget {
  final controller = Get.find<MainController>();
  final ScrollController scrollController = ScrollController();
  final double cellHeight = 40.0;
  final double cellBigFont = 18.0;
  final double cellSmallFont = 14;
  bool isInitScroll = true;

  Hoga({Key? key}) : super(key: key) {
    print("HogaPage Constructor");
    controller.hogaPage_setHoga(ProduceHogaData(), controller.getSelectedStockData().price ?? 0);
    // dataListening();
  }

  /// 호가 테이블 하단
  ///
  /// 정규장 / 시간외종가 / 시간외단일가
  ///
  Widget bottomBar() {
    final sideTextStyle = TextStyle(fontSize: cellBigFont, color: BLACK);
    final sideDeco = BoxDecoration(
      color: LIGHTGRAY,
      border: Border.all(color: GRAY, width: 0.5),
    );

    return Container(
      height: cellHeight,
      decoration: BoxDecoration(
        border: Border.all(color: GRAY, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              decoration: sideDeco,
              padding: const EdgeInsets.all(10),
              child: Text("0", style: sideTextStyle),
              // child: Obx(() => Text())
            ),
          ),
          // 정규장/시간외종가/시간외단일가
          Expanded(
            flex: 3,
            child: Obx(()
            {
              final bidx = controller.hogaPage_bottomIdx.value;

              return InkWell(
                onTap: (){
                  controller.hogaPage_bottomBarClick();
                  print("hogaPage_bottomBarClick()");
                  controller.hogaPage_setHoga(ProduceHogaData(), controller.getSelectedStockData().price ?? 0);
                  print("setHoga");
                },
                child: Stack(
                  children: [
                    Center(
                      child: Text(controller.hogaPage_bottomList[controller.hogaPage_bottomIdx.value], style: const TextStyle(color: BLACK, fontSize: 14)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(controller.hogaPage_bottomList.length, (idx) => ColoredSignBox(bidx== idx)),
                      )
                    )
                  ]
                )
              );
            }),
          ),
          Expanded(
              flex: 2,
              child: Container(
                  alignment: Alignment.centerRight,
                  decoration: sideDeco,
                  padding: const EdgeInsets.all(10),
                  child: Text("0", style: sideTextStyle)))
        ],
      ),
    );
  }

  Future<void> dataListening() async {
    final ran = Random();

    final delay = ran.nextInt(10);
    await Future.delayed(Duration(seconds: delay), () {
      controller.hogaPage_setHoga(ProduceHogaData(),controller.getSelectedStockData().price ?? 0);
    });
  }

  /// 화면 처음 열 때, 스크롤을 가운데로 이동
  void scrollToCenter() {
    if (scrollController.hasClients && isInitScroll) {
      isInitScroll = false;
      scrollController.jumpTo(scrollController.position.maxScrollExtent / 2);
    }
  }

  /// 잔량 / 호가,대비 / ( )
  /// ()  / 호가,대비 / 잔량
  ///  2 : 3 : 2
  @override
  Widget build(BuildContext context) {
    // 화면 그려지고 난 뒤 동작
    // 스크롤 가운데로 이동
    WidgetsBinding.instance!.addPostFrameCallback((_) => scrollToCenter());

    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                children: [
                  // 매도 호가
                  Expanded(
                    flex: 5,
                    child: Obx(() {
                      final sellData = controller.hogaPage_sellHoga.value;
                      return Column(
                        children: List.generate(
                            sellData.length, (idx) => sellRow(sellData[idx], cellHeight)),
                      );
                    }),
                  ),
                  // 오른쪽 위
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: cellHeight * 10,
                      child: RightTopSection(),
                    ),
                  )
                ],
              ),
              // 아래
              Row(
                children: [
                  // 왼쪽 아래
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: cellHeight * 10,
                      child: LeftBottomSection(),
                    ),
                  ),
                  // 매수 호가
                  Expanded(
                    flex: 5,
                    child: Obx(() {
                      final buyData = controller.hogaPage_buyHoga.value;
                      return Column(
                        children: List.generate(
                            buyData.length, (idx) => buyRow(buyData[idx], cellHeight)),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomBar(),
    ]);
  }
}