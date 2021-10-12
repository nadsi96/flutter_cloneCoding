import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/controllers/my_page_controller.dart';
import 'package:get/get.dart';

class MyPage extends StatelessWidget{

  final controller = Get.find<MyPageController>();

  Widget topBar(){
    return AppBar(
      leading: InkWell(
        onTap: (){

        },
        child: const TitleBarBackButton(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}