import 'package:flutter_prac_jongmock/data/stock_rank_data.dart';
import 'package:flutter_prac_jongmock/data/user_data.dart';
import 'package:flutter_prac_jongmock/data/world_idx_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

class MyPageController extends GetxController{
  // Rx<User?> user = null.obs;
  var user = User(name: '', account: '').obs;
  var pw = ''; // 입력된 비밀번호
  var isLogin = false.obs; // 현재 로그인 상태. true - 로그인

  var goTopVisibility = true.obs; // 화면 상단으로 스크롤 이동시키는 버튼 보이기/숨기기

  var bank = ['삼성증권', '타금융사'];
  var showAccountToggle = 0.obs; // 자산 정보 표시 토글 (삼성증권/타금융사)

  var currentTime = ''.obs;

  /// 종목순위
  var stockRanktype = {
    '국내' : ['상승률', '거래대금', '외인순매수', '기관순매수'],
    '나스닥' : ['상승률', '거래대금', '거래량'],
  };
  var typeRankToggle = '국내'.obs;
  var selectedStockRankTab1 = '상승률'.obs; // 국내
  var selectedStockRankTab2 = '상승률'.obs; // 나스닥
  var selectedStockRankTab;
  var stockRankData = <StockData>[].obs; // 종목순위 리스트 데이터

  /// 세계지수
  var seqWorldData = ['KOSPI', 'KOSDAQ', 'DOW', 'NASDAQ', '중국상해종합', '일본 NIKKEI 225']; // 그리드에 나타낼 세계지수 데이터 항목, 순서
  var worldData = <WorldStockPoint>[].obs; // 그리드에 그릴 세계지수 데이터

  MyPageController(){
    refreshCurrentTime();
    selectedStockRankTab = {'국내' : selectedStockRankTab1, '나스닥' : selectedStockRankTab2};

  }
  /// 로그인 성공시 true,
  /// 실패시 false 반환
  bool login(String pw){
    if(usersData.containsKey(pw)){
      user.value = usersData[pw]!;
      this.pw = pw;
      isLogin.value = true;
      return true;
    }else{
      isLogin.value = false;
      return false;
    }
  }

  /// 회원 정보
  /// 삼성증권 / 타금융사 토글 클릭
  void accountToggleClick(){
    showAccountToggle.value = (++showAccountToggle.value)%bank.length;
  }

  /// 현재시간 갱신
  /// 문자열
  void refreshCurrentTime(){
    final ctime = DateTime.now();
    currentTime.value = '${ctime.year}-${formatIntToStringLen2(ctime.month)}-${formatIntToStringLen2(ctime.day)} ${formatIntToStringLen2(ctime.hour)}:${formatIntToStringLen2(ctime.minute)}';
    login(pw);
  }

  /// 종목순위
  /// 국내/나스닥 토글 선택에 따라
  /// 해당하는 값들(상승률,거래대금,외인순매수,기관순매수 / 상승률,거래대금,거래량) 배열로 리턴
  List<String> getStockRankTypes(){
    if(stockRanktype.containsKey(typeRankToggle.value)){
      return stockRanktype[typeRankToggle.value]!;
    }else{
      return stockRanktype.values.first;
    }
  }

  /// 종목순위
  /// 국내/나스닥 토글, 탭 선택에 따라 해당하는 데이터 배열 반환
  List<StockData> getStockRankData(){
    if(typeRankToggle.value == '국내'){
      switch(selectedStockRankTab1.value){
        case '상승률':
          stockRankData.value = stockRank_incre;
          break;
        case '거래대금':
          stockRankData.value = stockRank_tradeVol;
          break;
        case '외인순매수':
          stockRankData.value = stockRank_foreignBuy;
          break;
        case '기관순매수':
          stockRankData.value = stockRank_cooperBuy;
          break;
        default:
          stockRankData.value = [];
      }
    }else{
      switch(selectedStockRankTab2.value){
        case '상승률':
          stockRankData.value = stockRank_incre;
          break;
        case '거래대금':
          stockRankData.value = stockRank_tradeVol;
          break;
        // case '거래량':
          // stockRankData.value = stockRank_foreignBuy;
          // break;
        default:
          stockRankData.value = [];
      }
    }
    return stockRankData.value;
  }

  void logout(){
    isLogin.value = false;
    pw = '';
    user.value = User(name: '', account: '');
  }

  /// 세계지수
  /// 그리드에 나타낼 데이터 반환
  List<WorldStockPoint> getWorldIdxData(){
    worldData.value.clear();
    for(var item in seqWorldData){
      if(worldStockPoint.containsKey(item)){
        worldData.value.add(worldStockPoint[item]!);
      }
    }
    worldData.refresh();
    return worldData.value;
  }
}