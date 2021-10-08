import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/main/main_controller.dart';
import 'package:get/get.dart';

import '../../../colors.dart';
import 'page_investor_table.dart';

/// 주식현재가 - 투자자화면
class InvestorPage extends StatelessWidget {
  InvestorPage({Key? key}) : super(key: key) {
    calcDate = DateTime(today.year, today.month, today.day);
  }

  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final tableWidth = Get.width / 4;

  final controller = Get.find<MainController>();

  final today = DateTime.now();
  late DateTime calcDate;
  final ran = Random();
  var gridItems = <List<Widget>>[];

  /// 테이블에 옵션 주는 탭버튼
  /// 투자자, 순매수/누적, 단위, 수치/차트
  Widget topButtons() {
    return Row(
      children: List.generate(
        controller.investorPage_topBtns.length,
        (index) => SizedBox(
          width: tableWidth,
          child: _topBtn(controller.investorPage_topBtns[index], null),
        ),
      ),
    );
  }

  /// 탭버튼 생성
  Widget _topBtn(String title, ClickEvent? clickEvent) {
    return GetX<MainController>(
      builder: (_) {
        return InkWell(
          onTap: () {
            controller.investorPage_topBtnClicked(title);
            if (clickEvent != null) {
              clickEvent();
            }
          },
          child: Container(
            margin: (controller.investorPage_topBtn.value == title)
                ? const EdgeInsets.only(bottom: 2)
                : const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
            decoration: (controller.investorPage_topBtn.value == title)
                ? const BoxDecoration(
                    color: WHITE,
                    border: Border(
                      top: BorderSide(color: BLUE, width: 2),
                      right: BorderSide(color: LIGHTGRAY),
                    ),
                  )
                : const BoxDecoration(
                    color: LLLIGHTGRAY,
                    border: Border(
                      bottom: BorderSide(color: LIGHTGRAY, width: 2),
                      right: BorderSide(color: LIGHTGRAY),
                    ),
                  ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    child: Text(
                      title,
                      style: TextStyle(
                          color: (controller.investorPage_topBtn.value == title)
                              ? BLUE
                              : GRAY,
                          fontSize: 12),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      controller.investorPage_investorbtn.value,
                      style: TextStyle(
                          color: (controller.investorPage_topBtn.value == title)
                              ? BLUE
                              : BLACK,
                          fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 화면 우측에 i버튼 누르면 나타날 화면
  /// 투자자 세부분류 설명
  Widget infoDialog() {
    print("infoDrawer");
    return Dialog(
      backgroundColor: WHITE,
      child: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: WHITE,
                border: Border(
                  top: BorderSide(color: GRAY),
                  bottom: BorderSide(color: GRAY),
                ),
              ),
              child: const Center(
                child: Text(
                  "투자자 세부분류",
                  style: TextStyle(
                      color: BLACK, fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "※ 장중 당일 정보는 추정치입니다.",
                      style: TextStyle(color: GRAY, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Col - 상단버튼들(투자자, 순매수/누적, 단위, 수치/차트)
  ///     - Stack (테이블, i버튼)
  @override
  Widget build(BuildContext context) {
    print("today ${today}");
    var date = DateTime(today.year, today.month - 1, today.day);
    print("today -1month ${date}");
    print("${today.year}/${today.month}/.${today.day}");
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
              minWidth: double.infinity, minHeight: 40, maxHeight: 60),
          child: topButtons(),
        ),
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(top: 10), child: InvestorTable()),
          /*child: Stack(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 10), child: InvestorTable()),
            Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                    margin: const EdgeInsets.only(bottom: 100),
                    padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                    decoration: const BoxDecoration(
                        color: TRANSPARENT,
                        border: Border(
                            top: BorderSide(color: DEEPBLUE, width: 2),
                            left: BorderSide(color: DEEPBLUE, width: 2),
                            bottom: BorderSide(color: DEEPBLUE, width: 2))),
                    child: InkWell(
                        onTap: () {
                          print("open");
                          // Get.dialog(infoDialog());
                        },
                        child: const Center(
                            child: Text('i',
                                style: TextStyle(
                                    color: DEEPBLUE,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))))))
          ],
        )*/
        )
      ],
    );
  }
}
