import 'package:flutter/material.dart';

/// 가로 구분선
/// @param color - 구분선 색 지정
class DivideLine extends StatelessWidget{
  final Color color;

  DivideLine(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:1,
      width: double.infinity,
      color: this.color
    );
  }

}