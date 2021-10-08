import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/main/main_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

class TabPredictContract extends StatelessWidget {
  final controller = Get.find<MainController>();

  final double cellHeight = 40;
  final double firstWidth = 90;
  late final double restWidth = (Get.width - firstWidth) / 3;

  final double bigFont = 16;
  final double smallFont = 14;

  TabPredictContract({Key? key}) : super(key: key) {
    final dataProducer = ProduceTabPredictContractData();
    dataProducer.createData(controller.hogaPage_standardPrice.value);
    controller.unitPage_setData(dataProducer.dataSet);
  }

  Widget tableHeader() {
    const deco = BoxDecoration(
      color: LIGHTGRAY,
      border: Border.symmetric(
        vertical: BorderSide(color: GRAY, width: 0.5),
        horizontal: BorderSide(color: GRAY, width: 1),
      ),
    );

    final textStyle = TextStyle(fontSize: smallFont, color: BLACK);

    return Row(
      children: [
        Container(
          width: firstWidth,
          height: cellHeight,
          alignment: Alignment.center,
          decoration: deco,
          child: Text('시간', style: textStyle),
        ),
        Container(
          height: cellHeight,
          width: restWidth,
          decoration: deco,
          alignment: Alignment.center,
          child: Text('예상체결가', style: textStyle),
        ),
        InkWell(
          onTap: () {
            controller.unitPage_tabPredict_toggleClick();
          },
          child: Stack(
            children: [
              Container(
                height: cellHeight,
                width: restWidth,
                decoration: deco,
                alignment: Alignment.center,
                child: Obx(() {
                  final text = controller.unitPage_tabPredict_toggleList[
                      controller.unitPage_tabPredict_toggleIdx.value];
                  return Text(text, style: textStyle);
                }),
              ),
              Positioned(
                right: 0, top: 0, bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      2,
                      (idx) => Obx(() => ColoredSignBox(idx ==
                          controller.unitPage_tabPredict_toggleIdx.value, unSelectedColor: GRAY,)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: cellHeight,
          width: restWidth,
          decoration: deco,
          alignment: Alignment.center,
          child: Text('예상체결량', style: textStyle),
        ),
      ],
    );
  }

  Color getColor(int sign) {
    if (sign > 0) {
      return RED;
    } else if (sign < 0) {
      return BLUE;
    } else {
      return BLACK;
    }
  }

  Widget tableRow(UnitPage_TabPredictContract_Data data) {
    final deco = BoxDecoration(
      border: Border.all(color: GRAY, width: 0.5),
    );

    final textStyle = TextStyle(fontSize: bigFont, color: getColor(data.sign));

    const padding = EdgeInsets.only(right: 5);
    return Row(
      children: [
        // 시간
        Container(
          width: firstWidth,
          height: cellHeight,
          alignment: Alignment.center,
          decoration: deco,
          child: Text(data.time,
              style: TextStyle(fontSize: smallFont, color: BLACK)),
        ),
        // 에상체결가
        // 예상체결량이 0이면 앞에 #
        Container(
          height: cellHeight,
          width: restWidth,
          decoration: deco,
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (data.contract == 0)
                Text(
                  '#',
                  style: TextStyle(color: BLACK, fontSize: smallFont),
                )
              else
                const Spacer(),
              Text(data.price, style: textStyle),
            ],
          ),
        ),
        // 정규장대비/정규장대비율
        Container(
          height: cellHeight,
          width: restWidth,
          decoration: deco,
          padding: padding,
          alignment: Alignment.centerRight,
          child: Obx(() {
            Widget icon;
            switch(data.sign){
              case 1:
                icon = Icon(Icons.arrow_drop_up_sharp, color: RED, size: bigFont,);
                break;
              case -1:
                icon = Icon(Icons.arrow_drop_down_sharp, color: BLUE, size: bigFont,);
                break;
              default:
                icon = const Spacer();
            }

            switch (controller.unitPage_tabPredict_toggleList[
                controller.unitPage_tabPredict_toggleIdx.value]) {
              case '정규장대비':
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    icon,
                    Text(data.dist, style: textStyle),
                  ],
                );
              case '정규장대비율':
                return Text(data.drate, style: textStyle);
              default:
                return Text(data.dist, style: textStyle);
            }
          }),
        ),
        // 예상체결량
        Container(
          height: cellHeight,
          width: restWidth,
          decoration: deco,
          padding: padding,
          alignment: Alignment.centerRight,
          child: Text(data.contract, style: TextStyle(color: BLACK, fontSize: bigFont)),
        ),
      ],
    );
  }

  Widget table() {
    return Obx(() {
      var dataSet = controller.unitPage_data.value;
      if(dataSet.isEmpty){
        return const Spacer();
      }
      return ListView.builder(
        itemCount: dataSet.length,
        itemBuilder: (BuildContext context, int index) =>
            tableRow(dataSet[index]),
      );
    });
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

class ProduceTabPredictContractData {
  List<UnitPage_TabPredictContract_Data> dataSet = [];

  void createData(int yesterday) {
    dataSet.clear();
    final ran = Random();

    DateTime ctime = DateTime(2021, 1, 1, 18, 00, 01);
    for (var i = 0; i < 50; i++) {
      ctime = ctime.subtract(Duration(seconds: ran.nextInt(5) + 1));

      final r = (1 - (ran.nextInt(200)-100)/10000);
      final price = (yesterday * r).toInt(); // +- 1%

      dataSet.add(UnitPage_TabPredictContract_Data(
          time: '${formatIntToStringLen2(ctime.hour)}:${formatIntToStringLen2(ctime.minute)}:${formatIntToStringLen2(ctime.second)}',
          price: formatIntToStr(price),
          sign: getSign(yesterday, price),
          dist: formatIntToStr((price - yesterday).abs()),
          drate: formatDoubleToStr((((price - yesterday) / yesterday)*100)),
          contract: formatIntToStr(ran.nextInt(1000))));
    }
  }

  int getSign(int yesterday, int curPrice) {
    if (yesterday < curPrice) {
      return 1;
    } else if (yesterday > curPrice) {
      return -1;
    } else {
      return 0;
    }
  }
}

class UnitPage_TabPredictContract_Data {
  final String time;
  final int sign;
  final String price;
  final String dist;
  final String drate;
  final String contract;

  UnitPage_TabPredictContract_Data(
      {required this.time,
      this.sign = 0,
      this.price = '',
      this.dist = '',
      this.drate = '',
      this.contract = ''});
}
