/// 종목순위 데이터
final stockRank_incre = [
  StockData('삼일', '6,760', '1,560', 1, '30.00'),
  StockData('경동제약', '13,450', '3,100', 1, '29.95'),
  StockData('지에스이', '3,820', '740', 1, '24.03'),
  StockData('우신시스템', '7,300', '1,160', 1, '18.89'),
  StockData('센트랄모텍', '30,100', '4,600', 1, '18.04'),
  StockData('신한 이너스 2X 천연가스 선물 ETN(H)', '1,395', '210', 1, '17.72'),
  StockData('신한 인버스 2X 천연가스 선물 ETN', '2,095', '310', 1, '17.37'),
];
final stockRank_tradeVol = [
  StockData('삼성전자', '69,000', '2,500', -1, '3.50'),
  StockData('KODEX 200선물인버스2X', '2,410', '85', 1, '3.66'),
  StockData('KODEX 레버리지', '22,025', '800', -1, '3.50'),
  StockData('카카오', '113,500', '4,000', -1, '3.40'),
  StockData('쇼박스', '7,190', '20', 1, '0.28'),
  StockData('LG화학', '796,000', '32,000', 1, '4.19'),
  StockData('SK하이닉스', '91,500', '2,500', -1, '2.66'),
];
final stockRank_foreignBuy = [
  StockData('LG화학', '796,000', '32,000', 1, '4.19'),
  StockData('한화솔루션', '44,250', '2,250', 1, '5.36'),
  StockData('SK케미칼', '313,000', '12,500', 1, '4.16'),
  StockData('SK이노베이션', '256,500', '8,500', 1, '3.43'),
  StockData('LG전자', '124,000', '4,000', 1, '3.33'),
  StockData('크래프톤', '484,000', '14,000', 1, '2.98'),
  StockData('기아', '82,200', '300', 1, '0.37'),
];
final stockRank_cooperBuy = [
  StockData('KODEX 200선물인버스2X', '2,410', '85', 1, '3.66'),
  StockData('LG화학', '796,000', '32,000', 1, '4.19'),
  StockData('KODEX 인버스', '4,210', '70', 1, '1.69'),
  StockData('고려아연', '552,000', '21,000', 1, '3.95'),
  StockData('현대차', '204,500', '500', -1, '0.24'),
  StockData('삼성엔지니어링', '25,250', '950', 1, '3.91'),
  StockData('S-Oil', '112,500', '6,500', 1, '6.13'),
];

class StockData{
  final String name;
  final String price;
  final String dist;
  final int sign;
  final String drate;
  late final String yesterday;
  late final String todayStart;
  late final String high;
  late final String low;

  StockData(this.name, this.price, this.dist, this.sign, this.drate){
    yesterday = price;
    todayStart = price;
    high = (int.parse(price.replaceAll(',', '')) + 1500).toString();
    low = (int.parse(price.replaceAll(',', '')) + 1500).toString();
    print('$name $low');
  }
}