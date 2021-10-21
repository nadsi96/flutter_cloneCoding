import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/controllers/stock_order_controller.dart';
import 'package:get/get.dart';

import 'commons.dart';
import 'dialogs.dart';

class ModifyOrder extends StatelessWidget {
  final mainController = Get.find<MainController>();
  final stockOrderController = Get.find<StockOrderController>();

  ModifyOrder({Key? key}) : super(key: key) {
    stockOrderController.clearState();
  }

  /// 주문번호 / 미체결
  Widget orderNum() {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: InkWell(
            onTap: () {},
            child: titleContent(
                title: '주문번호', titleColor: GRAY, bgColor: LIGHTGRAY),
          ),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () {},
            child: textBox(text: '미체결', width: double.infinity),
          ),
        ),
      ],
    );
  }

  /// 주문 수량 / 전부 체크버튼
  Widget orderCount() {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: InkWell(
            onTap: () {},
            child: titleContent(title: '수량', titleColor: GREEN),
          ),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () {},
            child: checkBoxText('전부', false),
          ),
        ),
      ],
    );
  }

  /// 주문 단가 / 시장가 체크버튼
  Widget orderPrice() {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: InkWell(
            onTap: () {},
            child: titleContent(title: '단가', titleColor: GREEN),
          ),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () {},
            child: checkBoxText('시장', false),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              orderNum(), // 주문번호/미체결
              Obx(() {
                // 구분
                String text = (stockOrderController.marketPrice.value)
                    ? '시장가'
                    : '보통';
                return tradeType(
                    text: text, dialog: tradeTypeDialog(), margin_top: 0);
              }), // 구분
              orderCount(),
              orderPrice(),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      CheckOrderDialog(
                        title: '정정',
                        account: '631202-04-091716',
                        stock: mainController.getSelectedStock(),
                        type: stockOrderController.tradeType.value,
                        count: stockOrderController.orderCount.value,
                        unitPrice:
                        stockOrderController.orderCount.value,
                        totalPrice:
                        stockOrderController.orderTotal.value,
                      ),
                      enableDrag: false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    color: GREEN,
                    child: const FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        '정정',
                        style: TextStyle(
                          color: WHITE,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      CheckOrderDialog(
                        title: '취소',
                        account: '631202-04-091716',
                        stock: mainController.getSelectedStock(),
                        type: stockOrderController.tradeType.value,
                        count: stockOrderController.orderCount.value,
                        unitPrice:
                        stockOrderController.orderPrice.value,
                        totalPrice:
                        stockOrderController.orderTotal.value,
                      ),enableDrag: false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    color: GREEN,
                    child: const FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        '취소',
                        style: TextStyle(
                          color: WHITE,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
