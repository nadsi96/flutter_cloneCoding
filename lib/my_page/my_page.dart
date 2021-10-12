import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/my_page_controller.dart';
import 'package:flutter_prac_jongmock/controllers/tab_page_controller.dart';
import 'package:flutter_prac_jongmock/data/user_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

import 'input_pw.dart';

class MyPage extends StatelessWidget {
  final controller = Get.find<MyPageController>();
  final pageController = Get.find<TabPageController>();
  final scrollController = ScrollController();

  final double bigFont = 40;
  final double titleFont = 24;
  final double bigContentFont = 20;
  final double smallContentFont = 14;
  final double midContentFont = 18;

  /// 회색 밑줄이 있는 AppBar
  AppBar topBar() {
    return AppBar(
      leading: InkWell(
        onTap: () {
          goBack();
        },
        child: const TitleBarBackButton(),
      ),
      titleSpacing: 0,
      title: const Text(
        'My',
        style: TextStyle(
            fontSize: TITLEBAR_FONTSIZE,
            color: BLACK,
            fontWeight: FontWeight.normal),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15),
          child: const Icon(Icons.search, color: BLACK),
        ),
        Container(
          margin: const EdgeInsets.only(right: 15),
          child: const Icon(Icons.menu, color: BLACK),
        ),
      ],
      shadowColor: TRANSPARENT,
      backgroundColor: WHITE,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          color: LIGHTGRAY,
          height: 2,
        ),
      ),
    );
  }

  /// 이전 페이지로 이동
  void goBack() {
    pageController.backToPage();
    if (pageController.title.value != "My") {
      Get.back();
    }
  }

  /// 사용자 정보화면
  /// 로그인되지 않은 상태면 '로그인이 필요한 정보가 있습니다' 텍스트
  /// 로그인되면 사용자 정보 나타냄
  Widget userInfo() {
    final rankColor = Color.fromARGB(255, 83, 199, 184);

    return Obx(() {
      if (controller.isLogin.value) {
        final user = controller.user.value;

        // 로그인된 화면
        return SizedBox(
          height: 430,
          child: Column(
            children: [
              Container(
                height: 130,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                alignment: Alignment.centerLeft,
                color: WHITE,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: rankColor, width: 1.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Text(
                        user.rank,
                        style: TextStyle(
                            color: rankColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Text(
                      '${user.name}님 안녕하세요.',
                      style: TextStyle(
                          fontSize: bigContentFont,
                          color: BLACK,
                          fontWeight: FontWeight.w800),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Text(
                            '서비스 등급/혜택 조회',
                            style: TextStyle(fontSize: 12, color: DARKGRAY),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: const Icon(
                              Icons.chevron_right,
                              color: DARKGRAY,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      color: WHITE,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.fromLTRB(30, 10, 20, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '자산',
                            style: TextStyle(
                                fontSize: bigContentFont, color: BLACK),
                          ),
                          userInfoBankToggleBtn(),
                        ],
                      ),
                    ),
                    Expanded(
                        child: (controller.showAccountToggle.value == 0)
                            ? userInfoSamsung(user)
                            : userInfoOtherBank(user)),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        // 로그인되지 않은 화면
        return InkWell(
          onTap: () async {
            final pw = await Get.dialog(InputPw());
            if (controller.login(pw)) {}
          },
          child: Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            height: 80,
            color: BLUE,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '로그인이 필요한 정보가 있습니다.',
                  style: TextStyle(
                    fontSize: midContentFont,
                    color: WHITE,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50), color: WHITE),
                  child: const Icon(Icons.person_outline, color: BLUE),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  /// 삼성증권/타금융사 전환 토글
  Widget userInfoBankToggleBtn() {
    return Container(
      width: 180,
      height: 35,
      decoration: BoxDecoration(
        color: LIGHTGRAY,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(2, (idx) {
          return InkWell(
            onTap: () {
              controller.accountToggleClick();
            },
            child: Obx(() {
              final flag = controller.showAccountToggle.value == idx;
              return Container(
                width: 90,
                decoration: BoxDecoration(
                  color: (flag) ? BLUE : LIGHTGRAY,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    controller.bank[idx],
                    style: TextStyle(
                        color: (flag) ? WHITE : GRAY,
                        fontSize: smallContentFont),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  /// user 정보화면
  /// 로그인 후, 토글이 삼성증권으로 설정된 경우
  Widget userInfoSamsung(User user) {
    return Container(
      height: 200,
      color: WHITE,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(30, 5, 20, 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${user.balance}',
                      style: TextStyle(
                          fontSize: bigFont,
                          color: BLACK,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '원',
                      style: TextStyle(fontSize: bigContentFont, color: BLACK),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                userInfoRowItem('투자금액', '${user.invest} 원'),
                userInfoRowItem('투자수익', '${user.returnOfInvest} 원'),
                userInfoRowItem('수익률', '${user.getRate()} %'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '로그인 전 조회   ',
                      style: TextStyle(fontSize: 10, color: GRAY),
                    ),
                    const Icon(Icons.chevron_right, color: GRAY, size: 20),
                    const Spacer(),
                    Obx(() {
                      return Text(controller.currentTime.value,
                          style: const TextStyle(fontSize: 10, color: GRAY));
                    }),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () {
                          controller.refreshCurrentTime();
                        },
                        child: const Icon(
                          Icons.refresh,
                          color: BLACK,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ), // 로그인 전 조회 / 새로고침
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: GRAY),
                          right: BorderSide(color: GRAY),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '이체',
                          style: TextStyle(
                              fontSize: smallContentFont, color: BLACK),
                        ),
                      ),
                    ),
                  ),
                ), // 이체 버튼
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: GRAY),
                          right: BorderSide(color: GRAY),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '대출',
                          style: TextStyle(
                              fontSize: smallContentFont, color: BLACK),
                        ),
                      ),
                    ),
                  ),
                ), // 대출 버튼
              ],
            ),
          ), // 이체 / 대출 버튼
        ],
      ),
    );
  }

  /// user 정보화면
  /// 로그인 후, 토글이 타금융사로 설정된 경우
  Widget userInfoOtherBank(User user) {
    return Container(
        color: WHITE,
        padding: const EdgeInsets.fromLTRB(40, 30, 40, 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '다른 금융사의 내 계좌를 등록해보세요.',
                style: TextStyle(fontSize: smallContentFont, color: BLACK),
              ),
              Text(
                '등록한 계좌의 자산을 삼성증권에서',
                style: TextStyle(fontSize: smallContentFont, color: BLACK),
              ),
              Text(
                '조회할 수 있습니다.',
                style: TextStyle(fontSize: smallContentFont, color: BLACK),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple),
                  ),
                  child: Center(
                    child: Text(
                      '오픈뱅킹 서비스 신청',
                      style: TextStyle(
                          fontSize: smallContentFont, color: Colors.deepPurple),
                    ),
                  ))
            ]));
  }

  /// user 정보화면
  /// 로그인 후, 삼성증권 화면
  /// 투자금액, 투자수익, 수익률 행
  Widget userInfoRowItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: smallContentFont, color: BLACK),
        ),
        Text(
          value,
          style: TextStyle(fontSize: bigContentFont, color: BLACK),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar(),
      backgroundColor: LIGHTGRAY,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Obx(() {
              return (controller.goTopVisibility.value)
                  ? InkWell(
                      onTap: () {},
                      child: Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.only(right: 20, bottom: 50),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(150, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: GRAY),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_upward_sharp,
                            color: GRAY,
                          ),
                        ),
                      ),
                    )
                  : Container();
            }),
          ),
          SingleChildScrollView(
            controller: scrollController,
            child: Column(children: [
              userInfo(),
            ]),
          )
        ],
      ),
    );
  }
}
