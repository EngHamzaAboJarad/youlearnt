import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/_profile/education/widgets/item_education.dart';
import 'package:you_learnt/features/_profile/education/widgets/item_education_form.dart';

import '../../../constants/colors.dart';
import '../../../entities/EducationModel.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'logic.dart';

class EducationPage extends StatelessWidget {
  final logic = Get.put(EducationLogic());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EducationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logic.getEducation();
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
                    'Education'.tr,
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
                child: GetBuilder<EducationLogic>(builder: (logic) {
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
                                      if (logic.educationsList.isNotEmpty)
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: logic.educationsList.length,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                ItemEducation(
                                                    education:
                                                        logic.educationsList[index])),
                                      CustomText(
                                        logic.educationsList.length > 1
                                            ? 'Add new education'.tr
                                            : 'Add education'.tr,
                                        fontSize: 20,
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: logic.newEducationsList.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) =>
                                              ItemEducationForm(
                                                education: logic.newEducationsList[index],
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
                                            logic.educationsList.length > 1
                                                ? '+ Add another education'.tr
                                                : '+ Add education'.tr,
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
                                        logic.newEducationsList = [EducationModel()];
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
                                          logic.addEducation();
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
