import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/divider.dart';
import 'package:flutter_prac_jongmock/register_page_with_getx/register_page_controller.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:get/get.dart';

import '../colors.dart';

class AddStockPage extends StatelessWidget {
  late final RegisterPageController controller =
      Get.find<RegisterPageController>();
  final double horizontalMargin = 20;

  /// 상단 버튼
  /// 주식 / 지수 / 선물옵션 / 장내채권 / 상품
  Widget topTabButtonSection() {
    final texts = ["주식", "지수", "선물옵션", "장내채권", "상품"];

    // texts에 있는 내용으로 버튼들 생성
    // 클릭된 경우 검은 폰트, 밑줄있는 버튼
    // 아닌 경우, 밑줄 없는 회색글자 버튼
    final tabs = List.generate(
        texts.length,
        (idx) => GetX<RegisterPageController>(
            builder: (_) => InkWell(
                onTap: () {
                  controller.onClickTabBtn(idx);
                },
                splashColor: TRANSPARENT,
                child: UnderLineButton(text: texts[idx], fontSize: 15, isSelected: (idx == controller.topTabIdx.value)))));

    return Container(color: WHITE, child: Row(children: tabs));
  }

  /// 국내주식 / 해외주식 버튼
  Widget stockTypeButtons() {
    final texts = ["국내주식", "해외주식"];

    final btns = List.generate(
        texts.length,
        (idx) => GetX<RegisterPageController>(
            builder: (_) => InkWell(
                onTap: () {
                  controller.onClickStockTypeBtn(idx);
                },
                splashColor: TRANSPARENT,
                child: (idx == controller.btnStockTypeIdx.value)
                    ? RoundBorderButton(
                        text: texts[idx], background: LLLIGHTGRAY, fontSize: 14)
                    : RoundBorderButton(
                        text: texts[idx],
                        background: WHITE,
                        textColor: GRAY,
                        fontSize: 14))));
    return Row(children: btns);
  }

