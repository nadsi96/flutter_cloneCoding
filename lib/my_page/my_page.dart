import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/controllers/my_page_controller.dart';
import 'package:flutter_prac_jongmock/controllers/tab_page_controller.dart';
import 'package:flutter_prac_jongmock/data/stock_rank_data.dart';
import 'package:flutter_prac_jongmock/data/user_data.dart';
import 'package:flutter_prac_jongmock/data/world_idx_data.dart';
import 'package:flutter_prac_jongmock/my_page/dialogs.dart';
import 'package:flutter_prac_jongmock/present_price/tabPage/news/news_detail.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

import 'input_pw.dart';

class MyPage extends StatelessWidget {
  final mainController = Get.find<MainController>();
  final myPageController = Get.find<MyPageController>();
  final pageController = Get.find<TabPageController>();
  final scrollController = ScrollController();

  late final defaultStocks = mainController.stocks.value; // 기본 보유 목록

  User? user;

  final double bigFont = 40;
  final double titleFont = 22;
  final double bigContentFont = 18;
  final double smallContentFont = 14;
  final double midContentFont = 16;

  final double space = 10;
  final marginSpace = const EdgeInsets.only(top: 10); // 영역간 margin
  final titleStyle =
      const TextStyle(fontSize: 18, color: BLACK, fontWeight: FontWeight.w700);

  final myPageDialogs = MyPageDialogs();

  MyPage({Key? key}) : super(key: key);

