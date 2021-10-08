


import 'dart:convert';

import 'package:intl/intl.dart';


const double TITLEBAR_FONTSIZE = 16;




///
/// 유니코드 값 = ((초성 21) + 중성) 28 + 종성 + 0xAC00
///  ||
///  V
/// 초성 = ((문자코드 – 0xAC00) / 28) / 21
/// 중성 = ((문자코드 – 0xAC00) / 28) % 21
/// 종성 = (문자코드 – 0xAC00) % 28

/// 한 글자
/// 초성 값 반환
double checkTopConsonant(String input){
  var rCho = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"];
  var rJung = ["ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"];
  var rJong = ["", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"];

  var cho, jung, jong;
  var nTmp=(input.runes.first - 0xAC00);
  jong=nTmp % 28; // 종성
  jung=( (nTmp-jong)/28 ) % 21; // 중성
  cho=( ( (nTmp-jong)/28 ) - jung ) / 21; // 종성

  print(
      "초성:"+rCho[cho]+"\n"
          +"중성:"+rJung[jung]+"\n"
          +"종성:"+rJong[jong]
  );

  var code = ((input.runes.first - 0xAC00) / 28) / 21;
  return ((input.runes.first - 0xAC00) / 28) / 21;
}

/// 한 글자
/// 한글인지 확인
/// 한글 Unicode         -> 12593 <= 자음 <= 12643
/// 자음과 모음을 합친 경우 -> 44032 <= '가' 부터 '힣'까지 <= 55203
bool isKorean(String input){
  bool isKorean = false;
  int inputToUniCode   = input.codeUnits[0];
  isKorean =  (inputToUniCode >= 12593 && inputToUniCode <= 12643) ? true : (inputToUniCode >= 44032 && inputToUniCode <= 55203) ? true : false;
  return isKorean;
}
/*

/// a가 b에 포함되는 초성인지 확인
bool isTopEqual(String a, String b){

}*/


/// 세자리마다 쉼표
String formatIntToStr(int item) {
  var f = NumberFormat("###,###,###,###,###,###");
  return f.format(item);
}


/// 0.00 형식
String formatDoubleToStr(double item, {bool needSign = true}) {
  var f = NumberFormat("#0.00", "en_US");
  return "${(needSign)? f.format(item) : f.format(item.abs())}%";
}

/// 공백에 0이 채워지는 두자리 정수
String formatIntToStringLen2(int item){
  return NumberFormat("#00").format(item);
}