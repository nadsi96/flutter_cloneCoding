import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/controllers/stock_order_controller.dart';
import 'package:flutter_prac_jongmock/data/stock_order_data.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class Contract extends StatelessWidget {
  final stockOrderController = Get.find<StockOrderController>();

  // 수평 스크롤
  // 1행, 나머지행 스크롤 연결
  final LinkedScrollControllerGroup horizontalScrollController =
      LinkedScrollControllerGroup();
  late final ScrollController headScrollController =
      horizontalScrollController.addAndGet();
  late final ScrollController bodyScrollController =
      horizontalScrollController.addAndGet();

  // 수직 컨트롤
  // ~종목열, 나머지열 스크롤 연결
  final LinkedScrollControllerGroup verticalScrollController =
      LinkedScrollControllerGroup();
  late final ScrollController firstColScrollController =
      verticalScrollController.addAndGet();
  late final ScrollController restColScrollController =
      verticalScrollController.addAndGet();

  final double tableHeaderHeight = 50;
  final double tableCellHeight = 60;
  final double smallCellWidth = 120;
  final double bigCellWidth = 200;

  // final double cellFontSize = 16;

  final tableFontStyle = const TextStyle(color: BLACK, fontSize: 16);
  final tableBorder = const Border(
      right: BorderSide(color: GRAY), bottom: BorderSide(color: GRAY));

  Widget top() {
    const double width = 100;
    const double height = 40;
    const double fontSize = 14;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: BlueGrayButton(
                text: '미체결',
                height: height,
                width: width,
                fontSize: fontSize,
                isSelected: true),
          ),
          InkWell(
            onTap: () {},
            child: BlueGrayButton(
                text: '체결',
                height: height,
                width: width,
                fontSize: fontSize,
                isSelected: false),
          ),
          const Spacer(),
          InkWell(
            onTap: () {},
            child: Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: DEEPBLUE),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '일괄취소',
                style: TextStyle(color: DEEPBLUE, fontSize: fontSize),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget table() {
    return Column(
      children: [
        Row(
          // header
          children: [
            Obx(() => (stockOrderController.contractState.value)
                ? Row(children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: tableHeaderHeight,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: tableBorder,
                          color: LIGHTGRAY,
                        ),
                        child: CircleAvatar(
                          backgroundColor: BLUE,
                          radius: 15,
                        ),
                      ),
                    ),
                    singleHeader('종목', smallCellWidth)
                  ])
                : singleHeader('종목', smallCellWidth)),
            SingleChildScrollView(
              controller: headScrollController,
              child: Row(
                children: [
                  doubleHeader('주문수량', '주문단가', smallCellWidth),
                  doubleHeader('미체결수량', '체결수량', smallCellWidth),
                  doubleHeader('주문시간', '주문번호', bigCellWidth),
                  Obx(() => (stockOrderController.contractState.value)
                      ? singleHeader('주문구분', smallCellWidth)
                      : doubleHeader('주문구분', '체결단가', smallCellWidth)),
                ],
              ),
            ),
          ],
        ), // header
        Row(
          // body
          children: [
            // 1열
            // 나머지 열
          ],
        ),
      ],
    );
  }

  Widget singleHeader(String text, double width) {
    return Container(
      height: tableHeaderHeight,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: tableBorder,
        color: LIGHTGRAY,
      ),
      child: Text(text, style: tableFontStyle),
    );
  }

  Widget doubleHeader(String top, String bottom, double width) {
    return Container(
      height: tableHeaderHeight,
      width: width,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: tableBorder,
        color: LIGHTGRAY,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(top, style: tableFontStyle),
          Text(bottom, style: tableFontStyle),
        ],
      ),
    );
  }

  Widget getRow(OrderedStock data) {
    return Row(
      children: [
        doubleItemCell(
            top: data.orderCount,
            bottom: data.orderUnitPrice,
            width: smallCellWidth),
        // 주문수량/주문단가
        doubleItemCell(
            top: data.waiting, bottom: data.done, width: smallCellWidth),
        // 미체결수량/체결수량
        doubleItemCell(
            top: data.orderTime, bottom: data.orderNum, width: bigCellWidth),
        // 주문시간, 주문번호
        (stockOrderController.contractState.value) // 미체결 조회는 주문구분만 조회
            ? doubleItemCell(
                top: data.type,
                bottom: data.contractPrice,
                width: smallCellWidth)
            : singleItemCell(text: data.type, width: smallCellWidth),
        // 주문구분/(체결단가)
      ],
    );
  }

  Widget singleItemCell({required String text, required double width}) {
    return Container(
      height: tableCellHeight,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: tableBorder,
        color: WHITE,
      ),
      child: Text(text, style: tableFontStyle),
    );
  }

  Widget doubleItemCell(
      {required String top,
      required String bottom,
      required double width,
      TextAlign topAlign = TextAlign.right,
      TextAlign bottomAlign = TextAlign.right}) {
    return Container(
      height: tableCellHeight,
      width: width,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: tableBorder,
        color: WHITE,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(top, style: tableFontStyle, textAlign: topAlign),
          Text(bottom, style: tableFontStyle, textAlign: bottomAlign),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      top(),
      Expanded(
        child: table(),
      ),
    ]);
  }
}
