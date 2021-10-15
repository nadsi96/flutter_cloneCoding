import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/commons/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/my_page_controller.dart';
import 'package:flutter_prac_jongmock/controllers/tab_page_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

/// 서비스등급조회
class CheckServiceRank extends StatelessWidget {
  final pageController = Get.find<TabPageController>();
  final myPageController = Get.find<MyPageController>();

  final double bigFont = 20;
  final double midFont = 18;
  final double smallFont = 16;
  final double ssmallFont = 14;

  CheckServiceRank({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => pageController.backToPage(),
          child: const TitleBarBackButton(),
        ),
        titleSpacing: 0,
        title: const Text('서비스등급조회',
            style: TextStyle(fontSize: TITLEBAR_FONTSIZE, color: BLACK)),
        shadowColor: TRANSPARENT,
        backgroundColor: WHITE,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: WHITE,
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: '서비스 등급에 따라\n다양한 혜택을 받으실 수 있습니다.\n',
                  style: TextStyle(
                      fontSize: bigFont,
                      color: BLUE,
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(

                        text: '\n전년도 평균 예탁자산과 거래실적에 따라\n올해의 등급이 정해집니다.',
                        style:
                            TextStyle(fontSize: ssmallFont, color: DARKGRAY)),
                  ],
                ),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 40),
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: BLACK))),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('나의 서비스 등급',
                        style: TextStyle(
                            fontSize: smallFont,
                            color: BLACK,
                            fontWeight: FontWeight.bold)),
                    Obx((){
                      final rank = myPageController.user.value.rank;
                      Color color;

                      if(rank == '일반'){
                        color = Colors.teal;
                      }else{
                        color = BLACK;
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                            border: Border.all(color: color),
                            borderRadius: BorderRadius.circular(3)),
                        child: Text(rank,
                            style: TextStyle(
                                fontSize: smallFont, color: Colors.teal, fontWeight: FontWeight.bold)),
                      );
                    }),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('나의 혜택',
                        style: TextStyle(
                            fontSize: smallFont,
                            color: BLACK,
                            fontWeight: FontWeight.bold)),
                    Container(
                      color: DARKBLUE,
                      height: 80,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 10),
                      child: Text('입출금/이체수수료 혜택',
                          style: TextStyle(fontSize: midFont, color: WHITE)),
                    ),
                    Container(
                      color: DARKBLUE,
                      height: 80,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 10),
                      child: Text('부가수수료 혜택',
                          style: TextStyle(fontSize: midFont, color: WHITE)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: WHITE,
    );
  }
}
