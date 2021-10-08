import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/list_item_stock.dart';

import '../stock_data.dart';

/// 관심종목 화면에 나타날 주식 리스트
class StockListView extends StatefulWidget {

  final List<String> stocks; // 리스트에 나타날 주식
  late final _StockListView stockListView_; // 주식 상태 받는 State
  StockListView(this.stocks);

  _StockListView getStockListView() => this.stockListView_;

  // 주식 리스트 받아옴
  List<String> getStocks() => this.stockListView_.stocks;

  @override
  State<StatefulWidget> createState() {
    this.stockListView_ = _StockListView(stocks: this.stocks);
    return stockListView_;
  }
}

class _StockListView extends State<StockListView> {

  // 리스트에 나타날 주식 리스트
  List<String> stocks; //List<String>
  final int type;

  _StockListView({required List<String> this.stocks, this.type = 0});

  /// 받은 주식 리스트로 화면 업데이트
  void updateStocks(List<String> stocks){
    setState((){
      this.stocks = stocks;
    });
  }

  /// 리스트 항목 초기화
  void clearStocks(){
    setState((){
      // this.stocks = <Stock>[Stock(isStock: false)];
      stocks = <String>[];
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildList();
  }

  /// 주식 리스트 + 목록제거
  /// 항목 사이 구분선
  Widget buildList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: (stocks.isNotEmpty) ? stocks.length * 2 + 2 : 0,
        itemBuilder: (context, idx) {
          if (idx.isOdd) {
            return Divider(height: 1, color: Colors.black45);
          } else {
            final index = idx ~/ 2;
            if(index >= stocks.length){
              return StockListItem(stock: Stock(isStock: false), onClickEvent: null, eventClearStock: clearStocks);
            }
            return StockListItem(stock: getStock(stocks[index], type), onClickEvent: null, eventClearStock: clearStocks,);
          }
        });
  }
}