import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/my_page_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

/// MyPage 편집
///
/// 뒤로가기 클릭시 바뀌지 않도록 이전 상태 유지하도록
/// 취소, 적용 동작 구현 필요
/// 초기화버튼 동작 구현 필요
class EditMyPage extends StatelessWidget {
  final controller = Get.find<MyPageController>();

  /// MY 항목 기본값
  final defaultState = {
    '나의서비스등급': true,
    '총자산': true,
    '종목순위': true,
    '세계지수': true,
    '국내관심종목': true,
    '문의&챗봇': true,
    '투자스쿨': true,
    '국내뉴스': true,
    '이슈스케쥴': true,
    '국내주식찾기': false
  };

  Map<String, bool> previousState = {};
  List<String> previousOrder = [];
  EditMyPage({Key? key}) : super(key: key){

    // 수정 전 상태 저장
    for(var item in controller.myPageCheckSelected.entries){
      previousState[item.key] = item.value.value;
    }
    previousOrder = List.of(controller.myPageEditOrder.value);
  }

  /// AppBar 바로 밑
  /// 현재 선택된 카드 수 알려줌
  /// 선택카드 기본 상태로 초기화 버튼
  Widget top() {
    const double fontSize = 16;
    const TextStyle textStyle = TextStyle(fontSize: fontSize, color: BLACK);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: LIGHTGRAY),
        ),
      ),
      child: Row(
        children: [
          Obx(() {
            // 선택된 항목 갯수 출력
            // 체크한 항목들 갯수
            int cnt = 0;
            for (var v in controller.myPageCheckSelected.values) {
              if (v.value) {
                cnt++;
              }
            }
            return RichText(
              text: TextSpan(
                text: '선택카드 ',
                style: textStyle,
                children: [
                  TextSpan(
                      text: '$cnt',
                      style: const TextStyle(fontSize: 16, color: BLUE)),
                  const TextSpan(text: ' (최대10개)', style: textStyle),
                ],
              ),
            );
          }),
          const Spacer(),
          InkWell(
            onTap: () {
              // 초기화
              controller.myPageEditOrder.value = defaultState.keys.toList();
              for(var item in defaultState.entries){
                if(controller.myPageCheckSelected.containsKey(item.key)){
                  controller.myPageCheckSelected[item.key]!.value = item.value;
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: BLUE),
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset('assets/images/return.png',
                        color: BLUE, fit: BoxFit.fitHeight, height: 20),
                  ),
                  const Text('초기화',
                      style: TextStyle(
                          color: BLUE,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// MY 페이지에 보여줄 항목들 리스트
  /// 항목 드래그해서 순서 변경
  Widget serviceList() {
    return Obx(() {
      final services = controller.myPageEditOrder.value;

      return ReorderableListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        buildDefaultDragHandles: false,
        onReorder: (oldIdx, newIdx) {
          controller.swapOrder(oldIdx, newIdx);
        },
        children:
            List.generate(services.length, (index) => rowItem(services[index], index)
            ),
      );
    });
  }

  /// 항목뷰
  /// 체크해서 MY페이지에 나타날 항목 선택
  Widget rowItem(String text, int index) {
    return Container(
      key: ValueKey(text),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: LIGHTGRAY)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
              splashColor: TRANSPARENT,
              onTap: () {
                if (controller.myPageCheckSelected.containsKey(text)) {
                  controller.myPageCheckSelected[text]!.toggle();
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(() {
                    return RoundCheckButton(
                        controller.myPageCheckSelected[text]!.value, false);
                  }),
                  Center(
                    child: Text(text,
                        style: const TextStyle(fontSize: 20, color: BLACK)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ReorderableDragStartListener(
              /*
                  buildDefaultDragHandles: default = true
                  모바일에서 실행시 long click해야 움직
                  바로 조작하고 싶다면 이것을 false로 바꾸고,
                  모든 항목을 ReorderableDragStartListener로 만들어야
                   */
              index: index,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: (controller.needLogin.contains(text))
                    ? [
                  const Icon(Icons.lock, color: LIGHTGRAY, size: 28),
                  const Icon(Icons.menu, color: LIGHTGRAY, size: 28),
                ]
                    : [const Icon(Icons.menu, color: LIGHTGRAY, size: 28)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 수정사항 취소
  void cancel(){
    controller.myPageEditOrder.value = List.of(previousOrder);
    for(var item in previousState.entries){
      controller.myPageCheckSelected[item.key]!.value = item.value;
    }
    Get.back();
    // controller.myPageEditOrder.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WHITE,
        shadowColor: TRANSPARENT,
        leading: InkWell(
          onTap: () => cancel(),
          child: const TitleBarBackButton(),
        ),
        titleSpacing: 0,
        title: const Text('MY 설정',
            style: TextStyle(fontSize: TITLEBAR_FONTSIZE, color: BLACK)),
      ),
      body: Column(
        children: [
          top(),
          serviceList(),
        ],
      ),
      bottomSheet: SizedBox(
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => cancel(),
                child: Container(
                  color: DARKGRAY,
                  alignment: Alignment.center,
                  child: const Text('취소',
                      style: TextStyle(color: WHITE, fontSize: 16)),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => Get.back(),
                child: Container(
                  color: BLUE,
                  alignment: Alignment.center,
                  child: const Text('적용',
                      style: TextStyle(color: WHITE, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ), // 취소, 적용 버튼
    );
  }
}
