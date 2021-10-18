import 'package:flutter_prac_jongmock/data/build_data.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/hoga/data/produce_hoga_data.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/hoga/section_left_bottom.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/investor/page_investor_table.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/stock_info/page_stock_info.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/time/time.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/unit_price/tab_hoga.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:get/get.dart';

class MainController extends GetxController {

  var stocks = <String>[].obs; // 조회종목목록
  var stockCnt = 0.obs;

  var stockListShowType = 0.obs; // 0 - 현재가, 1 - 예상가, 2 - 단일가

  var selectedStock = "".obs; // 조회종목 중 선택한 주식 이름



  /// 주식현재가
  // 주식현재가 탭메뉴 목록
  final stockPriceTabTexts = [
    "투자자",
    "거래원",
    "뉴스",
    "시간",
    "종목정보",
    "호가",
    "단일가",
    "차트",
    "토론",
    "일자",
    "1분선",
    "재무",
    "기타수급",
    "리포트",
  ];
  var stockPriceTab = "".obs; // 주식현재가탭, 현재 선택된 탭

  /// 주식현재가 - 투자자 탭
  // 상단 버튼
  var investorPage_topBtns = ["투자자", "순매수/누적", "단위", "수지/차트"];
  var investorPage_topBtn = "".obs;

  // 투자자 선택 버튼
  var investorPage_investorList = ["전체", "개인", "외국인", "기관"];
  var investorPage_investorbtn = "".obs;

  // 순매수/누적

  // 단위

  // 수치/차트

  // 일자/주가
  // true - 일자, false - 주가
  var investorPage_date_price_flag = true.obs;

  // 주식현재가 - 그리드뷰 아이템
  var investorPage_Data = [].obs;
  // var investorPage_tableFirstColumn = [].obs;
  // var investorPage_tableRestColumns = [].obs;

  /// 주식현재가 - 거래원
  ///
  var foreignTotalSell = 0.obs;
  var foreignTotalBuy = 0.obs;

  /// 주식현재가 - 뉴스
  ///
  var newsPage_topBtns = ["전체", "뉴스", "공시"];
  var newsPage_topBtn = "".obs;
  var newsPage_webViewFontSize = 16.obs; // 원래 기본값이 16. 웹뷰 폰트 크기 조절

  /// 주식현재가 - 시간
  ///
  var timePage_cntOptionSelected = false.obs;
  var timePage_cntOption = "".obs;
  var timePage_cntOptions = {
    "100주 이상": 100,
    "500주 이상": 500,
    "1,000주 이상": 1000,
    "2,000주 이상": 2000,
    "3,000주 이상": 3000,
    "4,000주 이상": 4000,
    "5,000주 이상": 5000,
    "6,000주 이상": 6000,
    "7,000주 이상": 7000,
    "8,000주 이상": 8000,
    "9,000주 이상": 9000,
    "10,000주 이상": 10000,
    "30,000주 이상": 30000,
    "50,000주 이상": 50000,
    "100,000주 이상": 100000,
  };
  var timePage_toggle_dist = true.obs; // 등락폭/등락률
  var timePage_toggle_cnt = true.obs; // 체결량/체결강도
  var timePage_data = [].obs; // 테이블에 들어갈 데이터


  /// 주식현재가 - 종목정보
  ///
  var stockInfoPage_data = StockInfoData().obs;

  /// 주식현재가 - 호가
  ///
  var hogaPage_sellHoga = [].obs;
  var hogaPage_buyHoga = [].obs;
  var hogaPage_standardPrice = 0.obs;

  var hogaPage_bottomList = ["정규장", "시간외종가", "시간외단일가"];
  var hogaPage_bottomIdx = 0.obs; // 호가화면 하단 정규장/시간외종가/시간외단일가 전환버튼 인덱스. 인덱스에 해당하는 텍스트 출력

  var hogaPage_rightTopTabIdx = 0.obs; // 호가화면 오른쪽 상단부분 화면 인덱스

  // 호가화면 테이블 왼쪽 아래부분
  // 거래 내용 데이터 리스트
  var hogaPage_tradeData = <TradeData>[].obs;

  // 업데이트 시켜보자
  // 호가화면 들어가면 true로, 아니면 false로 설정해서
  // 비동기 함수로 업데이트
  var hogaPage_tradDataUpdateFlag = false;

