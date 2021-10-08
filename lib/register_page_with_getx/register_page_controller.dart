

import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:get/get.dart';

class RegisterPageController extends GetxController{

  /// 관심종목
  var topBtnIdx = 0.obs; // 종목추가/종목편집/그룹편집 버튼. 어떤 버튼이 클릭되었는지 확인
  var topTabIdx = 0.obs; // 주식/지수/선물옵션... 버튼 클릭 확인
  var btnStockTypeIdx = 0.obs; // 국내주식/해외주식 버튼클릭 확인

  var selectedStocks = <String>[].obs; // 현재 선택된 주식 항목
  var stocks = <String>[].obs; // 리스트에 보여줄 주식 리스트
  var inputString = "".obs; // 검색창에 입력한 값

  var selectedCount = 0.obs;
  var stocksCnt = 0.obs;

  var comboStockType = "".obs; // 종목유형선택 내용
  // 종목유형선택 콤보박스 항목들
  final comboStockTypeItems = ["전체", "KOSPI", "KOSDAQ", "K_OTC", "KONEX", "ELW", "신주인수권"];

  var chkETF = false.obs; // ETF 체크버튼 상태
  var chkETN = false.obs; // ETN 체크버튼 상태
  ///

  /// 종목편집
  var updateflag = true.obs;
  // var editSelectedStocks = <String>[].obs;
  var chkSelectAll = false.obs; // 전체선택 체크박스
  var chkSelectedStocks = <String, bool>{}.obs; // 리스트 항목의 체크박스 선택 여부
  var isItemLongClicked = false.obs;

  void initData(preStocks){
    print("RegisterPageController constructor");
    print(preStocks);
    for(var stock in preStocks){
      print(stock);
      selectedStocks.value.add(stock);

    }

    chkSelectedStocks.value = { for (var item in preStocks) item : false };

    print(selectedStocks.value);
    selectedCount.value = preStocks.length;
    // editSelectedStocks.value = List.generate(selectedCount.value, (idx) => preStocks[idx]);

    update();
    initStocks();
    comboStockType.value = comboStockTypeItems.first;


  }

  void clearData(){
    topBtnIdx.value = 0;
    topTabIdx.value = 0;
    btnStockTypeIdx.value = 0;

    selectedStocks.value.clear();
    // stocks.value = <String>[];
    inputString.value = "";

    selectedCount.value = 0;
    // stocksCnt.value = 0;

    comboStockType.value = comboStockTypeItems.first;

    chkETF.value = false;
    chkETN.value = false;


    chkSelectAll.value = false;
    chkSelectedStocks.value = <String, bool>{};
    isItemLongClicked.value = false;
  }

  /// 관심종목 - 종목추가/종목편집/그룹편집 버튼 클릭시
  /// 해당 버튼 index 저장
  void onClickTopBtn(int idx){
    topBtnIdx.value = idx;
  }
  /// 관심종목 - 주식/지수/선물옵션/장내채권/상품 버튼 클릭시
  /// 해당 버튼 index 저장
  void onClickTabBtn(int idx){
    topTabIdx.value = idx;
  }
  /// 관심종목 - 국내주식/해외주식 토글 버튼 클릭시
  /// 해당 버튼 index 저장
  void onClickStockTypeBtn(int idx){
    btnStockTypeIdx.value = idx;
  }

  /// 관심종목 - 종목유형 선택 콤보박스에서 아이템 선택시
  /// 선택한 아이템 저장
  void onClickComboStockType(String item){
    comboStockType.value = item;
  }

  /// 주식 리스트에서 항목 클릭시
  /// 이미 선택한 항목이면 리스트에서 삭제,
  /// 새로운 항목이면 맨 앞에 추가
  void onClickStockListItem(String item){
    if(selectedStocks.value.contains(item)){
      selectedStocks.value.remove(item);
      chkSelectedStocks.value.remove(item);
    }else{
      selectedStocks.value.insert(0, item);
      chkSelectedStocks.value[item] = false;
    }
    print(selectedStocks.value);
    selectedCount.value = selectedStocks.value.length;
  }

  /// 주식 리스트에서 선택된 항목이면 노란 별, 선택된 항목이 아니면 회색 별 아이콘 반환
  Widget getIcon(String stock) {
    // print("getIcon ${selectedStocks.value}");
    // print("getIcon ${selectedStocks.value.contains(stock)} $stock");
    if ((selectedStocks.value.contains(stock))) {
      return const Icon(Icons.star, color: Colors.yellow);
    } else {
      return const Icon(Icons.star, color: Colors.grey);
    }
  }

  /// 주식 리스트 초기화
  void initStocks(){
    stocks.value = stockData.keys.toList();
    // print("initStocks");
    // print(stocks.value);
    stocksCnt.value = stocks.value.length;
  }

  /// 주식 리스트를 items로 업데이트
  /// items == stock title에 input이 포함된 항목 리스트
  void updateStocks(List<String> items, String input){
    stocks.value = items;
    stocksCnt.value = stocks.value.length;
    inputString.value = input;
  }


  /// 종목편집
  /// 리스트 아이템 체크박스 클릭시 동작
  /// 클릭된 상태면 해제, 아니면 클릭된 상태
  /// 모든 아이템이 클릭된 상태면 전체선택 체크박스 선택된 상태로
  void chkStockListClicked(String item){
    if(chkSelectedStocks.containsKey(item)){
      print(chkSelectedStocks[item]);
      chkSelectedStocks[item] = !(chkSelectedStocks[item]!);
      print(chkSelectedStocks[item]);

      // 모든 항목이 선택된 상태인지 확인
      bool flag = true;
      for(var isChecked in chkSelectedStocks.values){
        if(!isChecked){
          flag = false;
          break;
        }
      }
      if(flag){
        chkSelectAll.value = true;
      }else{
        chkSelectAll.value = false;
      }
    }

  }

  /// 종목편집
  /// 리스트 항목 위치 변경
  void swapItems(int oldIdx, int newIdx){
    // if(newIdx > oldIdx){
    //   newIdx -= -1;
    // }
    //
    // final item = editSelectedStocks[oldIdx];
    final item = selectedStocks[oldIdx];
    if(newIdx < oldIdx){
      oldIdx += 1;
    }
    // editSelectedStocks.insert(newIdx, item);
    // editSelectedStocks.removeAt(oldIdx);
    selectedStocks.insert(newIdx, item);
    selectedStocks.removeAt(oldIdx);
  }
}