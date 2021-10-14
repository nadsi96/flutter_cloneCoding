import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/my_page_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

class EditMyPage extends StatelessWidget{

  final controller = Get.find<MyPageController>();

  /// MY 항목 기본값
  final defaultState = [
    '나의서비스등급',
    '총자산',
    '종목순위',
    '세계지수',
    '국내관심종목',
    '문의&챗봇',
    '투자스쿨',
    '국내뉴스',
    '이슈스케쥴',
  ];

  /// 리스트 상단
  /// 현재 선택된 카드 수 알려줌
  /// 선택카드 기본 상태로 초기화 버튼
  Widget top(){
    const double fontSize = 16;
    const TextStyle textStyle = TextStyle(fontSize: fontSize, color: BLACK);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: LIGHTGRAY),),),
      child: Row(
        children: [
          Obx((){
            int cnt = 0;
            for(var v in controller.myPageCheckSelected.values){
              if(v.value){
                cnt++;
              }
            }
            return RichText(
              text: TextSpan(text: '선택카드 ', style: textStyle,
                children: [
                  TextSpan(text: '$cnt', style: const TextStyle(fontSize: 16, color: BLUE)),
                  const TextSpan(text: ' (최대10개)', style: textStyle),
                ],
              ),
            );
          }),
          const Spacer(),
          InkWell(
            onTap: (){},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(border: Border.all(color: BLUE), borderRadius: BorderRadius.circular(50)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Transform.rotate(angle: 3.1 ,child: Image.asset('assets/images/return.png', color: BLUE, fit: BoxFit.fitHeight, height: 20)),
                  const Text('초기화', style: TextStyle(color: BLUE, fontSize: 12, fontWeight: FontWeight.bold)),
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
  /// 체크해서 MY페이지에 나타날 항목 선택
  Widget serviceList(){
    return Obx((){
      final services = controller.myPageEditOrder.value;

      return ReorderableListView(
        shrinkWrap: true,
          scrollDirection: Axis.vertical,
          onReorder: (oldIdx, newIdx) {
            controller.swapOrder(oldIdx, newIdx);
          },
          children: List.generate(
            services.length,
                  (index) => rowItem(services[index])),
      );
    });
  }

  /// 항목뷰
  Widget rowItem(String text){
    return Container(
      key: ValueKey(text),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: LIGHTGRAY)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: Row(
        children:[
          Expanded(
            flex: 2,
            child: InkWell(
              splashColor: TRANSPARENT,
              onTap: (){
                if(controller.myPageCheckSelected.containsKey(text)){
                  controller.myPageCheckSelected[text]!.toggle();
                }
              },
              child: Row(
                children: [
                  Obx((){
                    return RoundCheckButton(controller.myPageCheckSelected[text]!.value, false);
                  }),
                  Text(text, style: const TextStyle(fontSize: 20, color: BLACK)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: (controller.needLogin.contains(text)) ? [const Icon(Icons.lock, color: LIGHTGRAY, size: 28), const Icon(Icons.menu, color: LIGHTGRAY, size: 28)] : [const Icon(Icons.menu, color: LIGHTGRAY, size: 28)],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WHITE,
        shadowColor: TRANSPARENT,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const TitleBarBackButton(),
        ),
        titleSpacing: 0,
        title: const Text('MY 설정', style: TextStyle(fontSize: TITLEBAR_FONTSIZE, color: BLACK)),
      ),
      body: Container(
        child: Column(
            children: [
              top(),
              serviceList(),
            ]
        ),
      ),
      bottomSheet: SizedBox(
        height: 50,
        child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: (){},
                  child: Container(
                    color: DARKGRAY,
                    alignment: Alignment.center,
                    child: const Text('취소', style: TextStyle(color: WHITE, fontSize: 16)),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: (){},
                  child: Container(
                    color: BLUE,
                    alignment: Alignment.center,
                    child: const Text('적용', style: TextStyle(color: WHITE, fontSize: 16)),
                  ),
                ),
              ),
            ],
        ),
      ),
    );
  }

}