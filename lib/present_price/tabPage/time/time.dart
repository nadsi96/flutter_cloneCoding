import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/main/main_controller.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

import 'time_cnt_option_bottom_sheet.dart';

/// 주식 현재가 - 시간
class Time extends StatelessWidget {
  final pd = ProduceTimeData();

  final controller = Get.find<MainController>();

  final scrollController = ScrollController();

  final tableHeight = 40.0; // 셀 높이
  final timeCellWidth = 80.0; // 시간 열 폭
  final fontSize = 14.0;
  final tableFontSize = 16.0;

  var canUpdateFlag = true;

  final decoTableCells =
      BoxDecoration(color: WHITE, border: Border.all(color: GRAY, width: 0.25));
  final padding = const EdgeInsets.all(10);

  Time({Key? key}) : super(key: key) {

    print("time constructor");
    // 등락폭/등락률, 체결량/체결강도 토글 상태 초기화
    // true - 앞, false - 뒤
    controller.timePage_toggle_dist.value = true;
    controller.timePage_toggle_cnt.value = true;

    pd.initData(controller.getSelectedStock());
    controller.timePage_setData(pd.dataSet);
  }

  /// 체결량 옵션 설정하는 부분
  /// 테이블 위
  /// 체크박스, 드롭박스 그림
  /// 드롭박스 클릭시 옵션 선택하는 다이얼로그화면 띄움
  Widget setOption() {
    return Container(
      margin: const EdgeInsets.all(10),
      color: WHITE,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              controller.timePage_cntOptionSelected.value =
                  !controller.timePage_cntOptionSelected.value;

              if (controller.timePage_cntOptionSelected.value) {
                // 체결량 체크박스가 체크되어있으면
                // 선택한 옵션 이상의 체결량이 있는 것만 보여줌
                controller.timePage_data.value = pd.getOptionedData(controller
                    .timePage_cntOptions[controller.timePage_cntOption.value]!);
              } else {
                controller.timePage_data.value = pd.dataSet;
              }
            },
            child: GetX<MainController>(
              builder: (_) => RoundCheckButtonWithText(
                  "체결량", controller.timePage_cntOptionSelected.value,
                  fontColor: BLACK, fontSize: fontSize),
            ),
          ), // 체결량 체크박스
          InkWell(
            onTap: () {
              // 체결량 옵션 설정하는 다이얼로그 열기
              // 체크되어있다면
              if (controller.timePage_cntOptionSelected.value) {
                Get.bottomSheet(CntOptionBottomSheet(pd));
              }
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
              color: LLLIGHTGRAY,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 10),
                    child: GetX<MainController>(
                      builder: (_) => Text(
                        controller.timePage_cntOption.value,
                        style: TextStyle(
                            fontSize: fontSize,
                            color: (controller.timePage_cntOptionSelected.value)
                                ? BLACK
                                : GRAY),
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: GRAY, size: 20)
                ],
              ),
            ),
          ), // 체결량 옵션 설정
        ],
      ),
    );
  }

  /// 테이블 헤더
  /// 시간, 주가, 등락폭/등락률, 체결량/체결강도
  Widget tableHeader() {
    const deco = BoxDecoration(
        color: LLIGHTGRAY,
        border:
            Border.symmetric(vertical: BorderSide(color: GRAY, width: 0.25)));
    final textStyle = TextStyle(color: BLACK, fontSize: fontSize);

    return Container(
      decoration: const BoxDecoration(
          color: LLIGHTGRAY,
          border: Border(
              top: BorderSide(color: GRAY),
              bottom: BorderSide(color: GRAY, width: 0.5))),
      child: Row(
        children: [
          Container(
              width: timeCellWidth,
              height: tableHeight,
              decoration: deco,
              child: Center(child: Text("시간", style: textStyle))),
          Expanded(
              child: Container(
                  height: tableHeight,
                  decoration: deco,
                  child: Center(child: Text("주가", style: textStyle)))),
          Expanded(
            child: InkWell(
              onTap: () {
                controller.timePage_toggle_dist.value =
                    !controller.timePage_toggle_dist.value;
              },
              child: Container(
                height: tableHeight,
                padding: const EdgeInsets.all(10),
                decoration: deco,
                child: GetX<MainController>(
                  builder: (_) => Stack(
                    children: [
                      Center(
                        child: Text(
                            (controller.timePage_toggle_dist.value)
                                ? "등락폭"
                                : "등락률",
                            style: textStyle),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ColoredSignBox(
                                controller.timePage_toggle_dist.value,
                                unSelectedColor: GRAY),
                            ColoredSignBox(
                                !controller.timePage_toggle_dist.value,
                                unSelectedColor: GRAY),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                controller.timePage_toggle_cnt.value =
                    !controller.timePage_toggle_cnt.value;
              },
              child: Container(
                height: tableHeight,
                padding: const EdgeInsets.all(10),
                decoration: deco,
                child: GetX<MainController>(
                  builder: (_) => Stack(
                    children: [
                      Center(
                        child: Text(
                            (controller.timePage_toggle_cnt.value)
                                ? "체결량"
                                : "체결강도",
                            style: textStyle),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ColoredSignBox(
                                  controller.timePage_toggle_cnt.value,
                                  unSelectedColor: GRAY),
                              ColoredSignBox(
                                  !controller.timePage_toggle_cnt.value,
                                  unSelectedColor: GRAY),
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTable() {
    return NotificationListener(
      onNotification: (notification) {
        // 체결량 옵션이 체크되어있지 않은 상태에서
        // 스크롤이 바닥에 닿으면
        // 행 추가
        if (!controller.timePage_cntOptionSelected.value) {
          if (scrollController.hasClients &&
              scrollController.offset ==
                  scrollController.position.maxScrollExtent) {
            controller.timePage_addRow(pd);
            print("scroll bottom");
          }
        }
        return false;
      },
      child: Obx(() {
        var items = controller.timePage_data.value;

        return ListView.builder(
          controller: scrollController,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return buildTableRow(items[index]);
          },
        );
      }),
    );
  }

  /// 테이블 행
  Widget buildTableRow(TimeData data) {
    // 글자 색
    // 등락폭이 양수면 빨강
    // 음수면 파랑
    // 0이면 검정
    final fcolor = (data.dist > 0)
        ? RED
        : (data.dist < 0)
            ? BLUE
            : BLACK;

    return Row(
      children: [
        SizedBox(
          width: timeCellWidth,
          child: Container(
            width: timeCellWidth,
            height: tableHeight,
            decoration: decoTableCells,
            child: Center(
              child: Text(
                data.getTime(),
                style: const TextStyle(color: BLACK, fontSize: 12),
              ),
            ),
          ),
        ),
        // 주가
        Expanded(
          child: Container(
            height: tableHeight,
            decoration: decoTableCells,
            padding: padding,
            alignment: Alignment.centerRight,
            child: Text(
              data.getPrice(),
              style: TextStyle(fontSize: tableFontSize, color: fcolor),
            ),
          ),
        ),
        // 등락폭/등락률
        Expanded(
          child: Container(
            height: tableHeight,
            decoration: decoTableCells,
            child: setTableCellDist(data),
          ),
        ),
        // 체결량/체결강도
        Expanded(
          child: Container(
            height: tableHeight,
            decoration: decoTableCells,
            padding: padding,
            alignment: Alignment.centerRight,
            child: GetX<MainController>(
              builder: (_) => Text(
                (controller.timePage_toggle_cnt.value)
                    ? data.getCnt()
                    : data.getCRate(),
                style: TextStyle(
                    fontSize: tableFontSize,
                    color: (data.crate > 0) ? RED : BLUE),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 등락폭 나타내는 경우, 대비부호/등락폭
  /// 등락률 나타내는 경우, 등락률만
  Widget setTableCellDist(TimeData data) {
    // 글자색 설정
    // 음수 - 파랑, 0 - 검정, 양수 - 빨강
    final fcolor = (data.dist > 0)
        ? RED
        : (data.dist < 0)
            ? BLUE
            : BLACK;

    // 대비기호 설정
    Widget _icon = Container();
    if (data.dist > 0) {
      _icon = const Icon(Icons.arrow_drop_up, color: RED);
    } else if (data.dist < 0) {
      _icon = const Icon(Icons.arrow_drop_down, color: BLUE);
    }
    return GetX<MainController>(
      builder: (_) => (controller.timePage_toggle_dist.value)
          ? Row(
              // 등락폭
              children: [
                Expanded(child: Center(child: _icon)),
                Expanded(
                  child: Container(
                    padding: padding,
                    alignment: Alignment.centerRight,
                    child: Text(
                      data.getDist(),
                      style: TextStyle(fontSize: tableFontSize, color: fcolor),
                    ),
                  ),
                ),
              ],
            )
          : Container(
              // 등락률
              padding: padding,
              alignment: Alignment.centerRight,
              child: Text(
                data.getDRate(),
                style: TextStyle(fontSize: tableFontSize, color: fcolor),
              ),
            ),
    );
  }

  // ["시간", "주가", "등락폭", "등락률", "체결량", "체결강도"]
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        setOption(),
        tableHeader(),
        Expanded(
          child: buildTable(),
        ),
      ],
    );
  }
}

/// 데이터 생성용
class ProduceTimeData {
  List<TimeData> dataSet = [];
  final ran = Random();

  var time = DateTime.now();
  late var calcTime;

  void initData(String stock) {
    dataSet = [];
    dataSet.addAll(createData(stock));
  }

  void getMore(String stock) {
    dataSet.addAll(createData(stock));
  }

  // 50개 생성
  List<TimeData> createData(String stock) {
    if (stockData.containsKey(stock)) {
      time = time.subtract(const Duration(minutes: 1)); // 현재 시간에서 1분 빼기
      calcTime = time;
      List<TimeData> tempList = [];
      var i = 0;
      while (i < 50) {
        var dist = ran.nextInt(3) % 3 * 100 - 100;
        double drate = (dist == 0)
            ? 0
            : (dist < 0)
                ? -0.01
                : 0.01;
        var price = stockData[stock]![0].price;
        if (price == null) {
          continue;
        }
        i++;
        price += dist;

        final type = (ran.nextInt(2) % 2 == 0) ? true : false;
        calcTime = calcTime.add(const Duration(seconds: 1)); // 이전 시간에 +1초

        var cnt = (ran.nextInt(1000) - 500);
        double crate = 0;
        if (cnt < 0) {
          crate = -0.01;
        } else {
          cnt += 1;
          crate = 0.01;
        }

        tempList.insert(
            0, TimeData(type, calcTime, price, dist, drate, cnt, crate));
      }
      return tempList;
    } else {
      return [];
    }
  }

  List<TimeData> getOptionedData(int cntOp) {
    print("getOptionedData");
    print("cntOp: $cntOp");
    List<TimeData> temp = [];
    for (var d in dataSet) {
      if (d.cnt.abs() >= cntOp) {
        temp.add(d);
        print(d.cnt.abs());
      }
    }
    return temp;
  }
}

class TimeData {
  TimeData(this.type, this.time, this.price, this.dist, this.drate, this.cnt,
      this.crate);

  final bool type; // true - 매수, false - 매도
  final DateTime time; // 시간
  final int price; // 주가
  final int dist; // 등락폭
  final double drate; // 등락률
  final int cnt; // 체결량
  final double crate; // 체결강도

  String getTime() =>
      "${formatIntToStringLen2(time.hour)}:${formatIntToStringLen2(time.minute)}:${formatIntToStringLen2(time.second)}";

  String getPrice() => formatIntToStr(price);

  String getDist() => formatIntToStr((dist < 0) ? dist * (-1) : dist);

  String getDRate() => formatDoubleToStr((drate < 0) ? drate * -1 : drate);

  String getCnt() => formatIntToStr((cnt < 0) ? cnt * -1 : cnt);

  String getCRate() => formatDoubleToStr(crate);
}
