
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/_profile/profile_description/widgets/item_subject.dart';

import '../../../constants/colors.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'logic.dart';

class TeacherProfileSubjects extends StatelessWidget {
  final logic = Get.put(TeacherPrfileSubjectsLogic());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TeacherProfileSubjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
      body: Container(
        color: secondaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'Profile'.tr,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  CustomText(
                    'Subjects'.tr,
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25))),
                child: GetBuilder<TeacherPrfileSubjectsLogic>(builder: (logic) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomText(
                                  'Subject taught'.tr,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                    itemCount: logic.subjectsList.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(bottom: 5),
                                    itemBuilder: (context, index) =>
                                        ItemSubject(index: index)),
                                InkWell(
                                  onTap: () => logic.addNewSubject(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: secondaryLightColor
                                            .withOpacity(0.3)),
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: CustomText(
                                      logic.subjectsList.length > 1
                                          ? '+ Add another subject'.tr
                                          : '+ Add subject'.tr,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 40.h),
                          child: Row(
                            children: [
                              Expanded(
                                  child: CustomButtonWidget(
                                title: 'Cancel'.tr,
                                color: Colors.white,
                                textColor: primaryColor,
                                widthBorder: 0.5,
                                onTap: () {
                                  logic.initUserModel();
                                  Get.back();
                                },
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: CustomButtonWidget(
                                title: 'Save'.tr,
                                loading: logic.isLoading,
                                onTap: () => logic.updatePersonalInformation(),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
