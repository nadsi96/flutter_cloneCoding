import 'package:flutter/material.dart';

// KOSPI, KOSDAQ, 상해종합
class BottomTextBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color.fromARGB(255, 189, 189, 189),
        child: Row(children: [
          Expanded(
              child: Text("KOSDAQ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center,),
              flex: 2),
          Expanded(
              child: Text("1,026.34",
                  style: TextStyle(fontSize: 12, color: Colors.blue), textAlign: TextAlign.center),
              flex: 2),
          Expanded(
              child: Row(children: [
                Icon(Icons.arrow_drop_down, color: Colors.blue),
                Text("11.57(1.11%)", style: TextStyle(fontSize: 12, color: Colors.blue))
              ]),
              flex: 3),
          Expanded(
              child: Text("단일가",
                  style: TextStyle(fontSize: 12, color: Colors.black45), textAlign: TextAlign.center),
              flex: 2)
        ]));
  }
}