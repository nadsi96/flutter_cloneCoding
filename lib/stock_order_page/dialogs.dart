import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
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
            return Obx((){
              final selected = mainController.stockOrderPage_tradeType.value;
              final flag = texts[idx] == selected;
              return ListTile(
                onTap: () => Get.back(result: texts[idx]),
                title: Text(texts[idx], style: TextStyle(color: flag? BLUE : BLACK, fontSize: 14),),
                trailing: flag? const Icon(Icons.check, color: BLUE, size: 25) : null,
              );
            });
          }
        },
      ),
    ),
  );
}
