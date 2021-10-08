import 'package:flutter/material.dart';


/// 등록화면 상단바
/// 뒤로가기 버튼 클릭시, 선택된 주식리스트 반환
class RegisterAppBar extends StatefulWidget {

  List<String> Function() getStocks;

  RegisterAppBar(List<String> Function() this.getStocks);

  @override
  State<StatefulWidget> createState() {
    return _RegisterAppBar(this.getStocks);
  }
}

class _RegisterAppBar extends State<RegisterAppBar> {

  List<String> Function() getStocks;

  _RegisterAppBar(List<String> Function() this.getStocks);

  /// 닫기 동작
  /// 선택된 주식리스트 반환
  void close(){
    print("btnBack");
    final temp = getStocks();
    print(temp);
    print("btnBack done");
    Navigator.pop(context, temp);
  }
  /// 닫기버튼
  Widget btnBack(BuildContext context) {
    // print("btnBack");
    // print(getStocks());
    // print("btnBack done?");
    return InkWell(
      child: Icon(Icons.arrow_back_ios, color: Colors.black),
      onTap: close
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(children: [
          btnBack(context),
          Text("종목/그룹편집", style: TextStyle(fontSize: 18, color: Colors.black))
        ]));
  }
}
