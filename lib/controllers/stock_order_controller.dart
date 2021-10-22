import 'package:flutter_prac_jongmock/stock_data.dart';
import 'package:flutter_prac_jongmock/stock_order_page/dialogs.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';

class StockOrderController extends GetxController {
  Stock? stock;
  bool isOpening = true;

  /// 주식주문
  /// 탭
  var tabList = ['매수', '매도', '정정/취소', '미체결'];
  var tabIdx = 0.obs;

  // 호가/체결 테이블 토글
  var hoga_che_toggle = true.obs;

  // 매수, 매도, 정정/취소
  // 현금/신용/대출상환
  var payIdx = 0.obs;

  // 구분
  var tradeType = '보통'.obs;

  // 시장가 체크박스
  var marketPrice = true.obs;

  // 주문수량
  var orderCount = ''.obs;
  var orderCountEnable = true.obs;

  // 주문 단가
  var orderPrice = ''.obs;
  var orderPriceEnable = true.obs;

  // 금액
  var orderTotal = ''.obs;

  // 수량/단가/금액 입력 다이얼로그
  // 선택 탭
  var dialog_insertTab = '수량'.obs;

  var dialog_orderCount = (-1).obs; // 수량
  var dialog_orderPrice = (-1).obs; // 단가
  var dialog_orderTotal = (-1).obs; // 금액

  /// 정정/취소 탭
  var all_toggle = false.obs; // 전부 체크버튼 토글


  /// 미체결탭
  var contractState = false.obs; // 미체결/체결. false = 미체결
  void setStock(Stock stock) {
    this.stock = stock;
  }

  /// 주식주문
  /// 탭 바뀔 때 상태 초기화
  void clearState() {
    orderCount.value = '';
    orderPrice.value = '';
    orderTotal.value = '';

    orderPriceEnable.value = true;
    orderCountEnable.value = true;

    marketPrice.value = false;
    payIdx.value = 0;
    tradeType.value = '보통';
  }

  void init() {
    if (stock != null) {
      if (orderPrice.value == '') {
        dialog_orderPrice.value = stock!.getPriceInt();
      }
      if (orderCount.value != '') {
        dialog_orderCount.value =
            int.parse(orderCount.value.replaceAll(',', ''));
      }
    }
  }

  /// 시장 체크버튼 토글 동작
  /// 체크버튼 클릭시
  /// 구분 항목의 내용도 시장가로
  /// 해제시 보통으로
  void marketPriceToggle() {
    marketPrice.toggle();
    final flag = marketPrice.value;
    if (flag) {
      orderPrice.value = '';
      orderTotal.value = '';
      dialog_orderPrice.value = -1;
      tradeType.value = '시장가';
      orderPriceEnable.value = false;
    } else {
      tradeType.value = '보통';
      orderPriceEnable.value = true;
    }
  }

  /// 정정/취소
  /// 수량 전부 선택/해제
  void modifyAllToggle() {
    all_toggle.toggle();
    if (all_toggle.value) {
      orderCount.value = '';
      orderTotal.value = '';
      dialog_orderCount.value = -1;
      dialog_orderTotal.value = -1;
      orderCountEnable.value = false;
    } else {
      orderCountEnable.value = true;
    }
  }

  /// 주식주문
  /// 구분 ['시장가', '장전시간외', '장후시간외', '최유리지정가', '최우선지정가']이면
  /// 금액 표시 x
  /// 단가 박스 배경색 짙게
  bool showPrice() {
    return (['시장가', '장전시간외', '장후시간외', '최유리지정가', '최우선지정가']
        .contains(tradeType.value));
  }

  /// 수량/단가/금액 입력 다이얼로그 화면 열기
  /// tab - 수량/단가/금액
  /// 활성화된 tab만 다이얼로그 엶
  void openInsertDialog(String tab) {
    final flag;
    switch (tab) {
      case '수량':
        flag = orderCountEnable.value;
        break;
      case '단가':
        flag = orderPriceEnable.value;
        break;
      default:
        flag = true;
        break;
    }

    (flag)
        ? Get.bottomSheet(InsertValDialog(tab, tabTexts: getInsertDialogTabs()))
        : {};
  }

  List<String> getInsertDialogTabs() {
    List<String> tabs = ['수량', '단가', '금액'];
    switch (tabIdx.value) {
      case 0:
      case 1:
        // 매수/매도
        return (showPrice()) ? ['수량'] : tabs;
      case 2:
        //정정/취소
        tabs.removeLast(); // 금액 제거
        if (showPrice()) {
          //단가 제거
          tabs.removeLast();
        }
        if (all_toggle.value) {
          // 수량 제거
          tabs.removeAt(0);
        }
        return tabs;
      default:
        return [];
    }
  }

  /// 수량/단가/금액 입력 다이얼로그
  /// + 버튼 클릭
  void dialog_increBtn() {
    if (stock != null) {
      switch (dialog_insertTab.value) {
        case '수량':
          if (dialog_orderCount.value < 9999999) {
            dialog_orderCount.value += 1;
          }
          break;
        case '단가':
          final temp =
              dialog_orderPrice.value + getDist(dialog_orderPrice.value);
          if ((stock!.getYesterdayInt() * 1.3).toInt() > temp) {
            dialog_orderPrice.value = temp;
          }
          break;
      }
    }
  }