  // 10호가 화면
  // 하단 버튼 ["정규장", "시간외종가"]
  var hogaPage_tenHoga_bottoms = ["정규장", '시간외종가'];
  var hogaPage_tenHoga_bottomIdx = 0.obs;

  /// 주식현재가 - 단일가
  var unitPage_tabs = ["호가", "예상체결", "시간", "일자"];
  var unitPage_tabIdx = 0.obs;

  var unitPage_hogaTab_leftBottom_data = [].obs;

  // 단일가 탭 데이터
  var unitPage_data = [].obs;

  // 단일가 - 일자 탭 토글
  var unitPage_tabDate_toggleList = ['정규장대비', '정규장대비율'];
  var unitPage_tabDate_toggleIdx = 0.obs;

  // 단일가 - 예상체결 탭 토글
  var unitPage_tabPredict_toggleList = ['정규장대비', '정규장대비율'];
  var unitPage_tabPredict_toggleIdx = 0.obs;


  /// 주식주문
  /// 탭
  var stockOrderPage_tabList = ['매수', '매도', '정정/취소', '미체결'];
  var stockOrderPage_tabIdx = 0.obs;

  // 호가/체결 테이블 토글
  var stockOrderPage_hoga_che_toggle = true.obs;

  // 매수, 매도, 정정/취소
  // 현금/신용/대출상환
  var stockOrderPage_payIdx = 0.obs;

  var stockOrderPage_tradeType = '보통'.obs;

  MainController() {


    stockPriceTab.value =
        stockPriceTabTexts.first; // 주식현재가 탭버튼 첫 항목 선택된 상태로 초기화
    investorPage_investorbtn.value = investorPage_investorList
        .first; // 주식현재가 - 투자자 버튼리스트 중 투자자 버튼. 첫 항목 선택된 상태로 초기화

    timePage_cntOption.value = timePage_cntOptions.keys.first; // 주식현재가 - 시간 체결량옵션 첫번째 값으로 초기화


  }

  /// 조회종목목록 목록 전체 업데이트
  void updateStocks(List<String> stocks) {
    print("mainController updateStocks");
    print(stocks);
    this.stocks.value = stocks;
    stockCnt.value = stocks.length;

    update();

    if (selectedStock.value == "") {
      selectedStock.value = this.stocks.value.first;
    }
    print(this.stocks.hashCode);
    print("mainController updateStocks end");
  }

  /// 조회종목목록에 아이템 추가
  void addStocks(String stock) {
    stocks.value.insert(0, stock);
    stockCnt.value = stocks.length;
  }

  /// 조회종목목록 초기화
  void clearStocks() {
    stocks.value.clear();
    stockCnt.value = 0;
  }

  /// 선택된 주식 title
  String getSelectedStock() {
    // 선택된 주식이 없고, 주식 리스트가 비어있지 않다면
    // 주식 리스트에서 첫번째 항목 반환
    if (selectedStock.value == "" && stocks.value.isNotEmpty) {
      return stocks.value.first;
    }
    return selectedStock.value;
  }
  /// 선택된 주식 정보
  /// 선택된 것 없으면 보유종목 중 첫번째 항목으로
  /// Stock()
  Stock getSelectedStockData(){
    print('getSelectedStockData');
    print(selectedStock.value);
    if(selectedStock.value == "" && stocks.value.isNotEmpty){
      if(stockData.containsKey(stocks.value.first)){
        return stockData[stocks.value.first]!;
      }else{
        return stockData.values.first;
      }
    }else{
      if(stockData.containsKey(selectedStock.value)){
        return stockData[getSelectedStock()]!;
      }else{
        return stockData.values.first;
      }
    }
  }

  /// 주식현재가 - 투자자
  /// 투자자, 순매수/누적, 단위, 수지/차트 버튼 클릭 확인
  void investorPage_topBtnClicked(String btn) {
    if (investorPage_topBtn.value != btn) {
      investorPage_topBtn.value = btn;
    } else {
      investorPage_topBtn.value = "";
    }
  }

  void investorPage_DatePriceToggle(ProduceInvestorData d){
    investorPage_date_price_flag.value = !investorPage_date_price_flag.value;
    // investorPage_tableFirstColumn.value = (investorPage_date_price_flag.value)? d.getDate() : d.getPrice();
  }

  void investorPage_setData(List<InvestorData> dataList){
    investorPage_Data.value = dataList;
  }

  void investorPage_addRow(List<InvestorData> dataList){
    investorPage_Data.value.addAll(dataList);
    investorPage_Data.refresh();
  }


