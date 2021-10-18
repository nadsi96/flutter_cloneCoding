import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:get/get.dart';

import 'commons.dart';

class Buy extends StatelessWidget {
  // final btnTexts = ['현금', '신용', '대출상환'];

  final mainController = Get.find<MainController>();

  Buy({Key? key}) : super(key: key);

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
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Obx(() {
                  final title = mainController.stockOrderPage_tabList[
                      mainController.stockOrderPage_tabIdx.value];
                  List<String> btnTexts = [];
                  Color titleColor = Colors.green;

                  if (title == '매수') {
                    btnTexts = ['현금', '신용'];
                    titleColor = RED;
                  } else if (title == '매도') {
                    btnTexts = ['현금', '신용', '대출상환'];
                    titleColor = BLUE;
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
                              text: btnTexts[idx], fontSize: 14,),
                        ),
                      ),
                    ),
                  );
                }), // 현금 / 신용
                tradeType(text: '현금'),
                Row(
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
                  children: [
                    Expanded(
                      flex: 7,
                      child: Obx(() =>
                          titleContent(title: '단가', titleColor: getColor())),
                    ),
                    Expanded(
                      flex: 3,
                      child: checkBoxText('시장', true),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 7,
                        child: Obx(
                          () =>
                              titleContent(title: '금액', titleColor: getColor()),
                        )),
                    Obx(() {
                      if (mainController.stockOrderPage_tabIdx.value == 0) {
                        return Spacer(flex: 3);
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
            // 현금매수
          },
          child: Obx(() {
            return Container(
              color: getColor(),
              height: 60,
              alignment: Alignment.center,
              child: Text(
                '현금${mainController.stockOrderPage_tabList[mainController.stockOrderPage_tabIdx.value]}',
                style: const TextStyle(
                    color: WHITE, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            );
          }),
        ),
      ],
    );
  }
}
