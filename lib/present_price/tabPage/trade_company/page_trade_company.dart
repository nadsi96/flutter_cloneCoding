import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/main/main_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

/// 주식현재가 - 거래원
class TradeCompany extends StatelessWidget {
  TradeCompany({Key? key}) : super(key: key);

  final controller = Get.find<MainController>();

  final tableWidth = Get.width / 4; // table cell 너비
  final double tableHeight = 50; // 높이

  final double FONTSIZE = 15;
  final FONTCOLOR = BLACK;

  Widget tableHeader() {
    final texts = ["매도수량", "매도상위", "매수상위", "매수수량"];
    return Row(
      children: List.generate(
        texts.length,
        (idx) => Container(
          width: tableWidth,
          height: 40,
          decoration: BoxDecoration(
            color: LLIGHTGRAY,
            border: Border.all(color: GRAY, width: 0.5),
          ),
          child: Center(
            child: Text(
              texts[idx],
              style: TextStyle(color: FONTCOLOR, fontSize: FONTSIZE - 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget tableBody() {
    // 테이블에 넣을 데이터
    final _d = ProduceData();
    _d.produceData();
    var _dataSet = _d.dataSet;
    print(_dataSet);

    return SizedBox(
      height: tableHeight * _dataSet.length,
      child: ListView.builder(
        itemCount: _dataSet.length,
        itemBuilder: (BuildContext context, int index) {
          return tableBodyRow(_dataSet[index]);
        },
      ),
    );
  }

  /// 테이블 행
  Widget tableBodyRow(TradeData d) {
    return Row(children: [
      // 매도수량
      Expanded(
        child: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(5),
          width: tableWidth,
          height: tableHeight,
          decoration: BoxDecoration(
            color: WHITE,
            border: Border.all(color: LLIGHTGRAY, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                d.getSellCnt(),
                style: TextStyle(color: FONTCOLOR, fontSize: FONTSIZE),
              ),
              Text(
                d.getSellVar(),
                style: TextStyle(color: RED, fontSize: FONTSIZE),
              ),
            ],
          ),
        ),
      ),
      // 매도상위
      Expanded(
        child: Container(
          width: tableWidth,
          height: tableHeight,
          decoration: BoxDecoration(
            color: LIGHTBLUE,
            border: Border.all(color: LLIGHTGRAY, width: 0.5),
          ),
          child: Center(
            child: Text(
              d.getSellCompany(),
              style: TextStyle(color: FONTCOLOR, fontSize: FONTSIZE),
            ),
          ),
        ),
      ),
      // 매수상위
      Expanded(
        child: Container(
          width: tableWidth,
          height: tableHeight,
          decoration: BoxDecoration(
            color: LIGHTRED,
            border: Border.all(color: LLIGHTGRAY, width: 0.5),
          ),
          child: Center(
            child: Text(
              d.getBuyCompany(),
              style: TextStyle(color: FONTCOLOR, fontSize: FONTSIZE),
            ),
          ),
        ),
      ),
      // 매수수량
      Expanded(
        child: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(5),
          width: tableWidth,
          height: tableHeight,
          decoration: BoxDecoration(
            color: WHITE,
            border: Border.all(color: LLIGHTGRAY, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                d.getBuyCnt(),
                style: TextStyle(color: FONTCOLOR, fontSize: FONTSIZE),
              ),
              Text(
                d.getBuyVar(),
                style: TextStyle(color: RED, fontSize: FONTSIZE),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  /// 테이블 바닥 부분
  Widget tableTail() {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Container(
            width: tableWidth,
            height: 40,
            decoration: BoxDecoration(
                color: WHITE,
                border: Border.all(color: LLIGHTGRAY, width: 0.5)),
            child: Center(
              child: GetX<MainController>(
                builder: (_) => Text(
                  formatIntToStr(controller.foreignTotalSell.value),
                  style: TextStyle(color: FONTCOLOR, fontSize: FONTSIZE),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: WHITE,
                border: Border.all(color: LLIGHTGRAY, width: 0.5),
              ),
              child: Center(
                child: Text(
                  "외국계 합계",
                  style: TextStyle(color: FONTCOLOR, fontSize: FONTSIZE - 1),
                ),
              ),
            ),
          ),
          Container(
            width: tableWidth,
            height: 40,
            decoration: BoxDecoration(
              color: WHITE,
              border: Border.all(color: LLIGHTGRAY, width: 0.5),
            ),
            child: Center(
              child: GetX<MainController>(
                builder: (_) => Text(
                  formatIntToStr(controller.foreignTotalBuy.value),
                  style: TextStyle(color: FONTCOLOR, fontSize: FONTSIZE),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [tableHeader(), Expanded(child: tableBody()), tableTail()]);
  }
}

/// 테이블에 들어갈 데이터 생성
class ProduceData {

  final ran = Random();

  var dataSet = [];

  void produceData() {
    final companies = [
      "CS증권",
      "NH투자증권",
      "삼성증권",
      "키움증권",
      "미래에셋",
      "미래에셋증권",
      "한화투자",
      "신한투자",
      "한국증권",
      "JP모간",
      "DB금투",
      "이베스트투자",
      "유안타증권",
      "하이증권",
      "대신증권",
      "KB증권",
      "교보증권"
    ];

    dataSet = List.generate(
        5,
            (idx) =>
            TradeData(
              sellCompany: companies[idx],
              sellCnt: formatIntToStr(1000 - idx * 100),
              sellVari:
              (ran.nextInt(4) == 0) ? ran.nextInt(100).toString() : null,
              buyCompany: companies[companies.length - idx - 1],
              buyCnt: formatIntToStr(1000 - idx * 100),
              buyVari:
              (ran.nextInt(4) == 0) ? ran.nextInt(100).toString() : null,
            ));
    dataSet.addAll(List.generate(5, (idx) {
      final index = idx + 5;
      return TradeData(
        sellCompany: companies[index],
        sellCnt: formatIntToStr(1000 - index * 100),
        sellVari: (ran.nextInt(4) == 0) ? ran.nextInt(100).toString() : null,
      );
    }));
  }
}

class TradeData {
  final String? sellCompany;
  final String? sellCnt;
  final String? sellVari;

  final String? buyCompany;
  final String? buyCnt;
  final String? buyVari;

  TradeData(
      {this.sellCompany,
      this.sellCnt,
      this.sellVari,
      this.buyCompany,
      this.buyCnt,
      this.buyVari});

  String getSellCompany() => sellCompany ?? '';

  String getSellCnt() => sellCnt ?? "";

  String getSellVar() => (sellVari != null) ? '+${sellVari}' : '';

  String getBuyCompany() => buyCompany ?? '';

  String getBuyCnt() => buyCnt ?? '';

  String getBuyVar() => (buyVari != null) ? '+${buyVari}' : '';
}
