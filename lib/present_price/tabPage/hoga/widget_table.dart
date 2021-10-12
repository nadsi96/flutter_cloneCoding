import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

import 'data/hoga_data.dart';

/// 대비가 0.00이면 검정
/// 양수면 빨강
/// 음수면 파란색 반한
///
/// null인 경우 검정으로 반환
Color getColor(double? rate) {
  Color color = BLACK;
  if (rate != null) {
    if (rate > 0) {
      color = RED;
    } else if (rate < 0) {
      color = BLUE;
    }
  }
  return color;
}

BoxDecoration? getBorder(int? price) {
  final controller = Get.find<MainController>();
  if ((price ?? 0) == (controller.getSelectedStockData().price ?? 0)) {
    return BoxDecoration(border: Border.all(color: BLACK));
  }
  return null;
}

/// 가운데 부분 클릭했을 때 나타날 매도, 매수 주문 다이얼로그
Future<Widget?> stockTradeDialog(BuildContext context, HogaData data, double cellHeight) {
  return showAlignedDialog(
      duration: const Duration(milliseconds: 1),
      // 등작 애니메이션 시간
      followerAnchor: Alignment.topCenter,
      // 자신 시작점
      targetAnchor: Alignment.topCenter,
      // 시작 기준점
      barrierColor: TRANSPARENT,
      //  외부 배경색
      context: context,
      builder: (context) {
        return _stockTradeDialog(data, cellHeight);
      });
}

Widget _stockTradeDialog(HogaData data, double cellHeight) {
  const double fontSize = 20;
  const shadow = [
    BoxShadow(
      color: GRAY,
      spreadRadius: 1,
      blurRadius: 10,
    ),
  ];
  return SizedBox(
    height: cellHeight,
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
              margin: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(color: RED, boxShadow: shadow),
              child: const Center(
                  child: Text(
                    "매수",
                    style: TextStyle(fontSize: fontSize, color: WHITE),
                  ))),
        ),
        Expanded(
          flex: 3,
          child: Container(
              decoration:
              const BoxDecoration(color: WHITE, boxShadow: shadow),
              child: Center(
                  child: Text(
                    formatIntToStr(data.price),
                    style:
                    TextStyle(color: getColor(data.rate), fontSize: fontSize),
                  ))),
        ),
        Expanded(
          flex: 2,
          child: Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(color: BLUE, boxShadow: shadow),
              child: const Center(
                  child: Text(
                    "매도",
                    style: TextStyle(fontSize: fontSize, color: WHITE),
                  ))),
        ),
      ],
    ),
  );
}

/// 주식 잔량 셀
Widget cellStockCnt(int? cnt, double cellHeight, {double cellBigFont=16}) {
  return Container(
    height: cellHeight,
    decoration: BoxDecoration(
      border: Border.all(color: GRAY, width: 0.5),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    alignment: Alignment.centerRight,
    child: Text(
      (cnt != null) ? formatIntToStr(cnt) : "",
      style: TextStyle(color: BLACK, fontSize: cellBigFont),
    ),
  );
}

/// 매도 행
/// 주식 잔량 / 호가 / 대비
Widget sellRow(HogaData? data, double cellHeight, {double cellBigFont=16, double cellSmallFont=14}) {
  final fontColor = getColor(data?.rate);

  return Row(
    children: [
      // 주식 수량
      Expanded(
        flex: 2,
        child: cellStockCnt(data?.cnt, cellHeight, cellBigFont: cellBigFont),
      ),
      // 호가, 대비
      Expanded(
        flex: 3,
        child: Builder(
          builder: (context) => Container(
            height: cellHeight,
            decoration: BoxDecoration(
              color: LIGHTBLUE,
              border: Border.all(color: GRAY, width: 0.5),
            ),
            child: Row(
              children: [
                // 호가
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      /// 탭메뉴 펼치기
                      if (data != null) {
                        stockTradeDialog(context, data, cellHeight);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: getBorder(data?.price),
                      child: Text(
                        (data != null) ? formatIntToStr(data.price) : "",
                        style: TextStyle(
                            color: fontColor,
                            fontWeight: FontWeight.bold,
                            fontSize: cellBigFont),
                      ),
                    ),
                  ),
                ),
                // 대비
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      (data != null)
                          ? formatDoubleToStr(data.rate, needSign: false)
                          : "",
                      style: TextStyle(
                          color: fontColor, fontSize: cellSmallFont),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

/// 매수 행
/// 호가 / 대비 / 주식 잔량
Widget buyRow(HogaData? data, double cellHeight, {double cellBigFont=16, double cellSmallFont=14}) {
  final fontColor = getColor(data?.rate);

  return Row(
    children: [
      // 매수 호가/대비
      Expanded(
        flex: 3,
        child: Builder(
            builder: (context) => Container(
              height: cellHeight,
              decoration: BoxDecoration(
                color: LIGHTRED,
                border: Border.all(color: GRAY, width: 0.5),
              ),
              child: InkWell(
                onTap: () {
                  if (data != null) {
                    stockTradeDialog(context, data, cellHeight);
                  }
                },
                child: Row(
                  children: [
                    // 호가
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: getBorder(data?.price),
                        child: Text(
                          (data != null)
                              ? formatIntToStr(data.price)
                              : "",
                          style: TextStyle(
                              color: fontColor,
                              fontWeight: FontWeight.bold,
                              fontSize: cellBigFont),
                        ),
                      ),
                    ),
                    // 대비
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          (data != null)
                              ? formatDoubleToStr(data.rate,
                              needSign: false)
                              : "",
                          style: TextStyle(
                              color: fontColor, fontSize: cellSmallFont),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
      // 매수 잔량
      Expanded(
        flex: 2,
        child: cellStockCnt(data?.cnt, cellHeight, cellBigFont: cellBigFont),
      ),
    ],
  );
}