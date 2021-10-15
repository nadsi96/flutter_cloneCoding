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
    padding: const EdgeInsets.all(10),
    color: WHITE,
    child: Row(
      children: [
        Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 10, right: 20),
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

AppBar topBar({required String title, List<Widget>? actions, bool bottomSeparate=false}) {
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
    bottom: (bottomSeparate) ? PreferredSize(
      preferredSize: const Size.fromHeight(2),
      child: Container(
        color: LIGHTGRAY,
        height: 2,
      ),
    ) : null,
  );
}
