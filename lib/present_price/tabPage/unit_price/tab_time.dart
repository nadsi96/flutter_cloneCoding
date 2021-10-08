import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/main/main_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

class TabTime extends StatelessWidget {
  final controller = Get.find<MainController>();

  final double cellHeight = 40;
  final double firstWidth = 90;
  late final double restWidth = (Get.width - firstWidth) / 3;

  final double bigFont = 16;
  final double smallFont = 14;

  TabTime({Key? key}) : super(key: key) {
    final dataProducer = ProduceUnitPageTabTimeData();
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
          child: Text('단일가', style: textStyle),
        ),
        Container(
          height: cellHeight,
          width: restWidth,
          decoration: deco,
          alignment: Alignment.center,
          child: Text('체결량', style: textStyle),
        ),
        Container(
          height: cellHeight,
          width: restWidth,
          decoration: deco,
          alignment: Alignment.center,
          child: Text('거래량', style: textStyle),
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

  Widget tableRow(UnitPage_TabTime_Data data) {
    final deco = BoxDecoration(
      border: Border.all(color: GRAY, width: 0.5),
    );

    final textStyle = TextStyle(fontSize: bigFont, color: BLACK);

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
        // 단일가
        Container(
          height: cellHeight,
          width: restWidth,
          padding: padding,
          decoration: deco,
          alignment: Alignment.centerRight,
          child: Text(data.price, style: TextStyle(fontSize: bigFont, color: getColor(data.sign))),
        ),
        // 체결량
        Container(
          height: cellHeight,
          width: restWidth,
          padding: padding,
          decoration: deco,
          alignment: Alignment.centerRight,
          child: Text(data.contractCnt, style: textStyle),
        ),
        // 거래량
        Container(
          height: cellHeight,
          width: restWidth,
          padding: padding,
          decoration: deco,
          alignment: Alignment.centerRight,
          child: Text(data.tradeCnt, style: textStyle),
        ),
      ],
    );
  }

  Widget table() {
    return Obx(() {
      var dataSet = controller.unitPage_data.value;
      if (dataSet.isEmpty) {
        return Center(
            child: Text('조회할 내역(자료)이 없습니다.',
                style: TextStyle(color: DDarkGray, fontSize: smallFont)));
      }
      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: dataSet.length,
          itemBuilder: (BuildContext context, int index) =>
              tableRow(dataSet[index]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
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

class ProduceUnitPageTabTimeData {
  List<UnitPage_TabTime_Data> dataSet = [];

  void createData(int yesterday) {
    final ran = Random();

    dataSet.clear();

    int price = (yesterday * (1 + (ran.nextInt(21)-10)/100)).toInt(); // +- 10%
    // DateTime dt = DateTime(2021, 1, 1, 18);
    DateTime dt = DateTime.now();
    dt = DateTime(dt.year, dt.month, dt.day, dt.hour, (dt.minute~/10*10), dt.second);

    while(dt.hour >= 16){
      if(dt.hour == 16 && dt.minute < 10){
        break;
      }else if(dt.hour == 18){
        dt = DateTime(dt.year, dt.month, dt.day, 17, 50, dt.second);
        dataSet.add(UnitPage_TabTime_Data(
            time: '종료',
            price: formatIntToStr(price),
            sign: getSign(yesterday, price),
            contractCnt: formatIntToStr(ran.nextInt(1000)),
            tradeCnt: formatIntToStr(ran.nextInt(10000))));
        continue;
      }
      price = ran.nextInt(500000);
      dataSet.add(UnitPage_TabTime_Data(
        time: '${formatIntToStringLen2(dt.hour)}:${formatIntToStringLen2(dt.minute)}:${formatIntToStringLen2(dt.second)}',
        price: formatIntToStr(price),
        sign: getSign(yesterday, price),
        contractCnt: formatIntToStr(ran.nextInt(1000)),
        tradeCnt: formatIntToStr(ran.nextInt(10000))
      ));
      dt = dt.subtract(Duration(minutes: 10));
    }
    /*
    dataSet = [
      UnitPage_TabTime_Data(
          time: '종료',
          price: formatIntToStr(price),
          sign: getSign(yesterday, price),
          contractCnt: formatIntToStr(ran.nextInt(1000)),
          tradeCnt: formatIntToStr(ran.nextInt(10000)))
    ];
    for (var i = 0; i < 11; i++) {
      price = ran.nextInt(500000);
      dt = dt.subtract(Duration(minutes: 10));
      dataSet.add(UnitPage_TabTime_Data(
        time:
            '${formatIntToStringLen2(dt.hour)}:${formatIntToStringLen2(dt.minute)}:${formatIntToStringLen2(dt.second)}',
        price: formatIntToStr(price),
        sign: getSign(yesterday, price),
        contractCnt: formatIntToStr(ran.nextInt(1000)),
        tradeCnt: formatIntToStr(ran.nextInt(10000)),
      ));
    }*/
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

class UnitPage_TabTime_Data {
  final String time;
  final String price;
  final int sign;
  final String contractCnt;
  final String tradeCnt;

  UnitPage_TabTime_Data(
      {this.time = "",
      this.price = "",
      this.sign = 0,
      this.contractCnt = "",
      this.tradeCnt = ""});
}
