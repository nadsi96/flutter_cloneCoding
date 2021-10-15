import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/divider.dart';
import 'package:flutter_prac_jongmock/register_page_with_getx/register_page_controller.dart';
import 'package:get/get.dart';

class EditStockPage extends StatelessWidget {
  final RegisterPageController controller = Get.find<RegisterPageController>();
  final ClickEvent? closeEvent;

  bool stockOrderChangeFlag = false;

  EditStockPage({Key? key, this.closeEvent}) : super(key: key);

  /// 화면 윗부분
  /// 관심그룹3 / 정렬
  /// 일단 레이아웃만 작성
  Widget topBar() {
    return Container(
        color: LIGHTGRAY,
        child: Row(children: [
          Container(
              padding: const EdgeInsets.all(5), child: const Icon(Icons.menu)),
          const Expanded(child: Text("관심그룹3", style: TextStyle(fontSize: 16))),
          Container(
              decoration: BoxDecoration(
                  color: WHITE, border: Border.all(color: Colors.deepPurple)),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
              child: const Text("정렬",
                  style: TextStyle(color: Colors.deepPurple, fontSize: 16)))
        ]));
  }

  /// 리스트 메뉴
  /// 전체 선택, 빈줄 추가
  Widget listTopMenu() {
    return Container(
        color: WHITE,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
              onTap: () {
                controller.chkSelectAll.value = !controller.chkSelectAll.value;
                // if (!controller.chkSelectAll.value){
                //   var flag = true;
                //   for(var v in controller.chkSelectedStocks.value.values){
                //     print(v);
                //     if(!v){
                //       flag = false;
                //       break;
                //     }
                //   }
                //   if(flag) {
                //     for (var key in controller.chkSelectedStocks.value.keys) {
                //       print(key);
                //       controller.updateflag.value = !controller.updateflag.value;
                //       print(controller.updateflag.value);
                //       controller.chkSelectedStocks.value[key] = false;
                //     }
                //   }
                // }else{
                //   for (var key in controller.chkSelectedStocks.value.keys) {
                //     print(key);
                //     controller.chkSelectedStocks.value[key] = true;
                //   }
                // }
              },
              child: Row(children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Obx(() {
                      return RoundCheckButton(
                          controller.chkSelectAll.value, false);
                    })),
                const Text("전체 선택",
                    style: TextStyle(fontSize: 16, color: BLACK))
              ])),
          InkWell(
              onTap: () {},
              child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Text("빈줄추가",
                      style: TextStyle(fontSize: 16, color: DARKGRAY))))
        ]));
  }

  /// 주식 리스트
  Widget stockList() {
    return GetX<RegisterPageController>(
        builder: (_) => ReorderableListView(
            onReorder: (oldIdx, newIdx) {
              print("onReorder");
              controller.swapItems(oldIdx, newIdx);
            },
            children: List.generate(
                controller.selectedCount.value,
                (index) =>
                    // buildTile(controller.editSelectedStocks.value[index])
                    buildTile(controller.selectedStocks.value[index]))));
  }

  /// 주식 리스트 항목
  /// Row - 체크박스, 텍스트
  ///     - 아이콘
  Widget buildTile(String item) {
    bool isLongClicked = false;

    return Container(
        key: ValueKey(item),
        padding: const EdgeInsets.only(right: 20),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: LIGHTGRAY, width: 1))),
        child: Row(children: [
          Expanded(
              child: InkWell(
                  onTap: () {
                    isLongClicked = false;
                    controller.chkStockListClicked(item);
                    controller.updateflag.value = !controller.updateflag.value;
                    print("onTap");
                  },
                  onLongPress: () {
                    print("onLongPress");
                    isLongClicked = true;
                  },
                  child: Container(
                      padding:
                          const EdgeInsets.only(left: 20, top: 30, bottom: 30),
                      child: Row(children: [
                        Obx(() {
                          controller.updateflag.value;
                          return RoundCheckButton(
                              controller.chkSelectedStocks[item] ?? false,
                              isLongClicked);
                        }),
                        Text(item,
                            style: const TextStyle(color: BLACK, fontSize: 16))
                      ])))),
          Container(
              width: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, border: Border.all(color: GRAY)),
              child: Center(
                  child: Column(children: const [
                Icon(Icons.arrow_drop_up, color: GRAY),
                Icon(Icons.arrow_drop_down, color: GRAY)
              ])))
        ]));
  }

  /// 편집옵션
  /// 맨위로/맨아래로/그룹복사/삭제
  Widget optionMenu() {
    final texts = ["맨위로", "맨아래로", "그룹복사", "삭제"];
    return Row(
      children: List.generate(
          texts.length,
              (idx) => Expanded(
              child: InkWell(
                  onTap: () {},
                  child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      color: LIGHTGRAY,
                      child: Center(
                          child: GetX<RegisterPageController>(
                              builder: (_) =>
                              controller.chkSelectedStocks.value.containsValue(true) ?
                              Text(texts[idx],
                                  style:
                                  const TextStyle(fontSize: 16, color: BLACK)) :
                              Text(texts[idx],
                                  style:
                                  const TextStyle(fontSize: 16, color: GRAY))
                          ))))))
    );
  }

  /// 확인버튼
  Widget btnConfirm() {
    return InkWell(
        onTap: () {
          controller.selectedStocks.value = List.generate(
              controller.selectedCount.value,
              // (idx) => controller.editSelectedStocks.value[idx]);
              (idx) => controller.selectedStocks.value[idx]);
          (closeEvent ?? () => {})();
        },
        child: Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            color: BLUE,
            child: const Center(
                child:
                    Text("확인", style: TextStyle(fontSize: 20, color: WHITE)))));
  }

  /// 취소버튼
  Widget btnCancel() {
    return InkWell(
        onTap: () {
          (closeEvent ?? () => {})();
        },
        child: Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            color: GRAY,
            child: const Center(
                child:
                    Text("취소", style: TextStyle(fontSize: 20, color: WHITE)))));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      topBar(),
      listTopMenu(),
      DivideLine(LLLIGHTGRAY),
      Expanded(child: stockList()),
      optionMenu(),
      Row(children: [
        Expanded(child: btnCancel()),
        Expanded(child: btnConfirm())
      ])
    ]);
  }
}
