import 'package:flutter_prac_jongmock/data/user_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

class MyPageController extends GetxController{
  var user = User(name: '', account: '').obs;
  var pw = '';
  var isLogin = false.obs;

  var goTopVisibility = true.obs; // 화면 상단으로 스크롤 이동시키는 버튼 보이기/숨기기

  var bank = ['삼성증권', '타금융사'];
  var showAccountToggle = 0.obs; // 자산 정보 표시 토글 (삼성증권/타금융사)

  var currentTime = ''.obs;

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

  void logout(){
    isLogin.value = false;
    pw = '';
    user.value = User(name: '', account: '');
  }
}