  /// 회색 밑줄이 있는 AppBar
  AppBar topBar() {
    return AppBar(
      leading: Obx(() {
        return (pageController.pageStackCnt.value > 1)
            ? InkWell(
          splashColor: TRANSPARENT,
                onTap: () => goBack(),
                child: const TitleBarBackButton(),
              )
            : Container();
      }),
      titleSpacing: 0,
      title: const Text(
        'MY',
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
        InkWell(
          splashColor: TRANSPARENT,
          onTap: (){
            if(myPageController.isLogin.value){
              myPageController.logout();
              user = null;
            }
          },
          child: Container(
            margin: const EdgeInsets.only(right: 15),
            child: const Icon(Icons.menu, color: BLACK),
          ),
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
      if (myPageController.isLogin.value && user != null) {
        // final user = myPageController.user.value;

        // 로그인된 화면
        //
        // col [자산 - 토글]
        //     [토글 상태 따른 정보 rows]
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
                        user!.rank,
                        style: const TextStyle(
                            color: rankColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Text(
                      '${user!.name}님 안녕하세요.',
                      style: TextStyle(
                          fontSize: bigContentFont,
                          color: BLACK,
                          fontWeight: FontWeight.w800),
                    ),
                    InkWell(
                      splashColor: TRANSPARENT,
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
                        child: (myPageController.showAccountToggle.value == 0)
                            ? userInfoSamsung(user!)
                            : userInfoOtherBank(user!)),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        // 로그인되지 않은 화면
        return InkWell(
          splashColor: TRANSPARENT,
          onTap: () async {
            // 로그인
            final pw = await Get.dialog(InputPw());
            if (myPageController.login(pw)) {
              user = usersData[pw];
            }
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
            splashColor: TRANSPARENT,
            onTap: () {
              myPageController.accountToggleClick();
            },
            child: Obx(() {
              final flag = myPageController.showAccountToggle.value == idx;
              return Container(
                width: 90,
                decoration: BoxDecoration(
                  color: (flag) ? BLUE : LIGHTGRAY,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    myPageController.bank[idx],
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
                      formatIntToStr(user.balance),
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
                      return Text(myPageController.currentTime.value,
                          style: const TextStyle(fontSize: 10, color: GRAY));
                    }),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: InkWell(
                        splashColor: TRANSPARENT,
                        onTap: () {
                          myPageController.refreshCurrentTime();
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

    // col [종목순위 - 토글]
    //     [row 탭]
    //     [listview]
    return Container(
      margin: marginSpace,
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
                  style: titleStyle,
                ),
                InkWell(
                  onTap: () => Get.dialog(myPageDialogs.stockRank()),
                  child: Container(
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
                ),
                const Spacer(),
                stockRankToggle(), // 국내/나스닥 토글
              ],
            ),
          ), // 종목순위 타이틀. 국내/나스닥 토글
          Container(
            padding: const EdgeInsets.symmetric(horizontal: horizonPadding),
            child: Obx(() {
              final type = myPageController.typeRankToggle.value;
              print('type $type');
              final items = myPageController.getStockRankTypes();
              return Row(
                children: List.generate(items.length, (idx) {
                  return Expanded(
                    child: InkWell(
                      onTap: () {
                        myPageController.selectedStockRankTab[type]!.value =
                            items[idx];
                      },
                      child: Obx(() {
                        return BlueGrayButton(
                            text: items[idx],
                            isSelected: (items[idx] ==
                                myPageController
                                    .selectedStockRankTab[type]!.value),
                            fontSize: smallContentFont);
                      }),
                    ),
                  );
                }),
              );
            }),
          ), // 국내/나스닥 선택에 따라 탭버튼 생성
          Obx(() {
            final dataList = myPageController.getStockRankData(); // 설정된 순위 리스트
            return _stockRankList(dataList);
          }), // 종목순위 리스트뷰
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
        children:
            List.generate(myPageController.stockRanktype.keys.length, (idx) {
          final text = myPageController.stockRanktype.keys.elementAt(idx);
          return InkWell(
            onTap: () {
              myPageController.stockRankTypeToggleClick(); // 국내/나스닥 전환
            },
            child: Obx(() {
              final flag = myPageController.typeRankToggle.value == text;
              return Container(
                width: 90,
                decoration: BoxDecoration(
                  color: (flag) ? BLUE : LIGHTGRAY,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    myPageController.stockRanktype.keys.elementAt(idx),
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
    final double boxSize =
        itemSize * (dataList.length) + showMoreSize; // 종목순위 영역 높이

    final dataListView = List.generate(dataList.length, (index) {
      return _stockRankListItem(dataList[index], index + 1, itemSize);
    });
    dataListView.add(
      SizedBox(
        height: showMoreSize,
        child: InkWell(
          onTap: () {},
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
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: LIGHTGRAY),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                ), // 가격
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
                ), // 대비기호, 등락폭, 등락율
              ],
            ),
          ), // 가격 / 대비기호, 등락폭, 등락율
        ],
      ),
    );
  }

  /// 세계지수
  ///
  Widget worldStock() {
    const gridChildRatio = 1.25; // gridItem 크기 비율 (w/h)
    final double gridViewHeight =
        (Get.width / 2 / gridChildRatio) * 3; // gridview 높이
    return Container(
      color: WHITE,
      margin: marginSpace,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Text('세계지수', style: titleStyle),
              ),
              const Spacer(),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.settings_outlined, color: DARKGRAY),
                ),
              ), // 설정
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.chevron_right, color: BLACK),
                ),
              ), // 추가정보
            ],
          ), // 타이틀부분
          SizedBox(
            height: gridViewHeight,
            child: Obx(() {
              final data = myPageController.getWorldIdxData();
              return GridView.count(
                crossAxisCount: 2,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: gridChildRatio,
                children:
                    List.generate(data.length, (idx) => gridItem(data[idx])),
              );
            }),
          ), // 데이터
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: const Text(
              '※해외지수는 종가 또는 지연 시세로 제공됩니다.',
              style: TextStyle(fontSize: 12, color: BLACK),
            ),
          ), // 하단 텍스트
        ],
      ),
    );
  }

  /// 세계지수 그리드 항목
  Widget gridItem(WorldStockPoint data) {
    final textColor = getColor(data.sign);
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: LIGHTGRAY),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                data.name,
                style: TextStyle(fontSize: midContentFont, color: BLACK),
              ),
            ),
            Text(
              data.point,
              style: TextStyle(
                  fontSize: titleFont,
                  color: textColor,
                  fontWeight: FontWeight.w700),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getSign(data.sign),
                Text(
                  data.dist,
                  style: TextStyle(fontSize: midContentFont, color: textColor),
                ),
                const SizedBox(width: 20),
                Text(
                  '${data.drate}%',
                  style: TextStyle(fontSize: midContentFont, color: textColor),
                ),
              ],
            ),
            Text(
              data.date,
              style: TextStyle(fontSize: smallContentFont, color: DARKGRAY),
            ),
          ],
        ),
      ),
    );
  }

  /// 관심그룹
  /// 항목 클릭시 해당 주식 호가창(주식현재가 - 호가)으로 이동(해야됨)
  Widget stockGroup() {

    return Container(
      margin: marginSpace,
      color: WHITE,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final List<String> groups = myPageController.stockGroups.value.keys.toList();
                      final currentSelected = myPageController.selectedStockGroup.value;
                      final selected = await Get.dialog(myPageDialogs.selectStockGroup(groups, currentSelected),barrierDismissible: false);
                      print('selected: $selected');
                      if(selected != null){
                        myPageController.selectedStockGroup.value = selected;
                      }
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.menu, color: BLACK),
                        Obx(() {
                          final groupName =
                              myPageController.selectedStockGroup.value;
                          return Text(groupName, style: titleStyle);
                        }),
                      ],
                    ),
                  ),
                ), // 그룹 선택
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        // 국가별 시세
                        onTap: () {
                          Get.dialog(myPageDialogs.realtimePrice());
                        },
                        child: Container(
                          color: LIGHTGRAY,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          alignment: Alignment.center,
                          child: Text(
                            '국가별 시세',
                            style: TextStyle(
                                fontSize: smallContentFont, color: BLACK),
                          ),
                        ),
                      ),
                      InkWell(
                        // 종목/그룹 편집
                        // 등록화면 종목편집으로 이동
                        onTap: () {},
                        child: const Icon(Icons.settings_outlined,
                            color: DARKGRAY, size: 28),
                      ),
                      InkWell(
                        // 관심종목 이동
                        onTap: () {pageController.goToPage('관심종목');},
                        child: const Icon(Icons.chevron_right,
                            color: BLACK, size: 32),
                      ),
                    ],
                  ),
                ), // 국가별 시세 정보, 설정, 관심종목 이동
              ],
            ),
          ), // 타이틀부분
          Obx(() {
            final data = myPageController.stockGroups.value[myPageController.selectedStockGroup.value] ?? [];
            // 데이터가 있으면 리스트 그리고, 없으면 안내내용
            return (data.isNotEmpty) ? stockList(data) : emptyStockGroup();
          }), // 주식 목록 리스트뷰. 선택한 그룹의 주식목록 출력
        ],
      ),
    );
  }

  /// 주식 목록 리스트뷰
  Widget stockList(List<String> data) {
    const double itemHeight = 65;

    // 리스트뷰에 들어갈 뷰아이템 리스트 생성
    final List<Widget> itemList = [];
    for (var i = 0; i < data.length; i++) {
      final stock = stockData[data[i]]?.elementAt(0);
      if (stock == null) {
        continue;
      } else {
        itemList.add(stockItem(stock, itemHeight));
      }
    }

    return SizedBox(
      height: itemHeight * data.length,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: itemList,
      ),
    );
  }

  /// 주식 리스트뷰 항목
  Widget stockItem(Stock stock, double height) {
    final String imgPath;
    final String? rateImg;
    Color textColor;
    if (stock.getRate() > 0) {
      textColor = RED;
      imgPath = 'assets/images/img1.png';
      rateImg = 'assets/images/rateImg1.png';
    } else if (stock.getRate() < 0) {
      textColor = BLUE;
      imgPath = 'assets/images/img2.png';
      rateImg = 'assets/images/rateImg2.png';
    } else {
      textColor = BLACK;
      imgPath = 'assets/images/img3.png';
      rateImg = null;
    }
    return Container(
      height: height,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: GRAY),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            // 캔들그래프, 종목명, 분야
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Image.asset(imgPath, fit: BoxFit.fitHeight),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      stock.getTitle(),
                      style: TextStyle(fontSize: bigContentFont, color: BLACK),
                    ),
                    Text(
                      stock.getType(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: LIGHTGRAY,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ), // 캔들그래프, 종목명, 분야
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          stock.getPrice(),
                          style: TextStyle(
                              fontSize: bigContentFont, color: textColor),
                        ),
                        Text(
                          stock.getCount(),
                          style: TextStyle(
                              fontSize: smallContentFont, color: BLACK),
                        ),
                      ]),
                ),
                Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(top: 5, left: 20),
                  child: (rateImg != null)
                      ? Image.asset(rateImg, height: 12)
                      : null,
                ),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                      Text(
                        stock.getVarStr(),
                        style: TextStyle(
                            fontSize: midContentFont, color: textColor),
                      ),
                      Text(
                        stock.getRateStr(),
                        style: TextStyle(
                            fontSize: midContentFont, color: textColor),
                      ),
                    ]))
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 관심종목
  /// 등록한 관심그룹이 없는 경우
  Widget emptyStockGroup(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text('등록 종목이 없습니다.', style: TextStyle(fontSize: bigContentFont, color: BLACK)),
          ),
        ),
        InkWell(
            onTap: (){},
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(border: Border.all(color: Colors.deepPurple), borderRadius: BorderRadius.circular(3)),
              child: Text('등록', style: TextStyle(fontSize: midContentFont, color: Colors.deepPurple)),
            ),
          ),
      ],
    );
  }

  /// FAQ, 챗봇문의, 투자스쿨 배너
  Widget clientCenter() {
    return Column(
      children: [
        Container(
          color: WHITE,
          margin: marginSpace,
          padding: const EdgeInsets.all(10),
          height: 80,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: (Get.width / 2) / 60,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  color: const Color.fromARGB(255, 58, 160, 241),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/img1.png',
                          width: 30, height: 30),
                      Text(
                        '자주묻는 질문',
                        style:
                            TextStyle(color: WHITE, fontSize: midContentFont),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  color: const Color.fromARGB(255, 1, 120, 206),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/img1.png',
                          width: 30, height: 30),
                      Text(
                        '챗봇문의',
                        style:
                            TextStyle(color: WHITE, fontSize: midContentFont),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ), // 자주 묻는 질문, 챗봇문의
        InkWell(
          onTap: () {},
          child: Container(
            color: WHITE,
            margin: marginSpace,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Image.asset('assets/images/samsung_school.jpg'),
          ),
        ),
      ],
    );
  }

  /// 국내뉴스
  /// 항목 클릭시 뉴스 상세화면 이동
  Widget news() {
    return Container(
      color: WHITE,
      margin: marginSpace,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: GRAY),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text('국내뉴스', style: titleStyle),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    myPageController.refreshNewsUpdateTime();
                  },
                  child: const Icon(Icons.refresh, color: BLACK, size: 26),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Obx(() {
                    return Text(
                      myPageController.getNewsUpdateTime(),
                      style:
                          TextStyle(fontSize: smallContentFont, color: BLACK),
                    );
                  }),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child:
                        const Icon(Icons.chevron_right, size: 30, color: BLACK),
                  ),
                ),
              ],
            ),
          ), // 타이틀부분
          Obx(() {
            final data = myPageController.newsList.value;
            return Column(
              children: List.generate(
                data.length,
                (idx) => InkWell(
                  onTap: () {
                    Get.dialog(NewsDetail(newsData: data[idx]));
                  },
                  child: newsItemView(data[idx].title),
                ),
              ),
            );
          }), // 뉴스항목
        ],
      ),
    );
  }

  /// 이슈스케쥴
  Widget issueSchedule() {
    return Container(
      color: WHITE,
      margin: marginSpace,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: GRAY),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                      '이슈스케줄 ${formatIntToStringLen2(myPageController.newsUpdateTime.value.month)}-${formatIntToStringLen2(myPageController.newsUpdateTime.value.day)}',
                      style: titleStyle),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child:
                        const Icon(Icons.chevron_right, size: 30, color: BLACK),
                  ),
                ),
              ],
            ),
          ), // 타이틀부분
          Obx(() {
            final data = myPageController.issueList.value;
            return Column(
              children: List.generate(
                data.length,
                (idx) => InkWell(
                  onTap: () {
                    // 상세화면 다이얼로그 띄움
                    Get.dialog(myPageDialogs.issueScheduleDialog(
                        data[idx].title, data[idx].contents));
                  },
                  child: newsItemView(data[idx].title),
                ),
              ),
            );
          }), // 이슈스케줄 항목
        ],
      ),
    );
  }

  /// 국내뉴스, 이슈스케줄 항목 뷰
  /// 타이틀 한 줄. 너비 넘어가면 ...
  Widget newsItemView(String title) {
    return Container(
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: GRAY),
        ),
      ),
      child: Text(title,
          style: TextStyle(fontSize: midContentFont, color: BLACK),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );
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
          NotificationListener(
            onNotification: (notification) {
              if (scrollController.hasClients && scrollController.offset != 0) {
                myPageController.goTopVisibility.value = true;
              } else if (scrollController.hasClients &&
                  scrollController.offset == 0) {
                myPageController.goTopVisibility.value = false;
              }
              return true;
            },
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(children: [
                userInfo(), // 회원 정보
                stockRank(), // 종목순위
                worldStock(), // 세계지수
                stockGroup(), // 관심그룹(보유주식목록)
                clientCenter(), // 자주 묻는 질문, 챗봇문의, 투자스쿨 배너
                news(), // 국내뉴스
                issueSchedule(), // 이슈스케쥴
              ]),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 50,
            child: Obx(() {
              return (myPageController.goTopVisibility.value)
                  ? InkWell(
                      onTap: () {
                        // 스크롤 맨 위로
                        if (scrollController.hasClients) {
                          scrollController.jumpTo(0);
                          myPageController.goTopVisibility.value = false;
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
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
        ],
      ),
    );
  }
}
