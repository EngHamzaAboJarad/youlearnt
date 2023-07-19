import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/entities/ExperienceModel.dart';
import 'package:you_learnt/features/_profile/education/widgets/item_education.dart';
import 'package:you_learnt/features/_profile/education/widgets/item_education_form.dart';

import '../../../constants/colors.dart';
import '../../../entities/EducationModel.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'logic.dart';
import 'widgets/item_experience.dart';
import 'widgets/item_experience_form.dart';

class ExperiencePage extends StatelessWidget {
  final logic = Get.put(ExperienceLogic());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ExperiencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logic.getExperience();
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
                    'Work experience'.tr,
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
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                child: GetBuilder<ExperienceLogic>(builder: (logic) {
                  return logic.isLoading
                      ? const SizedBox(
                          height: 20,
                          child: SizedBox(
                              child: Center(
                                  child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ))))
                      : Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (logic.experienceList.isNotEmpty)
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: logic.experienceList.length,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                ItemExperience(
                                                    education:
                                                        logic.experienceList[index])),
                                      CustomText(
                                        logic.experienceList.length > 1
                                            ? 'Add new work experience'.tr
                                            : 'Add work experience'.tr,
                                        fontSize: 20,
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: logic.newExperienceList.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) =>
                                              ItemExperienceForm(
                                                education: logic.newExperienceList[index],
                                                index: index,
                                              )),
                                      InkWell(
                                        onTap: () => logic.addNewEducation(),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color:
                                                  secondaryLightColor.withOpacity(0.3)),
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          child: CustomText(
                                            '+ ' +
                                                (logic.experienceList.length > 1
                                                    ? 'Add another experience'.tr
                                                    : 'Add work experience'.tr),
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
                                padding:
                                    EdgeInsets.only(left: 10, right: 10, bottom: 30.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: CustomButtonWidget(
                                      title: 'Cancel'.tr,
                                      color: Colors.white,
                                      textColor: primaryColor,
                                      widthBorder: 0.5,
                                      onTap: () {
                                        logic.newExperienceList = [ExperienceModel()];
                                        Get.back();
                                      },
                                    )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: CustomButtonWidget(
                                      title: 'Save'.tr,
                                      loading: logic.isAddLoading,
                                      onTap: () {
                                        if (_formKey.currentState?.validate() == true) {
                                          logic.addExperience();
                                        }
                                      },
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
