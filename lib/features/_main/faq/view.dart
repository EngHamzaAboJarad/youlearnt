import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/_main/logic.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';

import '../../../constants/colors.dart';
import '../widgets/header_widget.dart';
import 'logic.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColor,
      child: Column(
        children: [
          HeaderWidget(
            titleBig: "FAQ".tr,
            titleSmall: ''.tr,
            showSearch: false,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25), topLeft: Radius.circular(25))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText('Queries you may have.'.tr, fontSize: 18),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: GetBuilder<MainLogic>(
                        init: Get.find<MainLogic>(),
                        builder: (logic) {
                          return ListView.builder(
                              itemCount: logic.faqsList.length,
                              itemBuilder: (context, index) => InkWell(
                                    onTap: () => logic.selectQuestion(index),
                                    child: AnimatedSize(
                                      duration: const Duration(milliseconds: 200),
                                      child: index == logic.selectedQuestion
                                          ? Container(
                                              margin: const EdgeInsets.only(bottom: 10),
                                              decoration: BoxDecoration(
                                                color:
                                                    secondaryLightColor.withOpacity(0.3),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              padding: const EdgeInsets.all(15),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    logic.faqsList[index].question,
                                                    fontSize: 16,
                                                  ),
                                                  CustomText(
                                                    logic.faqsList[index].answer,
                                                    fontSize: 12,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              margin: const EdgeInsets.only(bottom: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey.shade300),
                                              ),
                                              padding: const EdgeInsets.all(15),
                                              child: CustomText(
                                                logic.faqsList[index].question,
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                                  ));
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
