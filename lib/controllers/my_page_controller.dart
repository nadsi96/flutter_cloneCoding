import 'package:flutter_prac_jongmock/data/user_data.dart';
import 'package:get/get.dart';

class MyPageController extends GetxController{
  var user = User(name: '', account: '').obs;
  var isLogin = false.obs;
}