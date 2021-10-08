import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/empty_page.dart';
import 'package:flutter_prac_jongmock/main/main_controller.dart';
import 'package:flutter_prac_jongmock/register_page_with_getx/edit_stock_page.dart';
import 'package:flutter_prac_jongmock/register_page_with_getx/register_page_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

import 'add_stock_page.dart';

class RegisterPage extends StatelessWidget {

  late final RegisterPageController controller;
  late final List<String> preStocks;
  final double horizontalMargin = 20;

  RegisterPage({Key? key}) : super(key: key) {
    print("RegisterPage");
    // preStocks = Get.arguments["preStocks"];
    // print("constructor\n$preStocks");
    controller = Get.put(RegisterPageController());

    preStocks = Get.find<MainController>().stocks.value;
    controller.initData(preStocks);
    print("RegsterPage End");
    print(controller.selectedStocks.value);


  }

  /// 화면 닫을 때
  /// 선택된 주식들 이전 화면에 반환
  /// controller에 선택한 주식 초기화
  void closeScreen() {
    final selectedList = controller.selectedStocks.value.toList();
    controller.onDelete();
    // controller.dispose();
    controller.clearData();
    Get.back(result: selectedList);
  }

  /// 상단 버튼
  /// 종목추가 / 종목편집 / 그룹편집
  Widget topButtonSection() {
    final texts = ["종목추가", "종목편집", "그룹편집"];

    // texts에 있는 내용들로
    // 클릭된 경우 파란색, 클릭되지 않은 경우 회색 버튼 생성
    final btns = List.generate(
        texts.length,
        (idx) => Expanded(
            child: GetX<RegisterPageController>(
                builder: (_) => InkWell(
                  child: BlueGrayButton(text: texts[idx], isSelected: (idx==controller.topBtnIdx.value)),
                    onTap: () {
                      controller.onClickTopBtn(idx);
                    }))));

    return Row(children: btns);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("종목/그룹편집", style: TextStyle(color: BLACK, fontSize: TITLEBAR_FONTSIZE)),
          backgroundColor: WHITE,
          leading: InkWell(
            // 뒤로가기 버튼
            child: TitleBarBackButton(),
            onTap: () {
              closeScreen();
            },
          ),
          titleSpacing: 0,
          shadowColor: TRANSPARENT,
        ),
        body: WillPopScope(
          child: Column(children: [
            topButtonSection(),
            Expanded(child: GetX<RegisterPageController>(
              builder: (_) {
                switch(controller.topBtnIdx.value){
                  case 0 :
                    return AddStockPage();
                  case 1:
                    return EditStockPage(closeEvent: closeScreen);
                  case 2:
                    return EmptyPage();
                  default:
                    return EmptyPage();
                }
              }))
          ]),
          onWillPop: () {
            closeScreen();
            return Future(() => false);
          },
        ));
  }
}
