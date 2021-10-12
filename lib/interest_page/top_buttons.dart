import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/buttons/btn_price.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
// import 'package:flutter_prac_jongmock/register_page/register_page.dart';
import 'package:flutter_prac_jongmock/register_page_with_getx/register_page.dart';
import 'package:get/get.dart';

/// 최근조회종목 / 현재가/등록/오늘뉴스
class TopButtons extends StatefulWidget {
  void Function(List<String> stocks) updateStockList;

  List<String> Function() getStocks;

  TopButtons(void Function(List<String> stocks) this.updateStockList,
      List<String> Function() this.getStocks);

  @override
  State<StatefulWidget> createState() {
    return _TopButtons(this.updateStockList, getStocks);
  }
}

class _TopButtons extends State<TopButtons> {
  void Function(List<String> stocks) updateStockList;
  List<String> Function() getStocks;

  _TopButtons(void Function(List<String> stocks) this.updateStockList,
      List<String> Function() this.getStocks);

  @override
  Widget build(BuildContext context) {

    // 만든 Button class에 동작 넘겨주려고 형태 맞춰줌
    final btnEventRegisterFunc = () {
      btnEventRegister(context);
    };

    return Container(
        child: Row(
      children: [
        Expanded(
            // 최근조회종목
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: [
                    Icon(Icons.menu),
                    Expanded(
                        child: Button("최근조회종목", null,
                            fontSize: 18,
                            width: 60,
                            alignment: Alignment.centerLeft,
                            borderColor: null))
                  ],
                ))),

        /// 현재가/예상가/단일가
        BtnPrice(),
        Button("등록", btnEventRegisterFunc, margin: 5),
        Button("오늘\n뉴스", null, margin: 5),
        Button("", null, margin: 5)
      ],
    ));
  }

  // 등록 버튼 클릭 동작
  // 등록 화면 띄우고, 선택한 주식항목들 리스트로 반환해서 주식 리스트화면 업데이트
  void btnEventRegister(BuildContext context) async {
    print("btnEventRegister run");
    // 기존 가지고 있던 주식 리스트
    // 등록화면에서 선택된 상태로 보여줄 것
    final List<String> preStocks = getStocks();
    final c = Get.find<MainController>();
    c.stocks.value = preStocks;
    print(preStocks);
    print(c.stocks.value);
    print("1123");
    // final selectedStocks = await Navigator.pushNamed(context, 'registerPage', arguments: preStocks) as List<String>;
    /*var selectedStocks = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => RegisterPage(preStocks)))
        as List<String>;*/
    // var selectedStocks = await Get.to(RegisterPage(preStocks)) as List<String>;
    var selectedStocks = await Get.toNamed("/register", arguments: {"preStocks" : preStocks}) as List<String>;
    c.updateStocks(selectedStocks);
    print("-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
    print(selectedStocks);
    print("-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
    updateStockList(selectedStocks);
  }
}
