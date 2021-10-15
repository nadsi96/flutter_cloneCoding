import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/tab_page_controller.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

import 'buttons/widget_button.dart';

Widget stockInfo(Stock stock) {
  Color fontColor = getColorWithSign(stock.sign);

  return Container(
    height: 70,
    padding: const EdgeInsets.symmetric(vertical: 10),
    color: WHITE,
    child: Row(
      children: [
        Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 20),
            child: Image.asset(
              getGraphImgPathWithSign(stock.sign),
              height: 30,
              fit: BoxFit.fitHeight,
            )),
        Expanded(
            child: Text(formatStringComma(stock.price),
                style: TextStyle(fontSize: 28, color: fontColor))),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getIconWithSign(stock.sign) ?? const Spacer(),
                  Text(formatStringComma(stock.dist),
                      style: TextStyle(fontSize: 14, color: fontColor))
                ],
              ),
              Text(
                '${formatStringComma(stock.count)}주',
                style: const TextStyle(fontSize: 14, color: BLACK),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(stock.getDrate(),
                  style: TextStyle(fontSize: 26, color: fontColor)),
              Text(' %', style: TextStyle(fontSize: 16, color: fontColor)),
            ],
          ),
        ),
      ],
    ),
  );
}

/// 상단바
/// title - 페이지 타이틀
/// actions - 바 오른쪽에 들어갈 내용
/// bottomSeparate - 상단바 아래 구분선 - true - 생성, false - ㄴㄴ
AppBar topBar(
    {required String title,
    List<Widget>? actions,
    bool bottomSeparate = false}) {
  final pageController = Get.find<TabPageController>();
  return AppBar(
    leading: Obx(() {
      return (pageController.pageStackCnt.value > 1)
          ? InkWell(
              splashColor: TRANSPARENT,
              onTap: () {
                pageController.backToPage();
                if (pageController.title.value != title) {
                  Get.back();
                }
              },
              child: const TitleBarBackButton(),
            )
          : Container();
    }),
    titleSpacing: 0,
    title: Text(
      title,
      style: const TextStyle(
          fontSize: TITLEBAR_FONTSIZE,
          color: BLACK,
          fontWeight: FontWeight.normal),
    ),
    actions: actions,
    shadowColor: TRANSPARENT,
    backgroundColor: WHITE,
    bottom: (bottomSeparate)
        ? PreferredSize(
            preferredSize: const Size.fromHeight(2),
            child: Container(
              color: LIGHTGRAY,
              height: 2,
            ),
          )
        : null,
  );
}

/// 종목검색
Widget searchStock(String stockName) {
  return Container(
    height: 40,
    decoration: BoxDecoration(
      color: WHITE,
      border: Border.all(color: GRAY),
    ),
    child: Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => print('주식 종목 찾기'),
            child: Row(
              children: [
                const Icon(Icons.search, size: 30, color: GRAY),
                Text(stockName,
                    style: const TextStyle(color: GRAY, fontSize: 16)),
                const Spacer(),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () => print('종목 설명 기업개요, 메모'),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: GRAY),
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: Image.asset('assets/images/i.png', fit: BoxFit.fitHeight),
          ),
        ),
      ],
    ),
  );
}
