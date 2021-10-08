import 'package:flutter/material.dart';

import '../stock_data.dart';

/// 등록화면 주식 리스트
/// 항목 선택시 우측에 노란 별표
/// 해제시 회색 별로 표시
class StockListView extends StatefulWidget {

  final List<String> stocks;
  late final _StockListView stockListView_;

  StockListView(this.stocks){
    this.stockListView_ = _StockListView(stocks: this.stocks);
  }

  _StockListView getStockListView() => this.stockListView_;

  List<String> getStocks() => this.stockListView_.getSelected();

  @override
  State<StatefulWidget> createState() {
    return stockListView_;
  }
}

class _StockListView extends State<StockListView> {
// class StockListView extends StatelessWidget{

  // 리스트에 나타날 주식 리스트
  var stocks; //List<String>
  var selected = <String>{};

  _StockListView({required List<String> this.stocks}){
    for(var stock in stocks){
      selected.add(stock);
    }
  }

  List<String> getSelected(){
    print("StockListView getSelected");
    final selectedList = selected.toList();
    print(selectedList);
    return selectedList;
  }
  // StockListView(List<Stock> this.stocks, this.updateStock, this.clearStock);


  @override
  Widget build(BuildContext context) {
    return buildList();
  }

  Widget buildList() {

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: stockData.keys.length * 2,
        itemBuilder: (context, idx) {
          if (idx.isOdd) {
            return Divider(height: 1, color: Colors.black45);
          } else {
            final index = idx ~/ 2;
            return buildTile(stockData.keys.elementAt(index));
          }
        });
  }


  /// 리스트에 그려질 itemView
  /// 선택된 주식 목록에 포함되어있으면 우측에 노란별
  ///                     아니면         회색별
  Widget buildTile(String stock){
    return ListTile(
        onTap: (){
          setState((){
            if(selected.contains(stock)){
              selected.remove(stock);
            }else{
              selected.add(stock);
            }
          });
          print(selected);
        },
        title: Container(
            child: Row(
                children: [
                  Expanded(child: Text(stock, style: TextStyle(fontSize: 14, color: Colors.black))),
                  selected.contains(stock) ? Icon(Icons.star, color: Colors.yellowAccent) : Icon(Icons.star, color: Colors.grey)
                ]
            )
        )
    );
  }
}
