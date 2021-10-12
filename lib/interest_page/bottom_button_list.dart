import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/controllers/tab_page_controller.dart';
import 'package:get/get.dart';

/// 하단 버튼리스트
class BottomButtons extends StatefulWidget {
  @override
  _BottomButtons createState() {
    return _BottomButtons();
  }
}
class _BottomButtons extends State<BottomButtons> {

  final controller = Get.find<MainController>();
  final pageController = Get.find<TabPageController>();

  // 스크롤되는 부분에 들어갈 내용
  final btnListTexts = <String?>[
    "관심종목",
    "주식현재가",
    "종합차트",
    "주식주문",
    "잔고/손익",
    "체결내역",
    "즉시이체",
    "국내외\n시장종합",
    "국내뉴스",
    "전화상담",
    "종료",
    null
  ];

  final FONTSIZE = 14.0;
  final FONTCOLOR = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Row(
            children: [btn_Home(), Expanded(child: btnList()), btn_Menu()]));
  }

  /// 좌측 홈버튼
  Widget btn_Home() {
    return Container(
        margin: EdgeInsets.all(10),
        child: Column(children: [
          Icon(
            Icons.home_filled,
            color: Colors.grey,
          ),
          Text("MY", style: TextStyle(fontSize: 12, color: FONTCOLOR))
        ]));
  }

  /// 스크롤가능한 버튼리스트
  Widget btnList() {
    print("---------------- ${btnListTexts.length}");
    var btns = <Widget>[];
    for (var element in btnListTexts) {
      print(element);
      if (element != null) {
        btns.add(InkWell(
          onTap: (){
            pageController.goToPage(element);
          },
          child: Container(
            child: Center(
                child: Text(element,
                    style: TextStyle(fontSize: FONTSIZE, color: FONTCOLOR))),
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          ))
        );
      } else {
        btns.add(Icon(Icons.settings, color: FONTCOLOR));
      }
    }
    return Container(
        height: 60,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: btns,
        ));
  }

  /// 우측 메뉴버튼
  Widget btn_Menu() {
    return Container(
        margin: EdgeInsets.all(10),
        child: Column(children: [
          Icon(
            Icons.menu,
            color: Colors.grey,
          ),
          Text("메뉴", style: TextStyle(fontSize: 12, color: FONTCOLOR))
        ]));
  }
}