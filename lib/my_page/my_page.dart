import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/my_page_controller.dart';
import 'package:flutter_prac_jongmock/controllers/tab_page_controller.dart';
import 'package:flutter_prac_jongmock/data/stock_rank_data.dart';
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

  final double space = 10;

  MyPage({Key? key}) : super(key: key);

  /// 회색 밑줄이 있는 AppBar
  AppBar topBar() {
    return AppBar(
      leading: Obx(() {
        return (pageController.pageStackCnt.value > 1)
            ? InkWell(
                onTap: () {
                  goBack();
                },
                child: const TitleBarBackButton(),
              )
            : Container();
      }),
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
    const rankColor = Color.fromARGB(255, 83, 199, 184);

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
                        style: const TextStyle(
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
                      margin: EdgeInsets.only(top: space),
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
  /// 잔액, 투자금액, 투자수익, 수익률
  /// 새로고침된(위 정보 불러온) 시간
  /// 이체/대출 버튼
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
                SizedBox(height: space),
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
            ),
          ),
        ],
      ),
    );
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

  /// 종목순위
  ///
  Widget stockRank() {
    const double horizonPadding = 20;

    return Container(
      margin: EdgeInsets.only(top: space),
      color: WHITE,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 30),
            padding: const EdgeInsets.only(left: horizonPadding, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '종목순위',
                  style: TextStyle(
                      fontSize: midContentFont,
                      color: BLACK,
                      fontWeight: FontWeight.w700),
                ),
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: DARKGRAY),
                  ),
                  child: Center(
                    child: Text(
                      'i',
                      style: TextStyle(
                          fontSize: smallContentFont, color: DARKGRAY),
                    ),
                  ),
                ),
                const Spacer(),
                stockRankToggle(), // 국내/나스닥 토글
              ],
            ),
          ), // 종목순위 타이틀. 국내/나스닥 토글
          Container(
            padding: const EdgeInsets.symmetric(horizontal: horizonPadding),
            child: Obx(() {
              final type = controller.typeRankToggle.value;
              print('type $type');
              final items = controller.getStockRankTypes();
              return Row(
                children: List.generate(items.length, (idx) {
                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        controller.selectedStockRankTab[type]!.value =
                            items[idx];
                      },
                      child: Obx(() {
                        return BlueGrayButton(
                            text: items[idx],
                            isSelected: (items[idx] ==
                                controller.selectedStockRankTab[type]!.value),
                            fontSize: smallContentFont);
                      }),
                    ),
                  );
                }),
              );
            }),
          ),
          Obx(() {
            final dataList = controller.getStockRankData();
            return _stockRankList(dataList);
          }),
        ],
      ),
    );
  }

  /// 종목순위
  /// 국내/나스닥 토글
  Widget stockRankToggle() {
    return Container(
      width: 180,
      height: 35,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: LIGHTGRAY,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(controller.stockRanktype.keys.length, (idx) {
          final text = controller.stockRanktype.keys.elementAt(idx);
          return InkWell(
            onTap: () {
              controller.typeRankToggle.value = text;
            },
            child: Obx(() {
              final flag = controller.typeRankToggle.value == text;
              return Container(
                width: 90,
                decoration: BoxDecoration(
                  color: (flag) ? BLUE : LIGHTGRAY,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    controller.stockRanktype.keys.elementAt(idx),
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

  /// 종목순위 리스트
  /// 상승률,거래대금, 외인순매수, 기관순매수 선택에 따라 받은 배열을 리스트뷰로 출력
  Widget _stockRankList(List<StockData> dataList) {
    const double itemSize = 60; // 행 높이
    const double showMoreSize = 50; // 더보기 칸 높이
    final double boxSize = itemSize * (dataList.length) + showMoreSize; // 종목순위 영역 높이

    final dataListView = List.generate(dataList.length, (index) {
      return _stockRankListItem(dataList[index], index + 1, itemSize);
    });
    dataListView.add(
      SizedBox(
        height: showMoreSize,
        child: InkWell(
          onTap: (){

          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '더보기',
                style: TextStyle(fontSize: smallContentFont, color: BLACK),
              ),
              const Icon(Icons.chevron_right, size: 20, color: BLACK),
            ],
          ),
        ),
      ),
    );

    return SizedBox(
      height: boxSize,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: dataListView,
      ),
    );
  }

  /// 종목순위 리스트 항목
  Widget _stockRankListItem(StockData data, int idx, double itemSize) {
    const double fontSize = 14;
    final textColor = getColor(data.sign);

    return Container(
        height: itemSize,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: const Border(
            bottom: BorderSide(color: LIGHTGRAY),
          ),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              '$idx',
              style: const TextStyle(fontSize: fontSize, color: BLACK),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(right: 20),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  data.name,
                  style: const TextStyle(fontSize: fontSize, color: BLACK),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text(
                      data.price,
                      style: TextStyle(fontSize: fontSize, color: textColor),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            getSign(data.sign),
                            Text(
                              '${data.dist}',
                              style: TextStyle(
                                  fontSize: fontSize, color: textColor),
                            ),
                          ],
                        ),
                        Text(
                          '${data.drate}%',
                          style:
                              TextStyle(fontSize: fontSize, color: textColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]));
  }

  /// 대비기호
  Widget getSign(int sign) {
    switch (sign) {
      case 1:
        return const Icon(Icons.arrow_drop_up, color: RED);
      case -1:
        return const Icon(Icons.arrow_drop_down, color: BLUE);
      default:
        return const Spacer();
    }
  }

  Color getColor(int sign) {
    switch (sign) {
      case 1:
        return RED;
      case -1:
        return BLUE;
      default:
        return BLACK;
    }
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
              return (!controller.goTopVisibility.value)
                  ? InkWell(
                      onTap: () {
                        // 스크롤 맨 위로
                        if (scrollController.hasClients) {
                          scrollController.jumpTo(0);
                          controller.goTopVisibility.value = false;
                        }
                      },
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
          ), // 스크롤 맨 위로 올리는 버튼. 스크롤 위치가 맨 위면 그리지 않음
          SingleChildScrollView(
            controller: scrollController,
            child: NotificationListener(
              onNotification: (notification) {
                if (scrollController.hasClients &&
                    scrollController.offset != 0) {
                  controller.goTopVisibility.value = true;
                }
                return false;
              },
              child: Column(children: [
                userInfo(), // 회원 정보
                stockRank(), // 종목순위
              ]),
            ),
          )
        ],
      ),
    );
  }
}
