import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';

typedef ClickEvent = Function();

class Button extends StatelessWidget {
  final String text;
  final ClickEvent? clickEvent;
  final double height;
  final double width;
  final Alignment alignment;
  final Color? borderColor;
  final double fontSize;
  final double margin;
  final double padding;

  const Button(this.text, this.clickEvent,
      {this.height = 40,
      this.width = 40,
      this.alignment = Alignment.center,
      this.borderColor = Colors.black,
      this.fontSize = 12,
      this.padding = 0,
      this.margin = 0});

  // 테두리 색 지정
  BoxDecoration? getBorder() {
    if (borderColor != null) {
      return BoxDecoration(border: Border.all(color: borderColor ?? BLACK));
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          margin: EdgeInsets.all(margin),
          padding: EdgeInsets.all(padding),
          width: width,
          height: height,
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: Colors.black),
          ),
          alignment: alignment,
          decoration: getBorder()),
      onTap: clickEvent,
    );
  }
}

/// 네모모양의 text버튼
/// 텍스트, 배경색, 글자색, 테두리 지정
class TextBtn extends StatelessWidget {
  TextBtn(this.text,
      {Key? key,
      this.fontSize = 16,
      this.fontColor = BLACK,
      this.backgroundColor = TRANSPARENT,
      this.borderColor = TRANSPARENT,
      this.padding = 0,
      this.fontWeight = FontWeight.normal})
      : super(key: key);

  final String text;
  final Color fontColor;
  final Color backgroundColor;
  final Color borderColor;
  final double padding;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
            color: backgroundColor, border: Border.all(color: borderColor)),
        child: Center(
            child: Text(text,
                style: TextStyle(
                    color: fontColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight))));
  }
}

class BlueButton extends StatelessWidget {
  const BlueButton({Key? key, this.text = '', this.fontSize = 16})
      : super(key: key);

  final String text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child:
                Text(text, style: TextStyle(fontSize: fontSize, color: WHITE))),
        color: BLUE,
        padding: EdgeInsets.all(10));
  }
}

class GrayButton extends StatelessWidget {
  const GrayButton({Key? key, this.text = '', this.fontSize = 16})
      : super(key: key);

  final String text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Text(text,
                style: TextStyle(fontSize: fontSize, color: DARKGRAY))),
        color: LLLIGHTGRAY,
        padding: EdgeInsets.all(10));
  }
}

class UnderLineButton extends StatelessWidget {
  const UnderLineButton(
      {Key? key,
      this.text = '',
      this.fontSize = 16,
      this.isSelected = false,
      this.paddingV = 10,})
      : super(key: key);
  final String text;
  final double fontSize;
  final bool isSelected;
  final double paddingV;

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return Container(
        height: 40,
        padding: EdgeInsets.symmetric(vertical: paddingV),
        decoration: const BoxDecoration(
            border:
            Border(bottom: BorderSide(color: BLACK, width: 2))),
        child: Text(text,
            style: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold)),
      );
    } else {
      return Container(
        height: 40,
        padding: EdgeInsets.symmetric(vertical: paddingV),
        child: Text(text,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: GRAY)),
      );
    }
  }
}


class RoundBorderButton extends StatelessWidget {
  const RoundBorderButton(
      {Key? key,
      this.text = '',
      this.fontSize = 16,
      this.background = WHITE,
      this.textColor = BLACK})
      : super(key: key);
  final String text;
  final double fontSize;
  final Color background;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: background),
        child:
            Text(text, style: TextStyle(fontSize: fontSize, color: textColor)));
  }
}

/// 둥근 모양의 하얀색 체크모양이 있는 체크버튼
/// checked = 선택시 true, 해제시 false
/// 선택시 파란 바탕
/// 해제시 회색 바탕
class RoundCheckButton extends StatelessWidget {
  final bool checked;
  final bool isLongClicked;

  const RoundCheckButton(this.checked, this.isLongClicked, {Key? key, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getIcon();
  }

  Widget getIcon() {
    return Container(
      child: const Icon(Icons.check, size: 15, color: Colors.white),
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.only(right: 10),
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: getColor(checked)),
    );
  }

  Color getColor(bool checked) {
    if (isLongClicked) {
      return GRAY;
    } else {
      return checked ? Colors.blue : LIGHTGRAY;
    }
  }
}

/// 왼쪽에 둥근 모양의 하얀색 체크모양이 있고, 오른쪽에 텍스트가 있는 체크버튼
class RoundCheckButtonWithText extends RoundCheckButton {
  RoundCheckButtonWithText(this.text, checked, {this.fontColor=GRAY, this.fontSize=12.0}) : super(checked, false);
  final String text;
  final Color fontColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      getIcon(),
      Container(
          child: Text(text,
              style: TextStyle(color: fontColor, fontSize: fontSize)),
          margin: const EdgeInsets.only(right: 10))
    ]);
  }
}



/// 클릭하면 파란배경 하얀글자, 아니면 회색인 버튼
class BlueGrayButton extends StatelessWidget{

  const BlueGrayButton(
      {Key? key,
        this.text = '',
        this.fontSize = 16,
        this.isSelected = false,
        this.paddingH = 10,
        this.paddingV = 10,})
      : super(key: key);
  final String text;
  final double fontSize;
  final bool isSelected;
  final double paddingH;
  final double paddingV;

  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: EdgeInsets.fromLTRB(paddingH, paddingV, paddingH, paddingV),
        color: isSelected? BLUE: LLIGHTGRAY,
        child: Center(
            child: Text(
                text, style: TextStyle(color: isSelected? WHITE: GRAY, fontSize: fontSize)
            )
        )
    );
  }

}

/// < 모양 아이콘
class TitleBarBackButton extends StatelessWidget{
  final Color color;
  const TitleBarBackButton({Key? key, this.color=BLACK}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.arrow_back_ios, color: color, size: 20);
  }
}

/// 선택되면 파란색, 아니면 회색인 네모박스
class ColoredSignBox extends StatelessWidget{
  final bool isSelected;
  final Color selectedColor;
  final Color unSelectedColor;

  const ColoredSignBox(this.isSelected, {Key? key, this.selectedColor = BLUE, this.unSelectedColor = LIGHTGRAY}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      color: (isSelected)? selectedColor : unSelectedColor,
    );
  }

}