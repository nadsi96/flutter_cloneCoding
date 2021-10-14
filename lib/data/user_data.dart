import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:intl/intl.dart';

class User {
  final String name;
  final String rank; // 등급 // 일반
  final String account; // 계좌
  final int balance; // 잔액
  final int invest; // 투자금액
  final int returnOfInvest; // 투자수익

  User({
    required this.name,
    this.rank = '일반',
    required this.account,
    this.balance = 100,
    this.invest = 0,
    this.returnOfInvest = 0,
  }) {
    // stockGroups = (name != '')
    //     ? {
    //         '관심그룹1': ['카카오', '크래프톤'],
    //         '관심그룹2': ['삼성전자', '농심', 'Naver'],
    //       }
    //     : {};
  }

  // 수익률
  String getRate() {
    final double result = (invest != 0) ? returnOfInvest / invest : 0;
    var f = NumberFormat("#0.00", "en_US");
    return (result != 0) ? f.format(result.abs()) : '0';
  }
}

final Map<String, List<String>> stockGroupsData = {
  '관심그룹1': ['카카오', '크래프톤'],
  '관심그룹2': ['삼성전자', '농심', 'Naver'],
  '빈 관심그룹' : [],
};
final Map<String, User> usersData = {
  '123456': User(name: '나형표', account: '12345689'),
  '000000': User(name: '표형나', account: '12345689', balance: 1000),
};
