import 'dart:math';

import 'package:flutter_prac_jongmock/util.dart';

int _orderCount = 0;

List<OrderedStock> orderstockList = [];

class OrderedStock{
  final String stock; // 종목 명
  final String contractType; // 거래유형 (현금매수/현금매도/정정/취소)
  final String orderCount; // 주문수량
  final String orderUnitPrice; // 주문단가
  final String waiting; // 미체결수량
  final String done; // 체결수량
  final String orderTime; // 주문시간
  String orderNum = ''; // 주문번호
  final String type; // 주문구분(보통/시장가/)
  String contractPrice = ''; // 체결단가

  OrderedStock({required this.stock, required this.contractType, required this.orderCount,
  required this.orderUnitPrice,
  required this.waiting,
    this.done = '0',
    required this.orderTime,
    required this.type,
  }){
    orderNum = (++_orderCount).toString();
    contractPrice = formatIntToStr(Random().nextInt(100000));
  }
}