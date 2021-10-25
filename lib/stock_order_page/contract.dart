import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/controllers/stock_order_controller.dart';
import 'package:flutter_prac_jongmock/data/stock_order_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final double checkboxWidth = 40;
  final double smallCellWidth = 120;
  final double bigCellWidth = 200;

  // final double cellFontSize = 16;

  final tableHeaderFontStyle = const TextStyle(color: BLACK, fontSize: 12);
  final tableFontStyle = const TextStyle(color: BLACK, fontSize: 16);
  final tableBorder = const Border(
      right: BorderSide(color: GRAY), bottom: BorderSide(color: GRAY));

  bool initState = true;

  Contract({Key? key}) : super(key: key) {
    stockOrderController.setContractData(orderstockList);
  }

  Color getColor(String type) {
    if (type.contains('매도')) {
      return BLUE;
    } else if (type.contains('매수')) {
      return RED;
    } else {
      return BLACK;
    }
  }

  Widget top() {
    const double width = 100;
    const double height = 40;
    const double fontSize = 14;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              stockOrderController.setContractState(false);
            },
            child: Obx(() => BlueGrayButton(
                text: '미체결',
                height: height,
                width: width,
                fontSize: fontSize,
                isSelected: !stockOrderController.contractState.value)),
          ),
          InkWell(
            onTap: () {
              stockOrderController.setContractState(true);
            },
            child: Obx(() => BlueGrayButton(
                text: '체결',
                height: height,
                width: width,
                fontSize: fontSize,
                isSelected: stockOrderController.contractState.value)),
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
            Obx(
              () => (stockOrderController.contractState.value)
                  ? singleHeader('종목', bigCellWidth)
                  : Row(
                      children: [
                        singleHeader('선택', checkboxWidth),
                        singleHeader('종목', bigCellWidth),
                      ],
                    ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
            ),
          ],
        ), // header
        Expanded(
          child: Obx(() {
            print(stockOrderController.contractData.value);
            if (stockOrderController.contractData.value.isEmpty) {
              print('helloooooooooooooooooooo');
              print(stockOrderController.contractData.value);
              // 데이터가 없는 경우
              // table body 중앙에 메시지
              return Container(
                margin: const EdgeInsets.only(top: 30),
                alignment: Alignment.topCenter,
                child: const Text(
                  '해당조회 내역이 없습니다.',
                  style: TextStyle(
                      fontSize: 12,
                      color: DARKGRAY,
                      fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return Row(
                // body
                children: [
                  // 1열
                  Obx(() {
                    final double totalSize = checkboxWidth + bigCellWidth;
                    final dataList = stockOrderController.contractData.value;

                    return (stockOrderController.contractState.value)
                        ? SizedBox(
                            width: bigCellWidth,
                            child: ListView.builder(
                              // 체결 선택
                              // head = 종목
                              controller: firstColScrollController,
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                final data = dataList[index];
                                return doubleItemCell(
                                  top: data.stock,
                                  bottom: data.contractType,
                                  topAlign: TextAlign.left,
                                  bottomAlign: TextAlign.left,
                                  width: bigCellWidth,
                                  topStyle: tableFontStyle,
                                  bottomStyle: TextStyle(
                                      fontSize: 12,
                                      color: getColor(data.contractType)),
                                );
                              },
                            ),
                          )
                        : SizedBox(
                            // 미체결 선택
                            // head = 선택 / 종목
                            width: totalSize,
                            child: ListView.builder(
                              controller: firstColScrollController,
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                final data = dataList[index];
                                return Row(
                                  children: [
                                    InkWell(
                                      onTap: () => stockOrderController
                                          .selectContract(index),
                                      child: Container(
                                        height: tableCellHeight,
                                        width: checkboxWidth,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: tableBorder,
                                          // color: LIGHTGRAY,
                                        ),
                                        child: Obx(
                                              () => CircleAvatar(
                                            backgroundColor:
                                            (stockOrderController
                                                .selectedcontractDataIdxs
                                                .value
                                                .contains(index))
                                                ? BLUE
                                                : GRAY,
                                            radius: 10,
                                            child: const Icon(Icons.check,
                                                size: 15, color: WHITE),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: doubleItemCell(
                                        top: data.stock,
                                        bottom: data.contractType,
                                        topAlign: TextAlign.left,
                                        bottomAlign: TextAlign.left,
                                        width: bigCellWidth,
                                        topStyle: tableFontStyle,
                                        bottomStyle: TextStyle(
                                            fontSize: 12,
                                            color: getColor(data.contractType)),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                  }),
                  // 나머지 열
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: bodyScrollController,
                      child: SizedBox(
                        width: smallCellWidth * 3 + bigCellWidth,
                        child: Obx(() {
                          final data = stockOrderController.contractData.value;
                          return ListView(
                            controller: restColScrollController,
                            children: List.generate(
                                data.length, (idx) => getRow(data[idx])),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
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
      child: Text(text, style: tableHeaderFontStyle),
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
          Text(top, style: tableHeaderFontStyle),
          Text(bottom, style: tableHeaderFontStyle),
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
            top: data.orderTime,
            bottom: '#${data.orderNum}',
            width: bigCellWidth,
            topAlign: TextAlign.center),
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

  /// 항목 하나인 table cell
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

  /// 항목 2개인 table cell
  Widget doubleItemCell({
    required String top,
    required String bottom,
    required double width,
    TextAlign topAlign = TextAlign.right,
    TextAlign bottomAlign = TextAlign.right,
    TextStyle? topStyle,
    TextStyle? bottomStyle,
  }) {
    return Container(
      height: tableCellHeight,
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        border: tableBorder,
        color: WHITE,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(top, style: topStyle ??= tableFontStyle, textAlign: topAlign),
          Text(bottom,
              style: bottomStyle ??= tableFontStyle, textAlign: bottomAlign),
        ],
      ),
    );
  }

  void showToastMsg() {
    Fluttertoast.showToast(
      msg: "일괄취소주문은 최대 30건까지 가능합니다.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => showToastMsg());
    return Column(children: [
      top(),
      Expanded(
        child: table(),
      ),
    ]);
  }
}
