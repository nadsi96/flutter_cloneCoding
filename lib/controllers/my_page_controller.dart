import 'package:flutter_prac_jongmock/data/stock_rank_data.dart';
import 'package:flutter_prac_jongmock/data/user_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

class MyPageController extends GetxController{
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

  List<String> getStockRankTypes(){
    if(stockRanktype.containsKey(typeRankToggle.value)){
      return stockRanktype[typeRankToggle.value]!;
    }else{
      return stockRanktype.values.first;
    }
  }

  void logout(){
    isLogin.value = false;
    pw = '';
    user.value = User(name: '', account: '');
  }
}