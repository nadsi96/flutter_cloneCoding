import 'package:flutter_prac_jongmock/util.dart';
import 'package:intl/intl.dart';

class Stock{
  final String title; // 주식 이름
  final String type; // 분야
  final int sign; // 부호 1 양수, 0 0, -1 음수
  final String price; // 현재가
  final String dist; // 등락폭
  final String count; // 잔량

  final String yesterday_close; // 전일 종가
  final String today_start; // 당일 시가
  final String today_close; // 당일 종가

  Stock({required this.title, required this.type, required this.sign, required this.price, required this.dist, required this.count, required this.yesterday_close, required this.today_start, required this.today_close});

  String getDist({bool signFlag = false}) =>(signFlag) ? dist : dist.replaceAll('-', '');
  String getDrate({bool signFlag = false}){
    int ye = getYesterdayInt();
    double drate = (getPriceInt() - ye)/ye * 100;
    return NumberFormat("#0.00", "en_US").format((signFlag)?drate:drate.abs());
  }

  int getPriceInt() => int.parse(price);
  int getYesterdayInt() => int.parse(yesterday_close);
  int getStartInt() => int.parse(today_start);
  int getCloseInt() => int.parse(today_close);

}

final stockData = {
  "크래프톤" :
    Stock(title: "크래프톤", type: "서비스업", price: '475500', sign: -1, count: '123772', dist: '3000', yesterday_close: '478500', today_start: '478000', today_close: '475500'),
  "NAVER" :
    Stock(title: "NAVER", type: "서비스업", price: '396000', sign: 1, count: '232543', dist: '1000', yesterday_close: '395000', today_close: '396000', today_start: '400000' ),
  "카카오" :
    Stock(title: "카카오", type: "서비스업", price: '121000', sign: -1, count: '1459706', dist: '500', yesterday_close: '121500', today_close: '121000', today_start: '123000'),
  "삼성증권" :
    Stock(title: "삼성증권", type: "증권", price: '47300', sign: 1, count: '102819', dist: '100', yesterday_close: '47100', today_start: '47350', today_close: '47300'),
  "넷마블" :
    Stock(title: "넷마블", type: "서비스업", price: '123000', sign: 1, count: '69985', dist: '500', yesterday_close: '122500', today_start: '121000', today_close: '123000'),
  "삼성전자" :
    Stock(title: "삼성전자", type: "전기/전자", price: '70300', sign: 1, count: '11731923', dist: '900', yesterday_close: '69400', today_start: '70200', today_close: '70300'),
  "TJ미디어" :
    Stock(title: "TJ미디어", type: "KQ 일반전기전자", price: '5740', sign: 1, count: '108285', dist: '40', yesterday_close: '5700', today_start: '5760', today_close: '5740'),
  "KB금융" :
    Stock(title: "KB금융", type: "금융업", price: '55200', sign: 1, count: '771297', dist: '700', yesterday_close: '54600', today_start: '54200', today_close: '55300'),
  "IBKS제12호스팩" :
    Stock(title: "IBKS제12호스팩", type: "KQ 금융", price: '2340', sign: 1, count: '9080', dist: '30', yesterday_close: '2310', today_start: '2295', today_close: '2340'),
  "CJ" :
    Stock(title: "CJ", type: "금융업", price: '98400', sign: 0, count: '35715', dist: '0', yesterday_close: '98400', today_start: '99000', today_close: '98500'),
  "CJ제일제당" :
    Stock(title: "CJ제일제당", type: "음식료업", price: '404500', sign: 1, count: '22925', dist: '1000', yesterday_close: '403000', today_start: '407000', today_close: '404500'),
  "농심" :
    Stock(title: "농심", type: "음식료업", price: '292500', sign: 1, count: '6611', dist: '500', yesterday_close: '292000', today_start: '291000', today_close: '292500'),
};
/*class Stock {
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
}*/

/*final stockData = {
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
};*/


var myStocks = <String>["NAVER", "카카오", "삼성전자"];


Stock? getStock(String name, int i){
  return stockData[name];
  // return stockData[name]?.elementAt(i) ?? Stock(isStock: false);
}