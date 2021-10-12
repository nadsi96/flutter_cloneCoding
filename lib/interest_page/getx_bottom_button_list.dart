import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/controllers/tab_page_controller.dart';
import 'package:get/get.dart';

/// 하단 버튼리스트
class BottomButtons extends StatelessWidget {
  final pageController = Get.find<TabPageController>();

  final FONTSIZE = 14.0;
  final FONTCOLOR = LLLIGHTGRAY;

  BottomButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
        child: Container(
            color: BLACK,
            child: Row(children: [
              Center(child: btn_Home()),
              Expanded(child: btnList()),
              Center(child: btn_Menu())
            ])));
  }

  /// 좌측 홈버튼
  Widget btn_Home() {
    return Container(
        color: BLACK,
        padding: const EdgeInsets.all(10),
        child: Center(
            child: Column(children: [
          const Icon(
            Icons.home_filled,
            color: Colors.grey,
          ),
          Text("MY", style: TextStyle(fontSize: 8, color: FONTCOLOR))
        ])));
  }

  /// 스크롤가능한 버튼리스트
  Widget btnList() {
    print("---------------- ${pageController.mainBottomTabListTexts.length}");
    var btns = List.generate(pageController.mainBottomTabListTexts.length, (index) {
      final item = pageController.mainBottomTabListTexts[index];
      if (item != "설정") {
        return GetX<MainController>(builder: (_) {
          return InkWell(
              onTap: () {
                pageController.goToPage(item);
                pageController.selectedMainBottomTab.value = item;
              },
              child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  color: (pageController.selectedMainBottomTab.value == item)
                      ? DDarkGray
                      : BLACK,
                  child: Center(
                      child: Text(item,
                          style: TextStyle(
                              fontSize: FONTSIZE, color: FONTCOLOR)))));
        });
      } else {
        return InkWell(onTap: () {
          pageController.selectedMainBottomTab.value = item;
        }, child: GetX<MainController>(builder: (_) {
          return Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              color: (pageController.selectedMainBottomTab.value == item)
                  ? DDarkGray
                  : BLACK,
              child: Icon(Icons.settings, color: FONTCOLOR));
        }));
      }
    });
    return Container(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: btns,
        ));
  }

  /// 우측 메뉴버튼
  Widget btn_Menu() {
    return Container(
        color: BLACK,
        padding: const EdgeInsets.all(10),
        child: Center(
            child: Column(children: [
          const Icon(
            Icons.menu,
            color: Colors.grey,
          ),
          Text("메뉴", style: TextStyle(fontSize: 8, color: FONTCOLOR))
        ])));
  }
}
