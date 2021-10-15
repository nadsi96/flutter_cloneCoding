import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/unit_price/tab_predict_contract.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:get/get.dart';

import 'tab_date.dart';
import 'tab_hoga.dart';
import 'tab_time.dart';

class UnitPrice extends StatelessWidget {
  final controller = Get.find<MainController>();
  final double stockInfoHeight = 50;

  UnitPrice({Key? key}) : super(key: key);

  /// 주식 단일가 정보
  /// 단일가, 등락폭, 등락기호, 잔량, 대비
  Widget stockInfo() {
    const double priceFont = 26; // 단일가 폰트 크기
    const double smallFont = 12; // '시간외\n단일가', 등락폭, 잔량 폰트 크기
    const double rateFont = 24; // 대비 폰트 크기

    return Obx(() {
      final stock = stockData[controller.getSelectedStock()]?.last; // 현재 선택된 주식

      Color fontColor = BLACK;
      Widget icon = const Spacer(); // 등락기호

      if (stock != null) {
        if (stock.getRate() > 0) {
          fontColor = RED;
          icon = const Icon(Icons.arrow_drop_up_sharp, color: RED);
        } else if (stock.getRate() < 0) {
          fontColor = BLUE;
          icon = const Icon(Icons.arrow_drop_down_sharp, color: BLUE);
        }
      }

      return Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '시간외\n단일가',
                  style: TextStyle(color: BLACK, fontSize: smallFont),
                ),
                Text(
                  stock?.getPrice() ?? "",
                  style: TextStyle(color: fontColor, fontSize: priceFont),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          icon,
                          Text(
                            stock?.getVarStr() ?? "",
                            style: TextStyle(
                                color: fontColor, fontSize: smallFont),
                          ),
                        ],
                      ),
                      Text(
                        "${stock?.getCount() ?? ""}주",
                        style: const TextStyle(color: BLACK, fontSize: smallFont),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    stock?.getRateStr() ?? "",
                    style: TextStyle(color: fontColor, fontSize: rateFont),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: stockInfoHeight,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: stockInfo(),
        ),
        // 탭 버튼
        // [호가, 예상체결, 시간, 일자]
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
          children: List.generate(controller.unitPage_tabs.length, (idx) {
            final text = controller.unitPage_tabs[idx];
            return Obx(() {
              return Expanded(
                child: InkWell(
                  onTap: () {
                    controller.unitPage_tabClick(idx);
                  },
                  child: BlueGrayButton(
                    text: text,
                    isSelected: (idx == controller.unitPage_tabIdx.value),
                    fontSize: 14,
                    paddingV: 10,
                  ),
                ),
              );
            });
          }),
        ),),
        // 탭에 따라 바뀔 공간
        // [호가, 예상체결, 시간, 일자]
        Expanded(
          child: Obx(() {
            switch (
                controller.unitPage_tabs[controller.unitPage_tabIdx.value]) {
              case "호가":
                return TabHoga();
              case '일자':
                return TabDate();
              case '시간':
                return TabTime();
              case '예상체결':
                return TabPredictContract();
              default:
                return Container(color: BLUE);
            }
          }),
        ),
      ],
    );
  }
}
