


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'colors.dart';


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

String formatStringComma(String item){
  int cnt = 0;
  String temp = '';
  for(int i = item.length-1; i >= 0 ; i--){
    temp = '${item[i]}$temp';
    if(++cnt == 3 && i != 0){
      temp = ',$temp';
      cnt = 0;
    }
  }
  return temp;
}
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

// 부호 따라 색 반환
Color getColorWithSign(int sign){
  switch(sign){
    case 1:
      return RED;
    case -1:
      return BLUE;
    default:
      return BLACK;
  }
}

/// 부호따라 그래프 이미지 경로
String getGraphImgPathWithSign(int sign){
  switch(sign){
    case 1:
      return 'assets/images/img1.png';
    case -1:
      return 'assets/images/img2.png';
    default:
      return 'assets/images/img3.png';
  }
}

Icon? getIconWithSign(int sign){
  switch(sign){
    case 1:
      return const Icon(Icons.arrow_drop_up, color: RED, size: 30);
    case -1:
      return const Icon(Icons.arrow_drop_down, color: BLUE, size: 30);
    default:
      return null;
  }
}