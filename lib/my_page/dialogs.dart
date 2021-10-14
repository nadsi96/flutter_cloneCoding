import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:get/get.dart';

class MyPageDialogs {
  /// 종목순위
  /// i 버튼 클릭시 보여줄 안내문
  Dialog stockRank() {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        height: 250,
        child: Column(
          children: [
            Container(
              color: WHITE,
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // textBaseline: TextBaseline.alphabetic,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    child: Container(
                      width: 5, height: 5,
                      color: BLACK,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('국내 외국인/기관 종목순위는',
                            style: TextStyle(fontSize: 14, color: BLACK)),
                        Text('순매수 금액(백만) 순입니다.',
                            style: TextStyle(fontSize: 14, color: BLACK)),
                        Text('- 장중에는 당일 추정 데이터 기준',
                            style: TextStyle(fontSize: 13, color: BLACK)),
                        Text('- 장종료 후에는 거래소의 정식 데이터 기준',
                            style: TextStyle(fontSize: 13, color: BLACK)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => Get.back(),
              child: Container(
                color: BLUE,
                height: 50,
                alignment: Alignment.center,
                child: const Text('확인',
                    style: TextStyle(
                        fontSize: 18,
                        color: WHITE,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 주식목록
  /// 그룹 선택
  Dialog selectStockGroup(List<String> groups, String current) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        color: WHITE,
        height: 400,
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          children: [
            Container(
              height: 80,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: GRAY),
                ),
              ),
              child: const Text(
                '관심 그룹 선택',
                style: TextStyle(fontSize: 20, color: BLACK),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: groups.length,
                itemBuilder: (BuildContext context, int index) {
                  final groupName = groups[index];
                  return InkWell(
                      onTap: () {
                        Get.back(result: groupName);
                      },
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerLeft,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: LIGHTGRAY),
                          ),
                        ),
                        child: Text(
                          groupName,
                          style: TextStyle(
                              fontSize: 16,
                              color: (current == groupName) ? BLUE : BLACK),
                        ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 주식목록
  /// 국가별 실시간 시세
  Dialog realtimePrice() {
    final contents = {
      '미국(뉴욕/아멕스': '무료실시간',
      '미국(나스닥)': '무료실시간',
      '상해(후강퉁)': '무료실시간',
      '심천(선강퉁)': '무료실시간',
      '홍콩': '15분지연',
      '일본': '20분지연',
      '싱가포르': '15분지연',
      '베트남': '15분지연',
      '영국': '15분지연',
      '독일': '15분지연',
      '유로넥스트': '15분지연'
    };
    List<Widget> rows = [];
    for (var data in contents.entries) {
      rows.add(realtimePriceContentRow(data.key, data.value));
    }
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        color: WHITE,
        height: 400,
        child: Column(
          children: [
            Container(
              height: 80,
              alignment: Alignment.center,
              child: const Text(
                '국가별 실시간 시세',
                style: TextStyle(
                    fontSize: 18, color: BLACK, fontWeight: FontWeight.w900),
              ),
            ),
            Expanded(
              child: Column(
                children: rows,
              ),
            ),
            InkWell(
              onTap: () => Get.back(),
              child: Container(
                height: 50,
                color: BLUE,
                alignment: Alignment.center,
                child: const Text(
                  '확인',
                  style: TextStyle(
                      color: WHITE, fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 국가별 실시간 시세 안내
  /// 내용 형식 [ㅁㄴㅇㄹ   : ㅁㅇㄹ  ]
  Widget realtimePriceContentRow(String title, String content) {
    const textStyle = TextStyle(fontSize: 14, color: BLACK);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(title, style: textStyle),
          ),
          Expanded(
            child: Text(': $content', style: textStyle),
          ),
        ],
      ),
    );
  }

  /// 이슈스케쥴
  /// 항목 클릭시 띄워줄 다이얼로그 화면
  /// -타이틀
  /// -내용
  /// -확인버튼
  Dialog issueScheduleDialog(String title, String contents) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 490,
          color: WHITE,
          child: Column(
            children: [
              Container(
                height: 100,
                margin: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: LIGHTGRAY),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, color: BLACK),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: 300,
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(contents,
                      style: const TextStyle(fontSize: 16, color: BLACK)),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 50,
                  color: BLUE,
                  alignment: Alignment.center,
                  child: const Text('확인',
                      style: TextStyle(
                          color: WHITE,
                          fontSize: 18,
                          fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        ));
  }
}
