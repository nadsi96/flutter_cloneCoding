import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/controllers/stock_order_controller.dart';
import 'package:get/get.dart';

import 'commons.dart';
import 'dialogs.dart';

class Buy extends StatelessWidget {
  final mainController = Get.find<MainController>();
  final stockOrderController = Get.find<StockOrderController>();

  /// 탭 바뀔 때 상태 초기화
  Buy({Key? key}) : super(key: key) {
    stockOrderController.clearState();
  }

  Color getColor() {
    final title = stockOrderController
        .tabList[stockOrderController.tabIdx.value];

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
                  final title = stockOrderController.tabList[
                  stockOrderController.tabIdx.value];
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
                          stockOrderController.payIdx.value = idx,
                          child: BlueGrayButton(
                            isSelected:
                                (stockOrderController.payIdx.value ==
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
                      (stockOrderController.marketPrice.value)
                          ? '시장가'
                          : '보통';
                  return tradeType(text: text, dialog: tradeTypeDialog());
                }), // 구분
                Row(
                  // 주식 수량
                  children: [
                    Expanded(
                      flex: 7,
                      child: InkWell(
                        onTap: () => Get.bottomSheet(InsertValDialog('수량')),
                        child: Obx(
                          () => titleContent(
                            title: '수량',
                            titleColor: getColor(),
                            content: stockOrderController.orderCount.value,
                            // stockOrderController.getOrderCount(),
                          ),
                        ),
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
                      child: InkWell(
                        onTap: () => Get.bottomSheet(InsertValDialog('단가')),
                        child: Obx(() => titleContent(
                              title: '단가',
                              titleColor: getColor(),
                              bgColor: stockOrderController.showPrice()
                                  ? LIGHTGRAY
                                  : LLIGHTGRAY,
                              content: stockOrderController.orderPrice.value,
                              // stockOrderController.getOrderPrice(),
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          stockOrderController.marketPrice.toggle();
                          final flag = stockOrderController.marketPrice.value;
                          stockOrderController.tradeType.value =
                              (flag)
                                  ? '시장가'
                                  : '보통';
                          if(flag){
                            stockOrderController.orderPrice.value = '';
                            stockOrderController.tradeType.value = '시장가';
                          }else{
                            stockOrderController.tradeType.value = '보통';
                          }
                        },
                        child: Obx(
                          () => checkBoxText('시장',
                              stockOrderController.marketPrice.value),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  // 금액
                  children: [
                    Obx(
                      () => (stockOrderController.showPrice())
                          ? const Spacer(flex: 7)
                          : Expanded(
                              flex: 7,
                              child: InkWell(
                                onTap: () =>
                                    Get.bottomSheet(InsertValDialog('금액')),
                                child: titleContent(
                                    title: '금액',
                                    titleColor: getColor(),
                                    content: stockOrderController.orderTotal.value,),
                              ),
                            ),
                    ),
                    Obx(() {
                      if (stockOrderController.tabIdx.value == 0) {
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
            final count = stockOrderController.orderCount.value;
            final price = stockOrderController.orderCount.value;
            String? errorText = null;
            if (count == 0) {
              errorText = '주문 수량을 입력해주세요';
            } else if (price == 0 &&
                !stockOrderController.showPrice()) {
              errorText = '주문 단가를 입력해주세요';
            }
            if (errorText != null) {
              Get.bottomSheet(orderErrorDialog(errorText));
            } else {
              Get.bottomSheet(
                CheckOrderDialog(
                  title:
                      '현금${stockOrderController.tabList[stockOrderController.tabIdx.value]}',
                  account: '631202-04-091716',
                  stock: mainController.getSelectedStock(),
                  type: stockOrderController.tradeType.value,
                  count: stockOrderController.orderCount.value,
                  unitPrice: stockOrderController.orderPrice.value,
                  totalPrice: stockOrderController.orderTotal.value,
                ),
              );
            }
          },
          child: Obx(() {
            return Container(
              color: getColor(),
              height: 50,
              alignment: Alignment.center,
              child: Text(
                '현금${stockOrderController.tabList[stockOrderController.tabIdx.value]}',
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
