import 'package:flutter/material.dart';

import 'widget_button.dart';


// 0 - 현재가
// 1 - 예상가
// 2 - 단일가
var flag = 0;

class BtnPrice extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _BtnPrice();
  }
}

class _BtnPrice extends State<BtnPrice>{

  final TEXTS = ["현재가", "예상가", "단일가"];

  _BtnPrice();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        children: [
          Button("현재가", null, width: 60, alignment: Alignment.centerLeft, margin: 5, padding: 5),
          setIcon()
        ],
      ),
      onTap: () {
        setState((){
          flag = (flag+1)%3;
        });
      },
    );
  }


  // 현재가 버튼 우측에 점
  Widget setIcon(){
    final colorBoxs = <Container>[];
    for(var i = 0; i < 3; i++){
      var color = Colors.black45;
      if(i == flag){
        color = Colors.blue;
      }
      colorBoxs.add(
        Container(
          color: color
        )
      );
    }

    return Container(
      child:Column(
        children: colorBoxs,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.all(5)
    );
  }
}