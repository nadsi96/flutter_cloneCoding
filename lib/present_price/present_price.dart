import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/controllers/tab_page_controller.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/news/page_news.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

import 'tabPage/hoga/page_hoga.dart';
import 'tabPage/investor/page_investor.dart';
import 'tabPage/stock_info/page_stock_info.dart';
import 'tabPage/time/time.dart';
import 'tabPage/trade_company/page_trade_company.dart';
import 'tabPage/unit_price/page_unit_price.dart';

/// 주식 현재가
class PresentPrice extends StatelessWidget {
  final controller = Get.find<MainController>();
  final pageController = Get.find<TabPageController>();

  PresentPrice({Key? key}) : super(key: key);

  /// 테이블 윗부분
  /// 조회하는 주식의 현재가, 등락비율 등 나타내는 부분
  /// item - 정보 표시할 주식
  Widget stockInfo(String item) {
    final Stock data;
    if (stockData.containsKey(item)) {
      // data = stockData[item]!.first;
      data = stockData[item]!;
    } else {
      // data = stockData.values.first.first;
      data = stockData.values.first;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        const double bigFontsize = 30;
        const double smallFontsize = 14;

        String? rateImgStr; // 대비기호 이미지 경로
        Color textColor = BLACK; // 글자색 지정
        if (data.sign == 1) {
          rateImgStr = "assets/images/rateImg1.png";
          textColor = RED;
        } else if (data.sign == -1) {
          rateImgStr = "assets/images/rateImg2.png";
          textColor = BLUE;
        }

        return Container(
            margin: const EdgeInsets.all(5),

            /// - Row - 그래프, 현재가, Column,   %
            ///                        ㄴRow - 대비기호, 전일대비
            ///                          주식잔량
            child: Row(children: [
              Expanded(
                  child: Row(
                      // 그래프, 현재가
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    Image.asset(getGraphImgPathWithSign(controller.getSelectedStockData().sign), height: 50),
                    Expanded(
                        child: Center(
                            child: Text(formatStringComma(data.price),
                                style: TextStyle(
                                    color: textColor, fontSize: bigFontsize))))
                  ])),
              Expanded(
                child: Row(children: [
                  Expanded(
                      child: Column(
                          // Row - 대비기호, 전일대비
                          // 주식잔량
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 대비기호. 변화없으면 빈칸으로
                              (rateImgStr == null)
                                  ? Container()
                                  : Image.asset(
                                      rateImgStr,
                                      width: 15,
                                    ),
                              // 주식잔량
                              Text(formatStringComma(data.dist),
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: smallFontsize))
                            ]),
                        Text("${formatStringComma(data.count)}주", // 주식잔량
                            style: const TextStyle(
                                color: BLACK, fontSize: smallFontsize))
                      ])),
                  Expanded(
                      child: Container(
                          // 전일대비
                          margin: const EdgeInsets.only(right: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(data.getDrate(),
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: bigFontsize)),
                                Text("%",
                                    style: TextStyle(
                                        color: textColor, fontSize: 18))
                              ])))
                ]),
              )
            ]));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Obx((){
          final flag = pageController.pageStackCnt.value > 1;
          return (flag) ? InkWell(
              onTap: () {
                pageController.backToPage();
                if (pageController.title.value != "주식현재가") {
                  Get.back();
                }
              },
              child: TitleBarBackButton()) : Container();
        }),
        titleSpacing: 0,
        title: const Text("주식현재가",
            style: TextStyle(fontSize: TITLEBAR_FONTSIZE, color: BLACK)),
        actions: [
          Container(
              padding: const EdgeInsets.all(15),
              child: Image.asset("assets/images/bell.png")),
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(Icons.menu, color: BLACK))
        ],
        backgroundColor: WHITE,
        shadowColor: TRANSPARENT,
      ),
      body: Container(
        color: WHITE,
        child: Column(
          children: [
            Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    // 주식 선택부분
                    // 검색창, 매수,매도 버튼
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: LIGHTGRAY)),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: const Icon(Icons.search_rounded,
                                    color: GRAY),
                              ),
                              GetX<MainController>(
                                  builder: (_) => Text(
                                      controller.getSelectedStock(),
                                      style: const TextStyle(
                                          color: GRAY, fontSize: 16)))
                            ],
                          ),
                        ),
                      ), // 검색창 (돋보기아이콘, 텍스트)
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(color: LIGHTGRAY),
                                bottom: BorderSide(color: LIGHTGRAY),
                                right: BorderSide(color: LIGHTGRAY))),
                        child: Image.asset(
                          "assets/images/i.png",
                          width: 40,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                        child: TextBtn("매수",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontColor: RED,
                            backgroundColor: LLLIGHTGRAY,
                            borderColor: LLIGHTGRAY,
                            padding: 10),
                      ), // 매수버튼
                      Container(
                        margin: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                        child: TextBtn("매도",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontColor: BLUE,
                            backgroundColor: LLLIGHTGRAY,
                            borderColor: LLIGHTGRAY,
                            padding: 10),
                      ), // 매도버튼
                    ],
                  ),
                ),
                GetX<MainController>(builder: (_) {
                  // 주식 정보
                  // 그래프, 현재가, 등락비율 등
                  return stockInfo(controller.getSelectedStock());
                }),
              ],
            ),
            tabMenu(), // 테이블에 보여줄 내용 선택할 탭메뉴
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: LLLIGHTGRAY),
                  ),
                ),
                padding: const EdgeInsets.only(top: 5),
                child: Obx(
                  () {
                    print("페이지 확인");
                    switch (controller.stockPriceTab.value) {
                      case "투자자":
                        controller.hogaPage_tradDataUpdateFlag = false;
                        return InvestorPage();
                      case "거래원":
                        controller.hogaPage_tradDataUpdateFlag = false;
                        return TradeCompany();
                      case "뉴스":
                        controller.hogaPage_tradDataUpdateFlag = false;
                        return News();
                      case "시간":
                        controller.hogaPage_tradDataUpdateFlag = false;
                        print("시간");
                        return Time();
                      case "종목정보":
                        controller.hogaPage_tradDataUpdateFlag = false;
                        return StockInfo();
                      case "호가":
                        controller.hogaPage_tradDataUpdateFlag = true;
                        print("호가");
                        return Hoga();
                      case "단일가":
                        controller.hogaPage_tradDataUpdateFlag = false;
                        return UnitPrice();
                      default:
                        return Container(color: BLUE);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 탭메뉴
  /// 호가,차트,투자자,거래원,뉴스,토론,일자,시간,1분선,재무,기타수급,리포트,종목정보,단일가
  Widget tabMenu() {
    final taps = List.generate(
        controller.stockPriceTabTexts.length,
        (index) => GetX<MainController>(
            builder: (_) => InkWell(
                onTap: () {
                  controller.stockPriceTab.value =
                      controller.stockPriceTabTexts[index];
                },
                child: UnderLineButton(
                  text: controller.stockPriceTabTexts[index],
                  isSelected: (controller.stockPriceTab.value ==
                      controller.stockPriceTabTexts[index]),
                  paddingV: 5,
                  underLineWidth: 2,
                ))));
    return Container(
        height: 40,
        child: Row(children: [
          Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification:
                      (OverscrollIndicatorNotification notification) {
                    notification.disallowGlow(); // 오버스코롤 되는 경우, 효과 없애기
                    return false;
                  },
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: taps,
                  ))),
          Builder(
            builder: (context) {
              return InkWell(
                  onTap: () {
                    /// 탭메뉴 펼치기
                    // showAlignedDialog(
                    //     followerAnchor: Alignment.topRight, // 자신 시작점
                    //     targetAnchor: Alignment.topRight, // 시작 기준점
                    //     context: context,
                    //     builder: (context) {
                    //       return Container(
                    //         padding: const EdgeInsets.all(20),
                    //         decoration: const BoxDecoration(color: WHITE, border: Border(bottom: BorderSide(color: GRAY))),
                    //         child: GridView.count(
                    //           crossAxisCount: 3,
                    //           mainAxisSpacing: 10,
                    //           crossAxisSpacing: 10,
                    //           children: List.generate(),
                    //         )
                    //       );
                    //     });
                  },
                  child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: const Center(
                          child: Icon(
                        Icons.keyboard_arrow_down,
                        color: BLACK,
                      ))));
            },
          )
        ]));
  }
}
