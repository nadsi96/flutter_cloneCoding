import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_prac_jongmock/buttons/widget_button.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:flutter_prac_jongmock/util.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'page_news.dart';

class NewsDetail extends StatelessWidget {
  NewsDetail({Key? key, required this.newsData}) : super(key: key);

  final controller = Get.find<MainController>();
  final NewsData newsData;

  Widget detailView() {
    const titleFont = 18.0;
    const smallFont = 12.0;
    const fontSizeControllBoxSize = 40.0;

    return Column(children: [
      Container(
          color: LLLIGHTGRAY,
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                height: 50,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(10),
                child: Text(newsData.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: BLACK,
                        fontWeight: FontWeight.bold,
                        fontSize: titleFont))),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${formatIntToStringLen2(newsData.dt!.year % 100)}/${formatIntToStringLen2(newsData.dt!.month)}/${formatIntToStringLen2(newsData.dt!.day)}",
                                style: const TextStyle(
                                    color: GRAY, fontSize: smallFont)),
                            Text(
                                "${formatIntToStringLen2(newsData.dt!.hour)}:${formatIntToStringLen2(newsData.dt!.minute)}",
                                style: const TextStyle(
                                    color: GRAY, fontSize: smallFont)),
                            Text(newsData.company,
                                style: const TextStyle(
                                    color: GRAY, fontSize: smallFont)),

                            /// 날자 시간 언론사
                          ]))),
              Expanded(
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                InkWell(
                  onTap: (){
                    controller.newsPage_increFont();
                  },
                  child: Container(
                      width: fontSizeControllBoxSize,
                      height: fontSizeControllBoxSize,
                      decoration: const BoxDecoration(
                          color: WHITE,
                          border: Border(
                              right: BorderSide(color: LLIGHTGRAY, width: 0.5),
                              left: BorderSide(color: GRAY),
                              top: BorderSide(color: GRAY),
                              bottom: BorderSide(color: GRAY))),
                      child: const Center(
                          child: Text("가+",
                              style: TextStyle(color: GRAY, fontSize: 16))))
                ),
                InkWell(
                  onTap: (){
                    controller.newsPage_decreFont();
                  },
                  child: Container(
                      width: fontSizeControllBoxSize,
                      height: fontSizeControllBoxSize,
                      decoration: const BoxDecoration(
                          color: WHITE,
                          border: Border(
                              top: BorderSide(color: GRAY),
                              bottom: BorderSide(color: GRAY),
                              right: BorderSide(color: GRAY))),
                      child: const Center(
                          child: Text("가-",
                              style: TextStyle(color: GRAY, fontSize: 12))))
                )
              ]))
            ])
          ])),
      Expanded(

          /// 뉴스기사
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: WebView(

                initialUrl: 'https://www.google.com',
                javascriptMode: JavascriptMode.unrestricted,
              ))
          // child: Container(
          //     margin: const EdgeInsets.symmetric(horizontal: 10),
          //     child: Scrollbar(
          //         child: SingleChildScrollView(
          //             child: Container(
          //                 height: 5000,
          //                 child: Container(color: RED)
          //             )
          //         )
          //     )
          // )
          ),
      Container(
          color: WHITE,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(10),
          child: const Text("언론사 제공뉴스는 당사의 투자의견과 무관합니다.",
              style: TextStyle(fontSize: 12, color: BLACK)))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          shadowColor: TRANSPARENT,
          title: const Text("뉴스/공시 읽기",
              style: TextStyle(color: BLACK, fontSize: 16)),
          backgroundColor: WHITE,
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: const TitleBarBackButton()),
        ),
        body: detailView());
  }
}
