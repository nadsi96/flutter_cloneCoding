import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/data/build_data.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/unit_price/table_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

class TabDate extends StatelessWidget {
  final controller = Get.find<MainController>();
  final scrollController = ScrollController();

  final double cellHeight = 40;
  final double firstWidth = 90;

  final double bigFont = 16;
  final double smallFont = 14;

  TabDate({Key? key}) : super(key: key) {
    controller.unitPage_setData(createUnitPriceTableData());
    // 데이터 만들기
    // final ran = Random();
    // DateTime currentDate = DateTime.now();
    // controller.unitPage_setData(List.generate(20, (index) {
    //   return UnitPriceTableData(
    //       dateTime: currentDate.subtract(Duration(days: index)),
    //       price: ran.nextInt(100000),
    //       dist: ran.nextInt(20000) - 10000,
    //       drate: ran.nextInt(1000) / 100,
    //       cCount: ran.nextInt(10000),
    //       tradeCount: ran.nextInt(10000));
    // }));
  }

  /// 테이블 헤더
  Widget tableHeader() {
    // 테두리, 배경색 지정
    const deco = BoxDecoration(
        color: LIGHTGRAY,
        border: Border.symmetric(
            vertical: BorderSide(color: GRAY, width: 0.5),
            horizontal: BorderSide(color: GRAY, width: 1)));

    // 헤더 글자 스타일
    final textStyle = TextStyle(color: BLACK, fontSize: smallFont);

    return Row(
      children: [
        Container(
          height: cellHeight,
          width: firstWidth,
          decoration: deco,
          child: Center(
            child: Text('일자', style: textStyle),
          ),
        ),
        Expanded(
          child: Container(
            height: cellHeight,
            decoration: deco,
            child: Center(
              child: Text('단일가', style: textStyle),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              controller.unitPage_tabDate_toggleClick();
            },
            child: Container(
              height: cellHeight,
              decoration: deco,
              child: Stack(
                children: [
                  Center(
                    child: Obx(() {
                      final text = controller.unitPage_tabDate_toggleList[
                          controller.unitPage_tabDate_toggleIdx.value];
                      return Text(text, style: textStyle);
                    }),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                    child: Obx(() {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                            controller.unitPage_tabDate_toggleList.length,
                            (idx) => ColoredSignBox(
                                  idx ==
                                      controller
                                          .unitPage_tabDate_toggleIdx.value,
                                  unSelectedColor: GRAY,
                                )),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: cellHeight,
            decoration: deco,
            child: Center(
              child: Text('거래량', style: textStyle),
            ),
          ),
        ),
      ],
    );
  }

  Widget table() {
    return NotificationListener(
      onNotification: (notification) {
        if(scrollController.hasClients && scrollController.offset == scrollController.position.maxScrollExtent){
          controller.unitPage_getMore();
          print("getMore Data");
        }
        return false;
      },
      child: Obx(
        () {
          return ListView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: List.generate(controller.unitPage_data.value.length,
                (idx) => tableRow(controller.unitPage_data.value[idx])),
          );
        },
      ),
    );
  }

  Widget tableRow(UnitPriceDateData data) {
    final dateText =
        '${data.dateTime.year % 100}/${formatIntToStringLen2(data.dateTime.month)}/${formatIntToStringLen2(data.dateTime.day)}';
    Color color = BLACK;

    Widget icon = Spacer(); // 등락기호
    if (data.dist > 0) {
      color = RED;
      icon = Image.asset('assets/images/rateImg1.png',
          fit: BoxFit.fitHeight, height: cellHeight / 3);
    } else if (data.dist < 0) {
      color = BLUE;
      icon = Image.asset('assets/images/rateImg2.png',
          fit: BoxFit.fitHeight, height: cellHeight / 3);
    }

    const padding = EdgeInsets.symmetric(horizontal: 5);

    // 테두리, 배경색 지정
    final deco = BoxDecoration(border: Border.all(color: GRAY, width: 0.5));

    // 일자, 거래량 제외한 열 글자 스타일
    final textStyle = TextStyle(color: color, fontSize: bigFont);

    return Row(
      children: [
        Container(
          width: firstWidth,
          height: cellHeight,
          decoration: deco,
          child: Center(
            child: Text(
              dateText,
              style: TextStyle(color: BLACK, fontSize: smallFont),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: cellHeight,
            decoration: deco,
            padding: padding,
            alignment: Alignment.centerRight,
            child: Text(formatIntToStr(data.price), style: textStyle),
          ),
        ),
        Expanded(
          child: Container(
            height: cellHeight,
            decoration: deco,
            padding: padding,
            alignment: Alignment.centerRight,
            child: Obx(() {
              final toggle = controller.unitPage_tabDate_toggleList[
                  controller.unitPage_tabDate_toggleIdx.value];
              switch (toggle) {
                case '정규장대비':
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      icon,
                      Text(formatIntToStr(data.dist.abs()), style: textStyle),
                    ],
                  );
                case '정규장대비율':
                  return Text(formatDoubleToStr(data.drate), style: textStyle);
                default:
                  return Container();
              }
            }),
          ),
        ),
        Expanded(
          child: Container(
            height: cellHeight,
            decoration: deco,
            alignment: Alignment.centerRight,
            child: Text(
              formatIntToStr(data.tradeCount),
              style: TextStyle(color: BLACK, fontSize: bigFont),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          tableHeader(),
          Expanded(
            child: table(),
          ),
        ],
      ),
    );
  }
}
