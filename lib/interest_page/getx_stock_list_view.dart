import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:get/get.dart';

import '../stock_data.dart';
import 'getx_stock_list_item.dart';

/// 관심종목 화면에 나타날 주식 리스트

class StockListView extends StatelessWidget {

  // 리스트에 나타날 주식 리스트
  final controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return buildList();
  }

  /// 주식 리스트 + 목록제거
  /// 항목 사이 구분선
  Widget buildList() {
    return GetX<MainController>(
      builder: (_) =>
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: (controller.stocks.value.length) * 2 + 2,
          itemBuilder: (context, idx){
            if(idx.isOdd){
              return const Divider(height: 1, color: GRAY);
            }else{
              final index = idx ~/ 2;
              // if(index >= controller.stockCnt.value){
              if(index >= controller.stocks.value.length){
                return StockListItem(stock: null);
              }else{
                return StockListItem(stock: getStock(controller.stocks.value[index], controller.stockListShowType.value));
              }
            }
          },
        )
    );
  }
}