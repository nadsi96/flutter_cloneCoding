import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';

class StockListItem extends StatelessWidget {
  // 항목에 나타낼 주식 정보
  final Stock stock;

  // 항목 클릭시 동작
  final ClickEvent? onClickEvent;

  // 칸 높이
  final ITEMHEIGHT = 60.0;

  // 큰 텍스트 폰트
  final fontSizeTitle = 20.0;

  // 작은 텍스트 폰트
  final fontSizeContent = 16.0;

  // 사용될 색깔들
  // 회색, 빨강, 파랑, 검정
  final fontColors = {
    'gray': Colors.black45,
    'red': Colors.red,
    'blue': Colors.blue,
    'black': Colors.black
  };

  final ClickEvent? eventClearStock;

  StockListItem({required this.stock, this.onClickEvent, this.eventClearStock});

  // 상승/하락에 따른 색 변동
  // 상승 - 빨강
  // 하락 - 파랑
  // 변화없음 - 검정
  Color? _getColor() {
    if (stock.getRate() > 0) {
      return fontColors['red'];
    } else if (stock.getRate() == 0) {
      return fontColors['black'];
    } else {
      return fontColors['blue'];
    }
  }

  // 캔들그래프
  String getGraph() {
    var i = 0;
    if (stock.getRate() > 0) {
      i = 1;
    } else if (stock.getRate() < 0) {
      i = 2;
    } else {
      i = 3;
    }
    return "assets/images/img${i}.png";
  }

  /// 주식 가격 TextView
  Widget setTextPrice(){
    return Text(stock.getPrice(), style: TextStyle(fontSize: fontSizeTitle, color: _getColor()), textAlign: TextAlign.right);
  }

  /// 주식 변화량 TextView
  Widget setTextVar(){
    return Text(stock.getVarStr(), style: TextStyle(fontSize:fontSizeContent, color:_getColor()), textAlign: TextAlign.right);
  }

  /// 갯수 TextView
  Widget setTextCount(){
    return Text(stock.getCount(), style: TextStyle(fontSize:fontSizeContent, color: fontColors['black']), textAlign: TextAlign.right);
  }

  /// 비율 TextView
  Widget setTextRate(){
    return Text(stock.getRateStr(), style: TextStyle(fontSize: fontSizeContent, color: _getColor()), textAlign: TextAlign.right);
  }

  // 등락기호
  Widget setRateImg() {
    var i = 0;
    if (stock.getRate() > 0) {
      i = 1;
    } else if (stock.getRate() < 0) {
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
          onClickEvent;
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
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  ),

                  /// 주식 이름, 분야
                  Column(
                    children: [
                      Text(stock.getTitle(),
                          style: TextStyle(
                              fontSize: fontSizeTitle,
                              fontWeight: FontWeight.bold,
                              color: fontColors['black'])),
                      Text(stock.getType(),
                          style: TextStyle(
                              fontSize: fontSizeContent,
                              color: fontColors['gray']))
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
      onTap: this.eventClearStock,
      title: Container(
          height: ITEMHEIGHT,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Icon(Icons.close, color: fontColors['gray']),
                Text("목록제거", style: TextStyle(fontSize:fontSizeContent, color:fontColors['gray']))
              ]
          )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return stock.getIsStock() ? buildStock() : removeList();
  }
}
