import 'package:flutter/material.dart';

/// 상단바
/// 타이틀, 메시지, 옵션메뉴
class TopBar extends StatelessWidget {
  final String pageTitle;

  TopBar(this.pageTitle);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(children: [
          Expanded(child: Text(pageTitle, style: TextStyle(fontSize: 18))),
          IconButton(
            icon: Icon(Icons.email_outlined),
            onPressed: null,
          ),
          IconButton(icon: Icon(Icons.menu), onPressed: null)
        ]));
  }
}