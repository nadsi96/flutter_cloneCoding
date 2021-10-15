import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/util.dart';

Widget stockInfo(Stock stock){
  Color fontColor = getColorWithSign(stock.sign);

  return Container(
    height: 70,
    padding: const EdgeInsets.all(10),
    color: WHITE,
    child: Row(
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 10, right: 20),
          child: Image.asset(getGraphImgPathWithSign(stock.sign), height: 30, fit: BoxFit.fitHeight,)
        ),
        Expanded(
          child: Text(formatStringComma(stock.price), style: TextStyle(fontSize: 28, color: fontColor))
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getIconWithSign(stock.sign) ?? const Spacer(),
                  Text(formatStringComma(stock.dist), style: TextStyle(fontSize: 14, color: fontColor))
                ],
              ),
              Text('${formatStringComma(stock.count)}주', style: const TextStyle(fontSize: 14, color: BLACK),),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(stock.getDrate(), style: TextStyle(fontSize: 26, color: fontColor)),
              Text(' %', style: TextStyle(fontSize: 16, color: fontColor)),
            ],
          ),
        ),
      ],
    ),
  );
}