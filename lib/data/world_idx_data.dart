class WorldStockPoint{
  final String name;
  final String point;
  final int sign;
  final String dist;
  final String drate;
  final String date;
  WorldStockPoint(this.name, this.point, this.sign, this.dist, this.drate, this.date);
}

final Map<String, WorldStockPoint> worldStockPoint = {
  'KOSPI' : WorldStockPoint('KOSPI', '2,950.45', 1, '34.07', '1.17', '10-13'),
  'KOSDAQ' : WorldStockPoint('KOSDAQ', '954.29', 1, '14.24', '1.51', '10-13'),
  'DOW' : WorldStockPoint('DOW', '34,378.34', -1, '117.72', '0.34', '10-12'),
  'NASDAQ' : WorldStockPoint('NASDAQ', '14,465.93', -1, '20.27', '0.14', '10-12'),
  '중국상해종합' : WorldStockPoint('중국상해종합', '3,541.97', -1, '4.97', '0.14', '10-13'),
  '일본 NIKKEI 225' : WorldStockPoint('일본 NIKKEI 225', '28,166.85', -1, '63.76', '0.23', '10-13'),
};