import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

/// 주식현재가 - 투자자 테이블
class InvestorTable extends StatelessWidget {

  final pd = ProduceInvestorData();

  final tableWidth = Get.width / 4; // table cell 너비
  final double tableHeight = 40;

  final controller = Get.find<MainController>();

  final tableColHeader = [
    "개인",
    "외국인",
    "기관",
    "프로그램",
    "금융투자",
    "보험",
    "투신",
    "사모펀드",
    "은행",
    "기타금융",
    "연기금등",
    "국가지자체",
    "기타법인",
    "기타외국인"
  ];

  LinkedScrollControllerGroup HScrollControllers = LinkedScrollControllerGroup(); // 가로 스크롤 묶음
  late ScrollController headController = HScrollControllers.addAndGet(); // 1행
  late ScrollController bodyController = HScrollControllers.addAndGet(); // 1: 행

  LinkedScrollControllerGroup VScrollControllers = LinkedScrollControllerGroup(); // 세로 스크롤 묶음
  late ScrollController firstColumnController = VScrollControllers.addAndGet(); // 1열
  late ScrollController restColumnController = VScrollControllers.addAndGet(); // 1: 열

  InvestorTable({Key? key}) : super(key: key) {
    print("investor Table class");

    print("set Controller");
    // pd.initData();
    // controller.investorPage_initData(pd);
    controller.investorPage_setData(pd.get30());
    print("end investor Table constructor");
  }

  Color getColor(String item) {
    if (item[0] ==  '0') {
      return BLACK;
    } else if (item[0] == '-') {
      return BLUE;
    } else {
      return RED;
    }
  }

  Widget rowItem({String text="", Color fontColor=BLACK}){
    return Container(
        width: tableWidth,
        height: tableHeight,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(border: Border.all(color: GRAY, width: 0.5),),
        child: Text(text, style: TextStyle(color: fontColor, fontSize: 14),),
    );
  }

  /// 테이블 첫 열 데이터
  /// 일자/주가에 따라 표시
  Widget tableFirstCol(InvestorData data){
    return Obx((){
      if(controller.investorPage_date_price_flag.value){
        return Container(
          width: tableWidth,
          height: tableHeight,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(border: Border.all(color: GRAY, width: 0.5),),
          child: Center(
              child: Text(data.date, style: const TextStyle(color: BLACK, fontSize: 12),),),
        );
      }else{
        return rowItem(text: data.getStockPrice(), fontColor: getColor(data.stockPrice),);
      }
    });
  }

  /// 테이블 행 데이터
  ///
  Widget tableRow(InvestorData data){
    return Row(
      children: [
        rowItem(text: data.getPersonal(), fontColor: getColor(data.personal)),
        rowItem(text: data.getForeign(), fontColor: getColor(data.foreign)),
        rowItem(text: data.getInstitution(), fontColor: getColor(data.institution)),
        rowItem(text: data.getProgram(), fontColor: getColor(data.program)),
        rowItem(text: data.getInvest(), fontColor: getColor(data.invest)),
        rowItem(text: data.getInsurance(), fontColor: getColor(data.insurance)),
        rowItem(text: data.getRely(), fontColor: getColor(data.rely)),
        rowItem(text: data.getFund(), fontColor: getColor(data.fund)),
        rowItem(text: data.getBank(), fontColor: getColor(data.bank)),
        rowItem(text: data.getRest(), fontColor: getColor(data.rest)),
        rowItem(text: data.getYeon(), fontColor: getColor(data.yeon)),
        rowItem(text: data.getNation(), fontColor: getColor(data.nation)),
        rowItem(text: data.getRestCooperation(), fontColor: getColor(data.restCooperation)),
        rowItem(text: data.getRestForeign(), fontColor: getColor(data.restForeign)),
      ]
    );
  }

  Future<bool> getMoreData() async{
    // controller.investorPage_addRow(pd);
    return true;
  }

