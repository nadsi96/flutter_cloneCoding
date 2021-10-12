import 'package:flutter/material.dart';
import 'package:flutter_prac_jongmock/colors.dart';
import 'package:flutter_prac_jongmock/controllers/main_controller.dart';
import 'package:get/get.dart';

import 'time.dart';

class CntOptionBottomSheet extends StatelessWidget {

  final ProduceTimeData pd;
  CntOptionBottomSheet(this.pd, {Key? key}) : super(key: key);

  final controller = Get.find<MainController>();
  final scrollController = ScrollController();

  Widget buildListTile(String item) {
    return ListTile(
      onTap: () {
        controller.timePage_cntOption.value = item;
        controller.timePage_optioned(pd, item);
        Get.back();
      },
      title: GetX<MainController>(
        builder: (_) => Text(
          item,
          style: TextStyle(
              fontSize: 14,
              color:
                  (controller.timePage_cntOption.value == item) ? BLUE : BLACK),
        ),
      ),
      trailing: GetX<MainController>(
        builder: (_) => (controller.timePage_cntOption.value == item)
            ? const Icon(Icons.check, color: BLUE, size: 30)
            : Container(width: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = controller.timePage_cntOptions.keys;

    return Container(
      width: Get.width,
      height: 300,
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
        color: WHITE,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: Scrollbar(
        child: ListView.builder(
          controller: scrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: options.length * 2 - 1,
          itemBuilder: (BuildContext context, int index) {
            if (index.isOdd) {
              return const Divider(
                color: GRAY,
                height: 1,
              );
            } else {
              final idx = index ~/ 2;
              return buildListTile(
                options.elementAt(idx),
              );
            }
          },
        ),
      ),
    );
  }
}
