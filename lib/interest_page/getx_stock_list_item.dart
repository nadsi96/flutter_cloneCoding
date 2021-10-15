import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

class StockListItem extends StatelessWidget {

  StockListItem({this.stock});

  final controller = Get.find<MainController>();

  final Stock? stock;

  final ITEMHEIGHT = 60.0;

  final fontSizeTitle = 20.0;

  final fontSizeContent = 16.0;

  // 항목에 나타낼 주식 정보
  // 항목 클릭시 동작
  // 칸 높이
  // 큰 텍스트 폰트
  // 작은 텍스트 폰트

  // 캔들그래프
  String getGraph() {
    var i = 0;
    if (stock!.sign > 0) {
      i = 1;
    } else if (stock!.sign < 0) {
      i = 2;
    } else {
      i = 3;
    }
    return "assets/images/img${i}.png";
  }

  /// 주식 가격 TextView
  Widget setTextPrice(){
    return Text(formatStringComma(stock!.price), style: TextStyle(fontSize: fontSizeTitle, color: getColorWithSign(stock!.sign)), textAlign: TextAlign.right);
  }

  /// 주식 변화량 TextView
  Widget setTextVar(){
    return Text(stock!.getDist(), style: TextStyle(fontSize:fontSizeContent, color:getColorWithSign(stock!.sign)), textAlign: TextAlign.right);
  }

  /// 거래량 TextView
  Widget setTextCount(){
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        formatStringComma(stock!.count),
        style: TextStyle(fontSize: fontSizeContent, color: BLACK),
        textAlign: TextAlign.right,
      ),
    );
  }

  /// 비율 TextView
  Widget setTextRate(){
    return Text(stock!.getDrate(), style: TextStyle(fontSize: fontSizeContent, color: getColorWithSign(stock!.sign)), textAlign: TextAlign.right);
  }

  // 등락기호
  Widget setRateImg() {
    var i = 0;
    if (stock!.sign > 0) {
      i = 1;
    } else if (stock!.sign < 0) {
      i = 2;
    } else {
      return Container();
    }
    return Container(
      child: Image.asset(
        "assets/images/rateImg${i}.png",
        fit: BoxFit.fitWidth,
        width: 20,
      ),
      alignment: Alignment.topCenter,
    );
  }

  //
  Widget buildStock(){
    return ListTile(
        onTap: () {

          controller.selectedStock.value = stock!.title;
          print("click ${stock!.title}");
        },
        title: Container(
          /// container - row - row - img,
          ///                       - column - (이름, 가격))
          ///
          ///                 - col - row - (가격, 기호, 변동)
          ///                       - row - (수량, 비율)
          height: ITEMHEIGHT,
          child: Row(children: [
            /// 그래프
            Expanded(
                child: Row(children: [
                  Container(
                    child: Image.asset(getGraph(), fit: BoxFit.contain),
                    width: 20,
                    margin: const EdgeInsets.only(right: 10),
                  ),

                  /// 주식 이름, 분야
                  Column(
                    children: [
                      Text(stock!.title,
                          style: TextStyle(
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.bold,
                              color: BLACK)),
                      Text(stock!.type,
                          style: TextStyle(
                              fontSize: fontSizeContent,
                              color: GRAY))
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )
                ])),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: Row(
                            /// 가격, 등락기호, 가격변동
                            children: [
                              Expanded(child: setTextPrice(), flex: 3),
                              Expanded(child:setRateImg(), flex:2),
                              Expanded(child:setTextVar(), flex:2)
                            ],
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                          )
                      ),
                      Expanded(
                          child: Row(
                            /// 개수, 비율
                            children: [
                              Expanded(child: setTextCount(), flex:3),
                              Expanded(child: setTextRate(), flex:4)
                            ],
                            crossAxisAlignment: CrossAxisAlignment.end,
                          )
                      )
                    ]
                )
            )
          ]),
        )
    );
  }

  // 목록제거 버튼
  Widget removeList(){
    return ListTile(
      onTap: (){
        // controller.clearStocks();
        controller.updateStocks([]);
      },
        title: Container(
            height: ITEMHEIGHT,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  const Icon(Icons.close, color: GRAY),
                  Text("목록제거", style: TextStyle(fontSize:fontSizeContent, color:GRAY))
                ]
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return (stock != null) ? buildStock() : removeList();
  }
}