  /// 테이블
  /// Col - Row(일자/주가, 나머지 헤더)
  ///       Row( List_v - 일자/주가, List_v - rows
  ///
  @override
  Widget build(BuildContext context) {
    print("build");
    final toggleColorBox = [
      Container(width: 5, height: 5, color: BLUE),
      Container(width: 5, height: 5, color: GRAY)
    ];
    return Column(
      children: [
        SizedBox(
          // [0,0], [0, 1:]
          height: tableHeight,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  controller.investorPage_DatePriceToggle(pd);
                },
                child: GetX<MainController>(
                  //[0,0] 일자/주가
                  builder: (_) {
                    final flag = controller.investorPage_date_price_flag.value;

                    return Container(
                      padding: const EdgeInsets.all(5),
                      width: tableWidth,
                      height: tableHeight,
                      decoration: BoxDecoration(
                        color: LLIGHTGRAY,
                        border: Border.all(color: GRAY, width: 0.5),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              (flag) ? "일자" : "주가",
                              style:
                                  const TextStyle(color: BLACK, fontSize: 14),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: (controller
                                      .investorPage_date_price_flag.value)
                                  ? toggleColorBox
                                  : toggleColorBox.reversed.toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                // 1행
                // 테이블 헤더
                child: ListView(
                  controller: headController,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    tableColHeader.length,
                    (idx) => Container(
                      width: tableWidth,
                      decoration: BoxDecoration(
                        color: LLIGHTGRAY,
                        border: Border.all(color: GRAY, width: 0.5),
                      ),
                      child: Center(
                        child: Text(
                          tableColHeader[idx],
                          style: const TextStyle(fontSize: 14, color: BLACK),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          // [1:, 0], [1:, 1:]
          child: Row(
            children: [
              SizedBox(
                width: tableWidth,
                child: NotificationListener(
                  onNotification: (notification) {
                    // 스크롤이 바닥에 닿으면
                    // 30줄 추가
                    // firstColumnController, restColumnController는 LinkedScrollControllerGroup으로 묶여서 같이 움직이므로
                    // 둘 중 하나만 처리해줘도 동작
                    if (firstColumnController.hasClients &&
                        firstColumnController.offset ==
                            firstColumnController.position.maxScrollExtent) {
                      // var isUpdating = true;
                      // isUpdating = getMoreData();


                      // controller.investorPage_addRow(pd);
                      controller.investorPage_addRow(pd.get30());
                      print("scroll bottom");
                    }
                    return false;
                  },
                  child: Obx((){
                      var items = controller.investorPage_Data.value;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        controller: firstColumnController,
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return tableFirstCol(items[index]);
                        },
                      );
                    },
                  ),
                ),
              ), // 테이블 1열. 주가/일자
              Expanded(
                // [1:, 1:]
                // 가로 스크롤 가능한 스크롤뷰에 세로로 스크롤 하는 리스트뷰
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: bodyController,
                  physics: const ClampingScrollPhysics(),
                  child: SizedBox(
                    width: tableWidth * (tableColHeader.length),
                    child: Obx((){
                        var items = controller.investorPage_Data.value;
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          controller: restColumnController,
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return tableRow(items[index]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ), // 1행, 1열 제외한 테이블 나머지
            ],
          ),
        ),
      ],
    );
  }
}

class ProduceInvestorData {
  var dataSet = [];

  DateTime currentDay = DateTime.now().add(const Duration(days: 1));
  final ran = Random();

  void initData() => dataSet = [];

  // 30개 추가
  // void get30() {
  List<InvestorData> get30(){
    List<InvestorData> dataSet = [];
    var i = 0;

    while (i < 30) {
      currentDay = currentDay.subtract(const Duration(days: 1));
      if (currentDay.weekday == 6 || currentDay.weekday == 7) {
        continue;
      }
      i++;
      dataSet.add(InvestorData(date: '${formatIntToStringLen2(currentDay.year%100)}/${formatIntToStringLen2(currentDay.month)}/${formatIntToStringLen2(currentDay.day)}',
        stockPrice: formatIntToStr(ran.nextInt(40000) - 20000),
        personal: formatIntToStr(ran.nextInt(40000) - 20000),
        foreign: formatIntToStr(ran.nextInt(40000) - 20000),
        institution: formatIntToStr(ran.nextInt(40000) - 20000),
        program: formatIntToStr(ran.nextInt(40000) - 20000),
        invest: formatIntToStr(ran.nextInt(40000) - 20000),
        insurance: formatIntToStr(ran.nextInt(40000) - 20000),
        rely: formatIntToStr(ran.nextInt(40000) - 20000),
        fund: formatIntToStr(ran.nextInt(40000) - 20000),
        bank: formatIntToStr(ran.nextInt(40000) - 20000),
        rest: formatIntToStr(ran.nextInt(40000) - 20000),
        nation: formatIntToStr(ran.nextInt(40000) - 20000),
        restCooperation: formatIntToStr(ran.nextInt(40000) - 20000),
        restForeign: formatIntToStr(ran.nextInt(40000) - 20000),
        yeon: formatIntToStr(ran.nextInt(40000) - 20000),
      ));
    }
    return dataSet;
  }
}

class InvestorData {
  /*
  기관투자자 구성
  기관 - 금융투자 - 금융투자업자(증권사,선물회사,투자자문회사)가 운용하는 자산
      - 투신    - 투자자문회사 제외한 투자신탁회사  - 자산운용사가 대신 매매
      - 기타금융 - 종합금융회사, 저축은행, 기타법인 중 법적상 전문투자자인 금융기관(ex. 증권금융, 자금중개, 여신전문금융 .. )
      - 연기금   - 연금, 기금
      - 국가    - 국가/지자체, 국제기구, 기타법인 중 비금융 공공기관 (ex. 한국은행, 예금보험공사, 한국자산관리공사, 한국주택금융공사 한국거래소, 금융감독원 .. )

   기타법인 - 투자기관으로 등록되지 않은 일반회사. 계열사나 자사주 매입도 기타법인
   기타금융 - 저축은행, 신협, 여신사 등(은행, 금융투자, 보험이 아닌 금융기관)
   */
  final String date;
  final String stockPrice;
  final String personal;
  final String foreign;
  final String institution;
  final String program;
  final String invest; // 금융투자
  final String insurance;
  final String rely; // 투신
  final String fund; // 사모펀드
  final String bank;
  final String rest; // 기타금융
  final String yeon; // 연기금
  final String nation; // 국가지자체
  final String restCooperation; // 기타법인
  final String restForeign; // 기타외국인

  InvestorData({
    this.date = "",
    this.stockPrice = '0',
    this.personal = '0',
    this.foreign = '0',
    this.institution = '0',
    this.program = '0',
    this.invest = '0',
    this.insurance = '0',
    this.rely = '0',
    this.fund = '0',
    this.bank = '0',
    this.rest = '0',
    this.yeon = '0',
    this.nation = '0',
    this.restCooperation = '0',
    this.restForeign = '0',
  });

  String getStockPrice() => stockPrice;
  String getPersonal() => personal;
  String getForeign() => foreign;
  String getInstitution() => (institution);
  String getProgram() => (program);
  String getInvest() => (invest);
  String getInsurance() => (insurance);
  String getRely() => (rely);
  String getFund() => (fund);
  String getBank() => (bank);
  String getRest() => (rest);
  String getYeon() => (yeon);
  String getNation() => (nation);
  String getRestCooperation() => (restCooperation);
  String getRestForeign() => (restForeign);
}
