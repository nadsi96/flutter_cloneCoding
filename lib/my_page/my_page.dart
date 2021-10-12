import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/controllers/my_page_controller.dart';
import 'package:flutter_prac_jongmock/controllers/tab_page_controller.dart';
import 'package:get/get.dart';

class MyPage extends StatelessWidget{

  final controller = Get.find<MyPageController>();
  final pageController = Get.find<TabPageController>();

  AppBar topBar(){
    return AppBar(
      leading: InkWell(
        onTap: (){
          pageController.backToPage();
          if (pageController.title.value != "My") {
            Get.back();
          }
        },
        child: const TitleBarBackButton(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(),
    );
  }

}