  /// 수량/단가/금액 입력 다이얼로그
  /// - 버튼 클릭
  void insertDialog_decreBtn() {
    if (stock != null) {
      switch (dialog_insertTab.value) {
        case '수량':
          if (dialog_orderCount.value > 0) {
            dialog_orderCount.value -= 1;
          }
          break;
        case '단가':
          final temp =
              dialog_orderPrice.value - getDist(dialog_orderPrice.value);
          if ((stock!.getYesterdayInt() * 0.7).toInt() < temp) {
            dialog_orderPrice.value = temp;
          }
          break;
      }
    }
  }

  String getOrderCount() {
    final cnt = dialog_orderCount.value;
    if (cnt < 0) {
      return '';
    }
    return formatIntToStr(cnt);
  }

  String getOrderPrice() {
    final price = dialog_orderPrice.value;
    if (price <= 0) {
      return '';
    } else {
      return formatIntToStr(price);
    }
  }

  String getOrderTotal() {
    return (dialog_orderTotal.value < 0)
        ? ''
        : formatIntToStr(dialog_orderTotal.value);
  }

  /// 수량/단가/금액 입력 다이얼로그
  /// 숫자판 버튼 클릭 (1 ~ 9, 0, 00, 000)
  void dialog_numBtn(String num) {
    if (stock != null) {
      switch (dialog_insertTab.value) {
        case '수량':
          if (dialog_orderCount.value <= 0) {
            dialog_orderCount.value = int.parse(num);
            break;
          }
          String cnt = dialog_orderCount.value.toString();
          cnt = '$cnt$num';
          int temp = int.parse(cnt);
          if (temp > 9999999) {
            temp = 9999999;
          }
          dialog_orderCount.value = temp;
          break;
        case '단가':
          if (dialog_orderPrice.value <= 0) {
            dialog_orderPrice.value = int.parse(num);
            break;
          }
          String price = dialog_orderPrice.value.toString();
          price = '$price$num';
          int temp = int.parse(price);
          int high = (stock!.getYesterdayInt() * 1.3).toInt();
          if (temp > high) {
            temp = high;
          }
          dialog_orderPrice.value = temp;
          break;
        case '금액':
          if (dialog_orderTotal.value <= 0) {
            dialog_orderTotal.value = int.parse(num);
            break;
          }
          String total = dialog_orderTotal.value.toString();
          total = '$total$num';
          int temp = int.parse(total);
          if (temp > 999999999) {
            temp = 999999999;
          }
          dialog_orderTotal.value = temp;
          break;
      }
    }
  }

  /// 수량/단가/금액 입력 다이얼로그
  /// 입력칸부분 초기화
  void dialog_clearText() {
    switch (dialog_insertTab.value) {
      case '수량':
        dialog_orderCount.value = -1;
        break;
      case '단가':
        dialog_orderPrice.value = -1;
        break;
      case '금액':
        dialog_orderTotal.value = -1;
        break;
    }
  }

  /// 수량/단가/금액 입력 다이얼로그
  /// 입력칸
  /// backspace 기능
  void dialog_eraseBtn() {
    switch (dialog_insertTab.value) {
      case '수량':
        final cnt = dialog_orderCount.value;
        if (cnt < 10) {
          // 한 자리 수에서 backSpace 버튼 클릭하면 빈 칸으로
          dialog_orderCount.value = -1;
        } else {
          String temp = cnt.toString();
          temp = temp.substring(0, temp.length - 1);
          dialog_orderCount.value = int.parse(temp);
        }
        break;
      case '단가':
        final price = dialog_orderPrice.value;
        if (price < 10) {
          // 한 자리 수에서 backSpace 버튼 클릭하면 빈 칸으로
          dialog_orderPrice.value = -1;
        } else {
          String temp = price.toString();
          temp = temp.substring(0, temp.length - 1);
          dialog_orderPrice.value = int.parse(temp);
        }
        break;
      case '금액':
        final total = dialog_orderTotal.value;
        if (total < 10) {
          // 한 자리 수에서 backSpace 버튼 클릭하면 빈 칸으로
          dialog_orderTotal.value = -1;
        } else {
          String temp = total.toString();
          temp = temp.substring(0, temp.length - 1);
          dialog_orderTotal.value = int.parse(temp);
        }
        break;
    }
  }

  /// return 0 - 정상
  ///        1 - 주문가가 상한가 이상
  ///        2 - 주문가가 하한가 이하
  int dialog_checkPrice() {
    final high = (stock!.getYesterdayInt() * 1.3).toInt();
    final low = (stock!.getYesterdayInt() * 0.7).toInt();
    final price = dialog_orderPrice.value;
    if (price > high) {
      return 1;
    } else if (price < low) {
      return 2;
    } else {
      return 0;
    }
  }

  /// 다이얼로그에서 입력한 내용을 페이지에 전달
  void backFromDialog() {
    isOpening = true;
    int cnt = dialog_orderCount.value;
    int price = dialog_orderPrice.value;
    int total = dialog_orderTotal.value;

    print('$cnt $price $total');

    /// 금액 탭에서 확인 클릭시
    ///  - 수량을 금액과 단가에 따라 결정
    /// 수량/단가에서 확인 클릭시
    /// 금액을 수량/단가에 따라 결정
    if (dialog_insertTab.value == '금액') {
      cnt = total ~/ price;
    }
    total = cnt * price;

    print('$cnt $price $total');
    orderCount.value = (cnt < 0) ? '' : formatIntToStr(cnt);
    orderPrice.value = (price < 0) ? '' : formatIntToStr(price);

    /// 수량이 빈 칸이면 금액도 빈 칸으로 처리
    if (cnt == -1 || price == -1) {
      orderTotal.value = '';
      dialog_orderTotal.value = -1;
    } else {
      orderTotal.value = formatIntToStr(total);
      dialog_orderTotal.value = total;
    }
  }
}
