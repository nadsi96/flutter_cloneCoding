import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/register_page/stock_list_view.dart';
import 'package:flutter_prac_jongmock/register_page/top_bar.dart';


/// 등록버튼 클릭시 이동하는 화면
/// 리스트에서 주식 선택해서, 선택된 항목들 리스트로 반환
class RegisterPage extends StatelessWidget{

  static const routeName = 'registerPage';

  final List<String> preStocks;
  RegisterPage(this.preStocks);

  @override
  Widget build(BuildContext context) {

    // final List<String> preStocks = ModalRoute.of(context)!.settings.arguments as List<String>;

    return RegisterStateful(preStocks);
  }

}

class RegisterStateful extends StatefulWidget{
  List<String> preStocks;

  RegisterStateful(List<String> this.preStocks);

  @override
  State<StatefulWidget> createState() {
    return _RegisterStateful(preStocks);
  }
}

class _RegisterStateful extends State<RegisterStateful>{

  List<String> preStocks;

  late final registerAppBar; // 상단바
  late final StockListView stockListView; // 주식들 나타날 리스트뷰
  _RegisterStateful(List<String> this.preStocks){
    this.registerAppBar = RegisterAppBar(getStocks);
    this.stockListView = StockListView(preStocks);
  }


  // 해당 페이지에서 선택한 주식 항목 리스트 반환
  List<String> getStocks(){
    print("register_page");
    final temp = stockListView.getStocks();
    print(temp);
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
          Column(
            children:[
              registerAppBar,
              stockListView
            ]
          )
      )
    );
  }
}

