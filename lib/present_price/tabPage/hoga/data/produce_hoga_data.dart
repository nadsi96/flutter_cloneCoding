import 'dart:math';

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

  List<HogaData?> getSellHoga(int price) {
    List<HogaData?> temp = [];
    temp.add(HogaData(ran.nextInt(1000000), price, this.rate));
    if (this.rate == 0) {
      standardPrice = price;
    }

    double rate = this.rate;
    temp.addAll(List.generate(9, (idx) {
      rate = double.parse((rate + 0.1).toStringAsFixed(2));

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

      if (rate == 0) {
        standardPrice = price;
      }

      return HogaData(ran.nextInt(1000000), price, rate);
    }));
    return temp.reversed.toList();
  }

  List<HogaData?> getBuyHoga(int price) {
    return List.generate(10, (idx) {
      rate = double.parse((rate - 0.1).toStringAsFixed(2));

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

      if (rate == 0) {
        standardPrice = price;
      }

      return HogaData(ran.nextInt(1000000), price, rate);
    });
  }
}


