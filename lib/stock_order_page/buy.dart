import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:get/get.dart';

import 'commons.dart';
import 'dialogs.dart';

class Buy extends StatelessWidget {
  final mainController = Get.find<MainController>();

  /// 탭 바뀔 때 상태 초기화
  Buy({Key? key}) : super(key: key) {
    mainController.stockOrderPage_clearState();
  }

  Color getColor() {
    final title = mainController
        .stockOrderPage_tabList[mainController.stockOrderPage_tabIdx.value];

    if (title == '매수') {
      return RED;
    } else if (title == '매도') {
      return BLUE;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          // 현금/신용/(대출상환)버튼
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Obx(() {
                  final title = mainController.stockOrderPage_tabList[
                      mainController.stockOrderPage_tabIdx.value];
                  List<String> btnTexts = [];

                  if (title == '매수') {
                    btnTexts = ['현금', '신용'];
                  } else if (title == '매도') {
                    btnTexts = ['현금', '신용', '대출상환'];
                  } else {}

                  return Row(
                    children: List.generate(
                      btnTexts.length,
                      (idx) => Expanded(
                        child: InkWell(
                          onTap: () =>
                              mainController.stockOrderPage_payIdx.value = idx,
                          child: BlueGrayButton(
                            isSelected:
                                (mainController.stockOrderPage_payIdx.value ==
                                    idx),
                            text: btnTexts[idx],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }), // 현금/신용/(대출상환)버튼
                Obx(() {
                  // 구분
                  String text =
                      (mainController.stockOrderPage_marketPrice.value)
                          ? '시장가'
                          : '보통';
                  return tradeType(text: text, dialog: tradeTypeDialog());
                }), // 구분
                Row(
                  // 주식 수량
                  children: [
                    Expanded(
                      flex: 7,
                      child: Obx(
                        () => titleContent(title: '수량', titleColor: getColor()),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: textBox(text: '가능', width: 70),
                    ),
                  ],
                ),
                Row(
                  // 단가
                  children: [
                    Expanded(
                      flex: 7,
                      child: Obx(
                        () => titleContent(
                            title: '단가',
                            titleColor: getColor(),
                            bgColor: mainController.stockOrderPage_showPrice()
                                ? LIGHTGRAY
                                : LLIGHTGRAY),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          mainController.stockOrderPage_marketPrice.toggle();
                          mainController.stockOrderPage_tradeType.value =
                              (mainController.stockOrderPage_marketPrice.value)
                                  ? '시장가'
                                  : '보통';
                        },
                        child: Obx(
                          () => checkBoxText('시장',
                              mainController.stockOrderPage_marketPrice.value),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  // 금액
                  children: [
                    Obx(
                      () => (mainController.stockOrderPage_showPrice())
                          ? const Spacer(flex: 7)
                          : Expanded(
                              flex: 7,
                              child: titleContent(
                                  title: '금액', titleColor: getColor()),
                            ),
                    ),
                    Obx(() {
                      if (mainController.stockOrderPage_tabIdx.value == 0) {
                        return const Spacer(flex: 3);
                      } else {
                        return Expanded(
                          flex: 3,
                          child: textBox(text: '잔고'),
                        );
                      }
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // 현금 매수/매도
            final count = mainController.stockOrderPage_orderCount.value;
            final price = mainController.stockOrderPage_orderCount.value;
            String? errorText = null;
            if(count == 0){
              errorText = '주문 수량을 입력해주세요';
            }else if(price == 0 && !mainController.stockOrderPage_showPrice()){
              errorText = '주문 단가를 입력해주세요';
            }
            if(errorText != null){
              Get.bottomSheet(orderErrorDialog(errorText));
            }



          },
          child: Obx(() {
            return Container(
              color: getColor(),
              height: 60,
              alignment: Alignment.center,
              child: Text(
                '현금${mainController.stockOrderPage_tabList[mainController.stockOrderPage_tabIdx.value]}',
                style: const TextStyle(
                    color: WHITE, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          }),
        ),
      ],
    );
  }
}
