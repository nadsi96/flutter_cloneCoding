import 'package:flutter_prac_jongmock/util.dart';

class User{
  final String name;
  final String account; // 계좌
  final int balance; // 잔액
  final int invest; // 투자금액
  final int returnOfInvest; // 투자수익

  User({required this.name, required this.account, this.balance = 0, this.invest = 0, this.returnOfInvest = 0});

  // 수익률
  String getRate(){
    return formatDoubleToStr((returnOfInvest/invest), needSign: true);
  }
}