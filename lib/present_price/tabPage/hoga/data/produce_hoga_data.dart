import 'dart:math';

import 'package:flutter_prac_jongmock/stock_data.dart';

import 'hoga_data.dart';

class ProduceHogaData {
  final ran = Random();

  int standardPrice = 0;

  double rate = 0.0;

  int getStandardPrice() => standardPrice;

  void setRate() {
    rate = double.parse(((ran.nextInt(10) - 5) / 10).toStringAsFixed(2));
    print(rate);
  }

  List<HogaData?> getSellHoga(Stock stock) {
    List<HogaData?> temp = [];
    final count = ran.nextInt(1000000);
    int price = stock.getPriceInt();
    int standard = stock.getYesterdayInt();
    double rate = double.parse(((price-standard)/standard * 100).toStringAsFixed(2));

    temp.add(HogaData(count, price, rate));
    if (this.rate == 0) {
      standardPrice = price;
    }

    temp.addAll(List.generate(9, (idx) {

      if (price > 100000) {
        price += 500;
      } else if (price > 50000) {
        price += 100;
      } else if (price > 10000) {
        price += 50;
      } else if (price > 1000) {
        price += 10;
      } else if (price <= 0) {
        return null;
      } else {
        price += 1;
      }
      rate = double.parse(((price-standard)/standard*100).toStringAsFixed(2));
      if (rate == 0) {
        standardPrice = price;
      }

      return HogaData(ran.nextInt(1000000), price, rate);
    }));
    return temp.reversed.toList();
  }

  List<HogaData?> getBuyHoga(Stock stock) {

    int price = stock.getPriceInt();
    int standard = stock.getYesterdayInt();

    return List.generate(10, (idx) {
      if (price > 100000) {
        price -= 500;
      } else if (price > 50000) {
        price -= 100;
      } else if (price > 10000) {
        price -= 50;
      } else if (price > 1000) {
        price -= 10;
      } else if (price <= 0) {
        return null;
      } else {
        price -= 1;
      }

      double rate = double.parse(((price-standard)/standard * 100).toStringAsFixed(2));

      if (rate == 0) {
        standardPrice = price;
      }

      return HogaData(ran.nextInt(1000000), price, rate);
    });
  }
}