  /// 검색창
  Widget searchBar() {
    return Container(
        color: LLLIGHTGRAY,
        child: TextFormField(
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hintText: "종목명, 코드, 초성 검색",
                border: InputBorder.none),
            style: const TextStyle(fontSize: 14, color: Colors.black),
            validator: (String? input) {},
            onChanged: (String? input) {
              // 글자 입력마다 반영
              if (input != null) {
                if (input.isEmpty) {
                  // 입력된 글자가 없으면 모든 데이터 보여줌
                  controller.initStocks();
                } else {
                  // 입력한 글자가 있다면, 주식 이름에 입력한 글자가 포함된 것들만 보여줌
                  // 입력한 글자를 포함하는 이름을 리스트에 담아서 컨토롤러가 가지고 있는 배열 업데이트
                  var stockNames = <String>[];
                  for (var stockName in stockData.keys) {
                    if (stockName.contains(input)) {
                      stockNames.add(stockName);
                    }
                  }
                  controller.updateStocks(stockNames, input);
                }
              }
            }));
  }

  /// 종목유형 선택 콤보박스
  /// 클릭시 다이얼로그 화면 엶
  Widget comboStockType() {
    return InkWell(
        child: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
          color: LLLIGHTGRAY,
          child: Row(children: [
            Expanded(child: Obx(() {
              return Text(controller.comboStockType.value,
                  style: const TextStyle(fontSize: 12, color: Colors.black));
            })),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey)
          ]),
        ),
        onTap: () {
          Get.bottomSheet(
            Column(
              children: [selectTypeDialog()],
              mainAxisSize: MainAxisSize.min,
            ),
            enableDrag: false,
          );
        });
  }

  /// 종목유형 선택 콤보박스 클릭시 나타날 다이얼로그
  Widget selectTypeDialog() {
    final comboStockTypeItems = controller.comboStockTypeItems;
    return Container(
        padding: EdgeInsets.all(30),
        color: Colors.white,
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: const Text("종목유형 선택",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)))),
              InkWell(
                  child: Icon(Icons.clear),
                  onTap: () {
                    Get.back();
                  })
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            // 리스트뷰 스크롤 안되도록
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: comboStockTypeItems.length * 2 - 1,
            itemBuilder: (context, index) {
              if (index.isOdd) {
                return DivideLine(Colors.grey);
              } else {
                final idx = index ~/ 2;
                return buildDialogListTile(comboStockTypeItems[idx]);
              }
            },
          )
        ]));
  }

  /// 종목유형선택 다이얼로그 리스트항목
  Widget buildDialogListTile(String item) {
    return Container(
        child: Obx(() {
          if (controller.comboStockType.value == item) {
            return ListTile(
                title: Text(item,
                    style: TextStyle(fontSize: 16, color: Colors.blue)),
                trailing: Icon(Icons.check, color: Colors.blue),
                onTap: () {
                  controller.comboStockType.value = item;
                  Get.back();
                  // onTileClick(item);
                });
          } else {
            return ListTile(
                title: Text(item,
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                onTap: () {
                  controller.comboStockType.value = item;
                  Get.back();
                });
          }
        }),
        height: 50);
  }

  /// 주식 리스트뷰
  /// 항목이 선택된 항목인 경우, 별모양 아이콘 노란색으로
  ///                 아닌 경우,          회색
  Widget buildList() {
    return GetX<RegisterPageController>(
        builder: (_) => (controller.stocksCnt.value == 0)
            ? buildEmptyList(controller.inputString.value)
            : ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: controller.stocksCnt.value * 2,
                itemBuilder: (BuildContext context, int idx) {
                  if (idx.isOdd) {
                    return DivideLine(LLLIGHTGRAY);
                  } else {
                    final index = idx ~/ 2;
                    final stock = controller.stocks.value[index];
                    print("buildList $stock");
                    return ListTile(
                        title: Text(stock,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black)),
                        trailing: Obx(() {
                          print(controller.selectedCount.value);
                          return controller.getIcon(stock);
                        }),
                        onTap: () {
                          controller.onClickStockListItem(stock);
                        });
                  }
                }));
  }

  ///
  /// 검색결과가 없는 경우 보여줄 빈 리스트화면
  Widget buildEmptyList(String text) {
    return Center(
        child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: const CircleAvatar(
            backgroundColor: LLLIGHTGRAY,
            child:
                Text("!", style: TextStyle(color: Colors.grey, fontSize: 30)),
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Text("'$text'",
                    style: const TextStyle(color: Colors.blue, fontSize: 20)),
                const Text("에 대한",
                    style: TextStyle(color: Colors.black, fontSize: 20))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            const Text("검색 결과가 없습니다.",
                style: TextStyle(color: Colors.black, fontSize: 20)),
            const Text(
              "다른 검색어를 입력하거나,\n검색어가 정확하게 입력되었는지 확인해주세요.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            )
          ],
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

        // TextField focus 없애기
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
        child: Column(children: [
          topTabButtonSection(),
          DivideLine(LLLIGHTGRAY),
          Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              color: WHITE,
              child: Column(children: [
                stockTypeButtons(),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: searchBar(),
                ),
                Row(children: [
                  Expanded(flex: 2, child: comboStockType()),
                  Expanded(flex: 2, child: Container()),
                  Expanded(
                      flex: 3,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GetX<RegisterPageController>(
                                builder: (c) => InkWell(
                                    child: RoundCheckButtonWithText(
                                        "ETF", c.chkETF.value, fontColor: GRAY,),
                                    onTap: () {
                                      c.chkETF.value = !c.chkETF.value;
                                    })),
                            GetX<RegisterPageController>(
                              builder: (c) => Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: InkWell(
                                      child: RoundCheckButtonWithText(
                                          "ETN", c.chkETN.value, fontColor: GRAY),
                                      onTap: () {
                                        c.chkETN.value = !c.chkETN.value;
                                      })),
                            )
                          ]))
                ])
              ])),
          DivideLine(Colors.grey),
          Expanded(child: buildList()),
        ]));
  }
}
