import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';

import '../../../constants/colors.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../widgets/header_widget.dart';
import 'logic.dart';

class FindStudentPage extends StatelessWidget {
  final logic = Get.put(FindStudentLogic());

  FindStudentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logic.getStudents();
    return GetBuilder<FindStudentLogic>(builder: (logic) {
      return Container(
        color: secondaryColor,
        child: Column(
          children: [
            HeaderWidget(titleBig: 'Find students'.tr, titleSmall: ''.tr),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              'Recent Requests'.tr,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ), /*
                        CustomText('see all'.tr, color: secondaryColor)*/
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: logic.isLoading ? const Center(
                            child: CircularProgressIndicator(strokeWidth: 1,)) : ListView.builder(
                            itemCount: logic.postList.length,
                            itemBuilder: (context, index) =>
                                InkWell(
                                  onTap: () => logic.openDialog(logic.postList[index]),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 1, color: Colors.grey.shade300),
                                    ),
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: CustomText(
                                                  logic.postList[index].title,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondaryColor,
                                                  fontSize: 14,
                                                )),
                                            CustomText(
                                              "\$${logic.postList[index].startPrice ??
                                                  ''} - \$${logic.postList[index].endPrice ?? ''}",
                                              fontWeight: FontWeight.w700,
                                              color: secondaryColor,
                                              fontSize: 16,
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                                child: CustomText(
                                                  "${logic.postList[index].firstName ?? ''} ${logic
                                                      .postList[index].lastName ?? ''}",
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            if (logic.postList[index].countryFlag != null)
                                              CustomImage(
                                                url: logic.postList[index].countryFlag,
                                                height: 20,
                                              ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            if (logic.postList[index].subjectsName != null)
                                              Container(
                                                margin: const EdgeInsetsDirectional.only(end: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    color: secondaryColor.withOpacity(0.1)),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 2),
                                                child: CustomText(
                                                  logic.postList[index].subjectsName,
                                                  color: secondaryColor,
                                                ),
                                              ),
                                            if (logic.postList[index].subjectsImage != null)
                                              Container(
                                                margin: const EdgeInsetsDirectional.only(end: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    color: Colors.grey.shade200),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 5),
                                                child: CustomImage(
                                                  url: logic.postList[index].subjectsImage,
                                                  height: 20,
                                                ),
                                              )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        CustomText(logic.postList[index].description)
                                      ],
                                    ),
                                  ),
                                ))),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
