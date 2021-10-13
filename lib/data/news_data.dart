import 'dart:math';

class NewsData {
  final int type; // 0 - 뉴스, 1 - 공시
  DateTime? dt;
  String company = "";
  final String title;

  NewsData({this.type = 0, this.dt, this.company = "", required this.title}) {
    dt ??= DateTime.now();
    company = (type == 1) ? "공시" : company;
  }
}

class ProduceNewsData {
  final ran = Random();
  final companies = [
    "한국경제",
    "파이낸셜",
    "조선경제i",
    "연합뉴스",
    "환경TV",
    "머니투데이",
    "이데일리",
    "이투데이",
    "서울경제",
    "매일경제",
    "인포스탁"
  ];
  var newsCnt = 0;

  List<NewsData> newsData = [];

  /// type -1 전체
  ///     0   뉴스
  ///     1   공시
  List<NewsData> getNewsData(int type) {
    if (type == -1) {
      return newsData;
    } else {
      List<NewsData> lst = [];
      for (var d in newsData) {
        if (d.type == type) {
          lst.add(d);
        }
      }
      return lst;
    }
  }

  // 뉴스, 공시 합쳐서 100개
  void setNewsData(String stock) {
    newsCnt = 0;
    var newsData = List.generate(100, (idx) {
      final type = ran.nextInt(2);
      if (type == 0) {
        newsCnt++;
      }
      final company = companies[ran.nextInt(companies.length)];
      final H = ran.nextInt(24);
      final M = ran.nextInt(60);
      const y = 21;
      final m = ran.nextInt(12) + 1;
      final d = ran.nextInt(31) + 1;

      return NewsData(
          type: type,
          dt: DateTime(y, m, d, H, M),
          company: company,
          title: "$stock $idx");
    });
    newsData.sort((nd1, nd2) => nd2.dt!.compareTo(nd1.dt!));
    this.newsData = newsData;
  }
}

