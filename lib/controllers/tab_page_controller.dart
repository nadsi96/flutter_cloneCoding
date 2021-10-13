import 'package:get/get.dart';

class TabPageController extends GetxController{

  var pageStack = [];
  var pageStackCnt = 0.obs;
  var title = "".obs;

  /// 메인화면 하단 버튼
  // 메인화면 하단 버튼 목록
  final mainBottomTabListTexts = <String>[
    "관심종목",
    "주식현재가",
    "종합차트",
    "주식주문",
    "잔고/손익",
    "체결내역",
    "즉시이체",
    "국내외\n시장종합",
    "국내뉴스",
    "전화상담",
    "종료",
    "설정",
  ];
  var selectedMainBottomTab = "".obs; // 선택된 하단 버튼

  /*PageController(){
    // 하단 버튼 리스트 클릭해서 페이지 이동시, 쌓는 페이지 스택
    // appBar에서 뒤로가기 버튼 클릭시 이전 페이지로 이동
    // pageStack.add(title.value);
    //
    // selectedMainBottomTab.value =
    //     mainBottomTabListTexts.first; // 하단 버튼 첫항목 선택된 상태로 초기화
  }*/

  void goToPage(String text) {
    pageStack.add(text);
    pageStackCnt.value++;
    title.value = text;
    selectedMainBottomTab.value = text;
    print('goToPage $pageStack');
    // update();
  }

  void backToPage() {
    pageStack.removeLast();
    pageStackCnt.value--;
    final title = pageStack.last;
    this.title.value = title;
    selectedMainBottomTab.value = title;
    print('backToPage $pageStack');
    // update();
  }
}