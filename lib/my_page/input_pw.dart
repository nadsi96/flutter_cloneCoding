import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:get/get.dart';

/// 간편 비밀번호 입력
/// 임시
class InputPw extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InputPw();
  }
}

class _InputPw extends State<InputPw> {
  String pw = '';

  Widget showPw() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (idx) {
          if (idx < pw.length) {
            return const CircleAvatar(radius: 10, backgroundColor: BLACK);
          } else {
            return const CircleAvatar(radius: 8, backgroundColor: GRAY);
          }
        }),
      ),
    );
  }

  Widget numField() {
    return GridView.count(
      crossAxisCount: 5,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: List.generate(
        10,
        (idx) => InkWell(
          onTap: () {
            setState(() {
              pw = '$pw$idx';
              print(pw);
              if (pw.length == 6) {
                Get.back(result: pw);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: BLACK),
            ),
            child: Center(
              child: Text(
                idx.toString(),
                style: const TextStyle(fontSize: 14, color: BLACK),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(pw);
    return Scaffold(
      body: SizedBox(
        height: 500,
          child: Column(
        children: [
          showPw(),
          SizedBox(
            height: 300,
            child: numField(),
          ),
          Text('123456'),
        ],
      ),)
    );
  }
}
