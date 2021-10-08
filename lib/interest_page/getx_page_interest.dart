import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/divider.dart';
import 'package:flutter_prac_jongmock/main/main_controller.dart';
import 'package:get/get.dart';

import 'getx_stock_list_view.dart';
import 'getx_top_buttons.dart';

/// 관심종목 페이지
class JongmockPage extends StatelessWidget {
  var title = "관심종목";

  var topButtons;

  final controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: WHITE,
          leading: (controller.pageStack.length > 1)
              ? InkWell(
              onTap: () {
                controller.backToPage();
              },
              child: TitleBarBackButton())
              : null,
          title: Text(controller.title.value,
              style: const TextStyle(color: BLACK, fontSize: 18)),
          shadowColor: TRANSPARENT,
        ),
        body: SafeArea(
            child: Column(children: [
              TopButtons(), // 상단 버튼(최근조회종목, 현재가, 등록, 오늘뉴스, 그래프 버튼
              DivideLine(Colors.black45),
              Expanded(child: StockListView()), // 주식 목록
            ])));
  }

}
