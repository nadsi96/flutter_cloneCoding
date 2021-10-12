import 'dart:math';

import 'package:flutter_prac_jongmock/present_price/tabPage/unit_price/table_data.dart';

final ran = Random();
DateTime unitPriceDateData_currentDate = DateTime.now();
List<UnitPriceDateData> createUnitPriceTableData({bool isInit = true}){
  if(isInit){
    unitPriceDateData_currentDate = DateTime.now();
  }
  return List.generate(20, (index) {
    unitPriceDateData_currentDate = unitPriceDateData_currentDate.subtract(Duration(days: 1));
     return UnitPriceDateData(
        dateTime: unitPriceDateData_currentDate,
        price: ran.nextInt(100000),
        dist: ran.nextInt(20000) - 10000,
        drate: ran.nextInt(1000) / 100,
        cCount: ran.nextInt(10000),
        tradeCount: ran.nextInt(10000));
  });
}
