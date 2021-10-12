/// 종목순위 데이터
final stockRank_incre = [
  _StockData('삼일', '6,760', '1,560', 1, '30.00'),
  _StockData('경동제약', '13,450', '3,100', 1, '29.95'),
  _StockData('지에스이', '3,820', '740', 1, '24.03'),
  _StockData('우신시스템', '7,300', '1,160', 1, '18.89'),
  _StockData('센트랄모텍', '30,100', '4,600', 1, '18.04'),
  _StockData('신한 이너스 2X 천연가스 선물 ETN(H)', '1,395', '210', 1, '17.72'),
  _StockData('신한 인버스 2X 천연가스 선물 ETN', '2,095', '310', 1, '17.37'),
];
final stockRank_tradeVol = [
  _StockData('삼성전자', '69,000', '2,500', -1, '3.50'),
  _StockData('KODEX 200선물인버스2X', '2,410', '85', 1, '3.66'),
  _StockData('KODEX 레버리지', '22,025', '800', -1, '3.50'),
  _StockData('카카오', '113,500', '4,000', -1, '3.40'),
  _StockData('쇼박스', '7,190', '20', 1, '0.28'),
  _StockData('LG화학', '796,000', '32,000', 1, '4.19'),
  _StockData('SK하이닉스', '91,500', '2,500', -1, '2.66'),
];
final stockRank_foreignBuy = [
  _StockData('LG화학', '796,000', '32,000', 1, '4.19'),
  _StockData('한화솔루션', '44,250', '2,250', 1, '5.36'),
  _StockData('SK케미칼', '313,000', '12,500', 1, '4.16'),
  _StockData('SK이노베이션', '256,500', '8,500', 1, '3.43'),
  _StockData('LG전자', '124,000', '4,000', 1, '3.33'),
  _StockData('크래프톤', '484,000', '14,000', 1, '2.98'),
  _StockData('기아', '82,200', '300', 1, '0.37'),
];
final stockRank_cooperBuy = [
  _StockData('KODEX 200선물인버스2X', '2,410', '85', 1, '3.66'),
  _StockData('LG화학', '796,000', '32,000', 1, '4.19'),
  _StockData('KODEX 인버스', '4,210', '70', 1, '1.69'),
  _StockData('고려아연', '552,000', '21,000', 1, '3.95'),
  _StockData('현대차', '204,500', '500', -1, '0.24'),
  _StockData('삼성엔지니어링', '25,250', '950', 1, '3.91'),
  _StockData('S-Oil', '112,500', '6,500', 1, '6.13'),
];

class _StockData{
  final String name;
  final String price;
  final String dist;
  final int sign;
  final String drate;

  _StockData(this.name, this.price, this.dist, this.sign, this.drate);
}