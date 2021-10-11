import 'package:flutter_prac_jongmock/util.dart';
/*
class _Stock{
  final String title; // 주식 이름
  final String type; // 분야
  final int sign; // 부호 1 양수, 0 0, -1 음수
  final int price; // 현재가
  final int dist; // 등락폭
  int restCount; // 잔량

  final int yesterday_close; // 전일 종가
  final int today_start; // 당일 시가
  final int today_close; // 당일 종가
}*/
class Stock {
  final bool isStock;
  final String? title;
  final String? type;
  int? price;
  int? count;
  int? vari;
  double? rate;

  Stock({this.isStock=true, this.title, this.type, this.price, this.count, this.vari, this.rate});

  void setPrice(int price) {
    this.price = price;
  }

  void setCount(int count) {
    this.count = count;
  }

  void setVar(int vari) {
    this.vari = vari;
  }

  void setRate(double rate) {
    this.rate = rate;
  }

  bool getIsStock() => isStock;
  String getTitle() => title ?? "";
  String getType() => type ?? "";


  String getPrice() => formatIntToStr(price ?? 0);

  String getCount() => formatIntToStr(count ?? 0);

  String getVarStr() {
    if(vari != null) {
      if (vari! < 0) {
        return formatIntToStr(-1 * vari!);
      } else {
        return formatIntToStr(vari!);
      }
    }else{
      return "";
    }
  }

  double getRate(){
    if(rate != null){
      return rate!;
    }else{
      return 0;
    }
  }
  String getRateStr() {
    if(rate != null) {
      if (rate! < 0) {
        return formatDoubleToStr(-1 * rate!);
      } else {
        return formatDoubleToStr(rate!);
      }
    }else{
      return "";
    }
  }
}

final stockData = {
  "크래프톤" : [
    Stock(title: "크래프톤", type: "서비스업", price: 456000, count: 62461, vari: 5000, rate: 1.22),
    Stock(title: "크래프톤", type: "서비스업", price: 449500, count: 1451, vari: -2000, rate: -0.44),
    Stock(title: "크래프톤", type: "서비스업", price: 449000, count: 3135, vari: -2500, rate: -0.55),
  ],
  "Naver" : [
    Stock(title: "NAVER", type: "서비스업", price: 406500, count: 367606, vari: -4000, rate: -0.98),
    Stock(title: "NAVER",  type: "서비스업", price: 408000, count: 768689, vari: -2000, rate: -0.49),
    Stock(title: "NAVER",  type: "서비스업", price: 408000, count: 0, vari: 0, rate: 0),
  ],
  "카카오" :[
    Stock(title: "카카오", type: "서비스업", price: 124000, count: 3808966, vari: -5500, rate: -4.62),
    Stock(title: "카카오",  type: "서비스업", price: 124500, count: 130102, vari: -5500, rate: -4.23),
    Stock(title: "카카오",  type: "서비스업", price: 124500, count: 0, vari: 0, rate: 0),
  ],
  "삼성증권" : [
    Stock(title: "삼성증권", type: "증권", price: 48900, count: 63922, vari: -250, rate: -0.51),
    Stock(title: "삼성증권",  type: "증권", price: 48850, count: 7639, vari: -250, rate: -0.51),
    Stock(title: "삼성증권",  type: "증권", price: 48850, count: 0, vari: 0, rate: 0),],
  "넷마블" : [
    Stock(title: "넷마블", type: "서비스업", price: 125000, count: 72536, vari: 3000, rate: 2.88),
    Stock(title: "넷마블", type: "서비스업", price: 122000, count: 604, vari: 500, rate: 0.41),
    Stock(title: "넷마블", type: "서비스업", price: 121500, count: 2114, vari: 0, rate: 0.00),
  ],
  "삼성전자" : [
    Stock(title: "삼성전자", type: "전기/전자", price: 77400, count: 7448119, vari: 1200, rate: 1.44),
    Stock(title: "삼성전자", type: "전기/전자", price: 77100, count: 405003, vari: 800, rate: 1.05),
    Stock(title: "삼성전자", type: "전기/전자", price: 76200, count: 25326, vari: -100, rate: -0.13),
  ],
  "TJ미디어" : [
    Stock(title: "TJ미디어", type: "KQ 일반전기전자", price: 5370, count: 103556, vari: 190, rate: 3.67),
    Stock(title: "TJ미디어", type: "KQ 일반전기전자", price: 5100, count: 3717, vari: -80, rate: -1.54),
    Stock(title: "TJ미디어", type: "KQ 일반전기전자", price: 5150, count: 506, vari: -30, rate: -0.58),
  ],
  "KB금융" : [
    Stock(title: "KB금융", type: "금융업", price: 52800, count: 741902, vari: 1000, rate: 1.93),
    Stock(title: "KB금융", type: "금융업", price: 52200, count: 21466, vari: 400, rate: 0.77),
    Stock(title: "KB금융", type: "금융업", price: 51700, count: 1409, vari: -100, rate: -0.19),
  ],
  "IBKS제12호스팩" : [
    Stock(title: "IBKS제12호스팩", type: "KQ 금융", price: 2240, count: 49334, vari: -15, rate: -0.67),
    Stock(title: "IBKS제12호스팩", type: "KQ 금융", price: 2240, count: 30, vari: -15, rate: -0.67),
    Stock(title: "IBKS제12호스팩", type: "KQ 금융", price: 2220, count: 11350, vari: -35, rate: -1.55),
  ],
  "CJ" : [
    Stock(title: "CJ", type: "금융업", price: 106500, count: 47549, vari: 2500, rate: 2.40),
    Stock(title: "CJ", type: "금융업", price: 105000, count: 966, vari: 1000, rate: 0.96),
    Stock(title: "CJ", type: "금융업", price: 104500, count: 191, vari: 500, rate: 0.48),
  ],
  "CJ제일제당" : [
    Stock(title: "CJ제일제당", type: "음식료업", price: 442500, count: 15615, vari: 7500, rate: 1.72),
    Stock(title: "CJ제일제당", type: "음식료업", price: 437500, count: 62, vari: 2500, rate: 0.57),
    Stock(title: "CJ제일제당", type: "음식료업", price: 435500, count: 41, vari: 500, rate: 0.11),
  ],
  "농심" : [
    Stock(title: "농심", type: "음식료업", price: 294000, count: 4442, vari: 0, rate: 0),
    Stock(title: "농심", type: "음식료업", price: 294500, count: 64, vari: 500, rate: 0.17),
    Stock(title: "농심", type: "음식료업", price: 294000, count: 29, vari: 0, rate: 0),
  ]
};


var myStocks = <String>["Naver", "카카오", "삼성전자"];
List<Stock> getStocksData({int i = 0}){
  var stocks = <Stock>[];
  for(var item in myStocks){
    final _stocks = stockData[item];
    if(_stocks != null){
      stocks.add(_stocks.elementAt(i));
    }
  }
  if (stocks.length > 1){
    stocks.add(Stock(isStock: false));
  }
  return stocks;
}


Stock getStock(String name, int i){
  return stockData[name]?.elementAt(i) ?? Stock(isStock: false);
}