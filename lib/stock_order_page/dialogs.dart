import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

Widget tradeTypeDialog() {
  final mainController = Get.find<MainController>();
  final texts = ['보통', '시장가', '장전시간외', '장후시간외', '시간외단일가', '최유리지정가', '최우선지정가'];
  return Container(
    height: 300,
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5), topRight: Radius.circular(5)),
        color: WHITE),
    padding: const EdgeInsets.all(20),
    child: Scrollbar(
      child: ListView.builder(
        itemCount: texts.length * 2 - 1,
        itemBuilder: (BuildContext context, int index) {
          if (index.isOdd) {
            return const Divider(
              thickness: 1,
              height: 1,
              color: GRAY,
            );
          } else {
            final idx = index ~/ 2;
            return Obx(() {
              final selected = mainController.stockOrderPage_tradeType.value;
              final flag = texts[idx] == selected;
              return ListTile(
                onTap: () => Get.back(result: texts[idx]),
                title: Text(
                  texts[idx],
                  style: TextStyle(color: flag ? BLUE : BLACK, fontSize: 14),
                ),
                trailing: flag
                    ? const Icon(Icons.check, color: BLUE, size: 25)
                    : null,
              );
            });
          }
        },
      ),
    ),
  );
}

Widget orderErrorDialog(String msg) {
  return SizedBox(
    height: 150,
    child: Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: const BoxDecoration(
                color: WHITE,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            padding: const EdgeInsets.only(left: 30),
            alignment: Alignment.centerLeft,
            child:
                Text(msg, style: const TextStyle(fontSize: 14, color: BLACK)),
          ),
        ),
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              color: BLUE,
              alignment: Alignment.center,
              height: 50,
              child: const Text('닫기',
                  style: TextStyle(color: WHITE, fontSize: 16)),
            ),
          ),
        ),
      ],
    ),
  );
}

/// 주문 수량/단가/금액 입력 다이얼로그
/// tab - 클릭한 박스(수량/단가/금액)
class InsertValDialog extends StatelessWidget {
  final controller = Get.find<MainController>();
  final double dialogHeight = 420; // 다이얼로그 화면 높이
  late final previous_data; // 다이얼로그 열기 전 입력되어있던 값
  List<String> tabTexts = []; // 상단 탭 텍스트
  InsertValDialog(String tab, {Key? key}) : super(key: key) {
    controller.stockOrderPage_insertTab.value = tab;
    previous_data = [
      controller.stockOrderPage_orderCount.value,
      controller.stockOrderPage_orderPrice.value
    ]; // 기존 입력되어있던 값

    tabTexts =
        controller.stockOrderPage_showPrice() ? ['수량'] : ['수량', '단가', '금액'];
  }