  /// 주식 현재가 - 거래원
  // 외국인 합계 업데이트
  void updateForeinTotal(int sell, int buy) {
    foreignTotalSell.value = sell;
    foreignTotalBuy.value = buy;
  }

  /// 주식현재가 - 뉴스
  // 버튼 클릭 ["전체", "뉴스", "공시"]
  void newsPage_topBtnClick(String item) {
    newsPage_topBtn.value = item;
  }

  void newsPage_increFont() {
    if (newsPage_webViewFontSize < 40) {
      newsPage_webViewFontSize.value += 2;
    }
  }

  void newsPage_decreFont() {
    if (newsPage_webViewFontSize.value > 4) {
      newsPage_webViewFontSize.value -= 2;
    }
  }


  /// 주식현재가 - 시간
  void timePage_setData(List<TimeData> data){
    timePage_data.value = data;
  }

  void timePage_addRow(ProduceTimeData pd){
    pd.getMore(getSelectedStock());
    timePage_data.value = List.generate(pd.dataSet.length, (idx) => pd.dataSet[idx]);
    print(timePage_data.value.length);
  }

  void timePage_optioned(ProduceTimeData pd, String option){
    var temp = [];
    for(var item in pd.dataSet){
      if(item.cnt >= (timePage_cntOptions[timePage_cntOption.value] ?? 0)){
        temp.add(item);
      }
    }
    timePage_data.value = temp;
  }




  /// 주식현재가 - 종목정보
  void stockInfoPage_setData(StockInfoData data){
    stockInfoPage_data.value = data;
    stockInfoPage_data.value.setData();
  }


  /// 주식현재가 - 호가
  void hogaPage_setHoga(ProduceHogaData data){
    data.setRate();
    hogaPage_sellHoga.value = data.getSellHoga(getSelectedStockData());
    hogaPage_buyHoga.value = data.getBuyHoga(getSelectedStockData());

    hogaPage_standardPrice.value = data.getStandardPrice();

  }

  /// 호가화면 테이블 아래
  /// 정규장/시간외종가/시간외단일가 버튼
  void hogaPage_bottomBarClick(){
    hogaPage_bottomIdx.value = ++hogaPage_bottomIdx.value % hogaPage_bottomList.length;
  }
  /// 호가화면 테이블 왼쪽 아래부분 거래내역 데이터
  void hogaPage_setTradeData(List<TradeData> td){
    hogaPage_tradeData.value = List.generate(td.length, (idx) => td[idx]);
  }

  /// 10호가 화면
  /// 테이블 아래 정규장/시간외종가 버튼
  void hogaPage_tenHoga_bottomClick(){
    hogaPage_tenHoga_bottomIdx.value = (hogaPage_tenHoga_bottomIdx.value+1)%(hogaPage_tenHoga_bottoms.length);
  }

  /// 주식현재가 - 단일가
  /// 탭버튼 클릭
  void unitPage_tabClick(int idx){
    if(idx >= unitPage_tabs.length){
      unitPage_tabIdx.value = 0;
    }else{
      unitPage_tabIdx.value = idx;
    }
  }

  void unitPage_setHogaTabLeftBottomData(List<TabHogaSomeData> data){
    unitPage_hogaTab_leftBottom_data.value = data;
  }

  void unitPage_setData(List<dynamic> dataList){
    unitPage_data.value = List.of(dataList);
    // unitPage_data.value = List.of(createUnitPriceTableData());
  }
  void unitPage_getMore(){
    unitPage_data.value.addAll(createUnitPriceTableData(isInit: false));
    var temp = unitPage_data.value;
    temp.addAll(createUnitPriceTableData(isInit: false));
    unitPage_data.value = List.of(temp);

  }

  /// 단일가 - 일자 탭
  /// 테이블 헤더에 (정규장대비/정규장대비율) 토글
  void unitPage_tabDate_toggleClick(){
    unitPage_tabDate_toggleIdx.value = (unitPage_tabDate_toggleIdx.value + 1) % unitPage_tabDate_toggleList.length;
  }

  /// 단일가 예상체결탭
  /// 테이블 헤더 (정규장대비/정규장대비율) 토글
  void unitPage_tabPredict_toggleClick(){
    unitPage_tabPredict_toggleIdx.value = (unitPage_tabPredict_toggleIdx.value + 1) % unitPage_tabPredict_toggleList.length;
  }
}
