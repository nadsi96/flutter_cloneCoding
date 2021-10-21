import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:get/get.dart';

const double boxHeight = 60;
const double titleFontSize = 12;
const double contentFontSize = 14;
final deco =
    BoxDecoration(color: LLIGHTGRAY, borderRadius: BorderRadius.circular(3));

/// 구분
/// 보통, 시장가, 장전시간외, 장후시간외, 시간외단일가, 최유리지정가, 최우선지정가
Widget tradeType({String text = '', Widget? dialog, double margin_top=5, double margin_bottom=5,}) {
  final mainController = Get.find<MainController>();

  return Container(
    margin: EdgeInsets.only(top: margin_top, bottom: margin_bottom),
    decoration: deco,
    child: Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: GRAY))),
          alignment: Alignment.center,
          child: const Text('구분',
              style: TextStyle(color: DARKGRAY, fontSize: titleFontSize, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              if (dialog != null) {

                // 다이얼로그에서 클릭한 항목 받음
                final result = await Get.bottomSheet(dialog);
                if(result != null){
                  mainController.stockOrderPage_tradeType.value = result;
                  print(result);
                  // 다이얼로그에서 시장가를 선택했다면,
                  // 시장가 체크박스의 체크 상태를 true로
                  // 그 외 = false
                  if(result == '시장가'){
                    mainController.stockOrderPage_marketPrice.value = true;
                  }else{
                    mainController.stockOrderPage_marketPrice.value = false;
                  }
                }
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: Obx(
                      () => Text(mainController.stockOrderPage_tradeType.value,
                          style: const TextStyle(
                              fontSize: contentFontSize, color: GRAY)),
                    ),
                  ),
                ),
                Container(
                  width: 30,
                  alignment: Alignment.center,
                  child: const Icon(Icons.keyboard_arrow_down,
                      color: GRAY, size: 25),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

/// 좌상단 - title,
/// 우하단 - content 들어간 회색 박스
Widget titleContent({String title='', String content='', Color titleColor=BLACK, Color bgColor=LLIGHTGRAY}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 5, right: 5),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(3)),
    height: boxHeight,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title,
            style: TextStyle(color: titleColor, fontSize: titleFontSize, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left),
        Text(content,
            style: const TextStyle(fontSize: contentFontSize, color: BLACK),
            textAlign: TextAlign.right),
      ],
    ),
  );
}

Widget textBox({String text='', Color textColor = GRAY, double? fontSize=14, double? width, double height=boxHeight}){
  return Container(
    margin: const EdgeInsets.only(bottom: 5),
    width: width,
    height: boxHeight,
    decoration: deco,
    alignment: Alignment.center,
    child: Text(text, style: TextStyle(fontSize: fontSize, color: textColor))
  );
}

Widget checkBoxText(String text, bool isChecked){
  return Container(
    margin: const EdgeInsets.only(bottom: 5),
    height: boxHeight,
    alignment: Alignment.center,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: (isChecked) ? BLUE : GRAY),
          alignment: Alignment.center,
          child: const Icon(Icons.check, color: WHITE, size: 15),
        ),
        Text(text, style: const TextStyle(fontSize: contentFontSize)),
      ],
    ),
  );
}