  /// 주문 수량/단가/금액 입력 텍스트박스 오른쪽
  /// 수량/단가인 경우 +-버튼
  /// 금액인 경우, 현재 단가와 입력된 금액에 따른 주식 수량
  Widget incre_decre_btn() {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      height: 80,
      width: 100,
      decoration:
          BoxDecoration(color: WHITE, borderRadius: BorderRadius.circular(3)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => controller.stockOrderPage_insertDialog_increBtn(),
              child: const DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: LIGHTGRAY))),
                  child: Icon(Icons.add, size: 30, color: BLACK)),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => controller.stockOrderPage_insertDialog_decreBtn(),
              child: const Icon(Icons.remove, size: 30, color: BLACK),
            ),
          ),
        ],
      ),
    );
  }

  Widget show_price_count() {
    return Container();
  }

  /// 숫자판 버튼
  Widget numberBtns() {
    final selected = controller.stockOrderPage_insertTab.value;

    var items = List.generate(9, (idx) => '${idx + 1}');
    items.addAll(['00', '0']);

    // 1 ~ 9, 00, 0
    List<Widget> itemViews = List.generate(
        items.length,
        (idx) => InkWell(
              onTap: () => controller.stockOrderPage_numBtn(items[idx]),
              child: _itemView(items[idx]),
            ));

    // 마지막에 000(수량/금액) or 현재가(단가)
    itemViews.add(
      Obx(() {
        if (controller.stockOrderPage_insertTab.value == '단가') {
          return (InkWell(
            onTap: () => controller.stockOrderPage_orderPrice.value =
                controller.getSelectedStockData().getPriceInt(),
            child: _itemView('현재가'),
          ));
        } else {
          return (InkWell(
            onTap: () => controller.stockOrderPage_numBtn('000'),
            child: _itemView('000'),
          ));
        }
      }),
    );

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: itemViews[0],
              ),
              Expanded(
                child: itemViews[1],
              ),
              Expanded(
                child: itemViews[2],
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: itemViews[3],
              ),
              Expanded(
                child: itemViews[4],
              ),
              Expanded(
                child: itemViews[5],
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: itemViews[6],
              ),
              Expanded(
                child: itemViews[7],
              ),
              Expanded(
                child: itemViews[8],
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: itemViews[9],
              ),
              Expanded(
                child: itemViews[10],
              ),
              Expanded(
                child: itemViews[11],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 숫자판 한 칸
  Widget _itemView(String text) {
    return Container(
      alignment: Alignment.center,
      color: WHITE,
      margin: const EdgeInsets.only(bottom: 5, right: 5),
      child: Text(text,
          style: const TextStyle(
              fontSize: 24, color: BLUE, fontWeight: FontWeight.bold)),
    );
  }

  /// 숫자판 옆
  /// [백스페이스, []]
  Widget rightOfNumPad() {
    return Column(
      children: [
        Expanded(
          // 백스페이스버튼
          child: InkWell(
            onTap: () {
              controller.stockOrderPage_eraseBtn();
            },
            child: Container(
              alignment: Alignment.center,
              color: WHITE,
              margin: const EdgeInsets.only(bottom: 5, right: 5),
              child: const Icon(Icons.backspace, color: GRAY, size: 30),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(width: 120),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: dialogHeight,
      color: GRAY,
      child: Column(
        children: [
          Row(
            /// [수량, 단가, 금액] 탭
            children: List.generate(
              tabTexts.length,
              (idx) => Expanded(
                child: InkWell(
                  onTap: () {
                    controller.stockOrderPage_insertTab.value = tabTexts[idx];
                  },
                  child: Obx(() {
                    Color bgColor = WHITE;
                    Color fontColor = BLACK;
                    if (controller.stockOrderPage_insertTab.value ==
                        tabTexts[idx]) {
                      bgColor = DARKBLUE;
                      fontColor = WHITE;
                    }
                    return Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: bgColor,
                          border: const Border(
                              right: BorderSide(color: LLIGHTGRAY))),
                      alignment: Alignment.center,
                      child: Text(tabTexts[idx],
                          style: TextStyle(
                              color: fontColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    );
                  }),
                ),
              ),
            ),
          ),
          Container(
            /// 입력창, +- 버튼
            height: 70,
            color: BLUE,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() {
                  final selected = controller.stockOrderPage_insertTab.value;

                  String text;
                  if (selected == '단가') {
                    /// 단가를 클릭했는데, 입력해뒀던 내용이 없다면
                    /// text를 현재가로 초기화
                    /// 있으면 있던거 넣
                    if (controller.stockOrderPage_getOrderPrice() == '') {
                      controller.stockOrderPage_orderPrice.value =
                          controller.getSelectedStockData().getPriceInt();
                    }
                    text = controller.stockOrderPage_getOrderPrice();
                  } else if (selected == '수량') {
                    // 수량 클릭한 경우
                    text = controller.stockOrderPage_getOrderCount();
                  } else {
                    text = controller.stockOrderPage_getOrderTotal();
                  }

                  String unit;
                  if (selected == '수량') {
                    unit = '주';
                  } else {
                    unit = '원';
                  }

                  return Expanded(
                    /// 주식수량/금액 입력
                    flex: (selected == '금액') ? 5 : 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: WHITE, borderRadius: BorderRadius.circular(3)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              text,
                              style: const TextStyle(
                                  color: BLACK,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                            // child: (selected == '금액')
                            //     ? FittedBox(
                            //         fit: BoxFit.scaleDown,
                            //         child: Text(
                            //           text,
                            //           style: const TextStyle(
                            //               color: BLACK,
                            //               fontSize: 26,
                            //               fontWeight: FontWeight.bold),
                            //           textAlign: TextAlign.end,
                            //           maxLines: 1,
                            //           overflow: TextOverflow.fade,
                            //         ),
                            //       )
                            //     : Text(
                            //         text,
                            //         style: const TextStyle(
                            //             color: BLACK,
                            //             fontSize: 26,
                            //             fontWeight: FontWeight.bold),
                            //         textAlign: TextAlign.end,
                            //         maxLines: 1,
                            //         overflow: TextOverflow.fade,
                            //       ),
                          ), // 수량/원 입력칸
                          Text(unit, style: const TextStyle(fontSize: 14)),
                          InkWell(
                            onTap: () => controller.stockOrderPage_clearText(),
                            child:

                                /// 입력한 내용 지우기 버튼. 0보다 크면 나타남
                                ((selected == '수량' &&
                                            controller.stockOrderPage_orderCount
                                                    .value >
                                                0) ||
                                        (selected == '단가' &&
                                            controller.stockOrderPage_orderPrice
                                                    .value >
                                                0) ||
                                        (selected == '금액' &&
                                            controller.stockOrderPage_orderTotal
                                                    .value >
                                                0))
                                    ? Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: const Icon(Icons.cancel,
                                            size: 20, color: LIGHTGRAY))
                                    : Container(),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                Obx(
                  () {
                    final flag =
                        (controller.stockOrderPage_insertTab.value == '금액');
                    return Expanded(
                      flex: flag ? 3 : 1,
                      child: flag ? show_price_count() : incre_decre_btn(),
                    );
                  }, // 수량/단가 - +- 버튼, 금액 - 설정한 단가, 입력한 금액에 따른 수량 출력하는 박스
                ),
              ],
            ),
          ),
          Expanded(
            /// 숫자버튼
            child: Padding(
              padding: const EdgeInsets.only(left: 5, top: 5),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: numberBtns(),
                  ),
                  Expanded(
                    child: rightOfNumPad(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            /// 취소/확인
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.stockOrderPage_orderCount.value =
                          previous_data[0]; // 다이얼로그 열 때, 수량
                      controller.stockOrderPage_orderPrice.value =
                          previous_data[1]; // 다이얼로그 열 때, 단가

                      Get.back();
                    },
                    child: Container(
                      color: DARKGRAY,
                      alignment: Alignment.center,
                      child: const Text('취 소',
                          style: TextStyle(color: WHITE, fontSize: 18)),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Container(
                      color: BLUE,
                      alignment: Alignment.center,
                      child: const Text('확 인',
                          style: TextStyle(color: WHITE, fontSize: 18)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 매수/매도/정정 확인
/// title - 0 - 현금매수/ 1 - 현금매도/ 2 - 정정
/// account - 계좌
/// stock - 종목명
/// count - 수량
/// unitPrice - 단가
/// totalPrice - 금액
/// type - 구분
class CheckOrderDialog extends StatelessWidget {
  final String title;
  final String account;
  final String stock;
  final String count;
  final String unitPrice;
  final String totalPrice;
  final String type;

  final double dialogHeight = 450;
  final double dialogTitleHeight = 50;
  final double contentHeight = 40;
  final double metaExplainHeight = 50;
  final double btnHeight = 50;

  final basicStyle = const TextStyle(fontSize: 16);
  final divider = const Divider(
    thickness: 1,
    height: 1,
    color: GRAY,
  );

  const CheckOrderDialog(
      {Key? key,
      required this.title,
      required this.account,
      required this.stock,
      this.count = '',
      this.unitPrice = '',
      this.totalPrice = '',
      required this.type})
      : super(key: key);

  Color getColor() {
    switch (title) {
      case '현금매수':
        return RED;
      case '현금매도':
        return BLUE;
      default:
        return GREEN;
    }
  }

  /// 다이얼로그 타이틀
  Widget titleText() {
    return Container(
      height: dialogTitleHeight,
      alignment: Alignment.center,
      child: Text(title,
          style: TextStyle(
              color: getColor(), fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget contentsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        children: [
          _contentRowItem('계좌', account, basicStyle),
          _contentRowItem('종목', stock, basicStyle),
          _contentRowItem(
            '수량',
            count.isNotEmpty ? '$count 주' : '',
            const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          _contentRowItem(
            '단가',
            unitPrice.isNotEmpty ? '$unitPrice 원' : '',
            TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: getColor(),
            ),
          ),
          _contentRowItem('금액', (totalPrice.isNotEmpty) ? '$totalPrice 원' : '', basicStyle),
          _contentRowItem('구분', type, basicStyle),
          divider,
        ],
      ),
    );
  }

  /// 오른쪽 - 타이틀, 회색바탕
  /// 왼쪽  - 내용, 흰 바탕
  /// 중간, 위에 테두리가 있는 행
  Widget _contentRowItem(String title, String content, TextStyle contentStyle) {
    const borderSide = BorderSide(color: GRAY);
    return SizedBox(
      height: contentHeight,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(top: borderSide, right: borderSide),
                color: LIGHTGRAY,
              ),
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(top: borderSide),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                content,
                style: contentStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget metaExplain(){
    final String orderType;
    final String extra;
    const extra1 = '※ 증거금 100% 계좌인 경우에도 제비용(수수료/세금)\n 은 증거금에 포함되지 않아 이로 인한 미수금이\n 발생할 수 있습니다.';
    const extra2 = '※ ETN/ETF 매매시 괴리율에 주의하시기 바랍니다.';

    switch (title) {
      case '현금매수':
        orderType = '매수';
        extra = '$extra1\n$extra2';
        break;
      case '현금매도':
        orderType = '매도';
        extra = extra2;
        break;
      default:
        orderType = title;
        if(title == '정정'){
          extra = extra1;
        }else{
          extra = '';
        }
        break;
    }
    final top = Text('위 내용으로 $orderType주문을 실행합니다.', style: const TextStyle(fontSize: 14));
    final bottom = Text(extra, style: const TextStyle(color: RED, fontSize: 12), textAlign: TextAlign.left);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        top,
        bottom
      ]
    );

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: dialogHeight,
      color: WHITE,
      child: Column(
        children: [
          titleText(),
          divider,
          contentsSection(),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 40,
              maxHeight: 100,
            ),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: metaExplain(),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: cancelBtn(),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: okBtn(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
