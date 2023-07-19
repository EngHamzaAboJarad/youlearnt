
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/_main/logic.dart';
import 'package:you_learnt/features/page/view.dart';

import '../../../constants/colors.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/custom_widget/custom_text_field.dart';
import '../../../utils/validation/validation.dart';
import 'logic.dart';

class ProfileDescriptionPage extends StatelessWidget {
  final logic = Get.put(ProfileDescriptionLogic());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProfileDescriptionPage({Key? key}) : super(key: key);

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
                    'Profile description'.tr,
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
                child: GetBuilder<ProfileDescriptionLogic>(builder: (logic) {
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
                                  height: 10,
                                ),
                                CustomText(
                                  'Profile Bio'.tr,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextField(
                                  hintText:
                                      "Master's degree and five years of experience teaching math to kids."
                                          .tr,
                                  keyboardType: TextInputType.multiline,
                                  validator: Validation.fieldValidate,
                                  controller: logic.bioController,
                                  fontSize: 14,
                                  maxLines: null,
                                  maxLength: 160,
                                  height: 90.h,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomText(
                                  'Introduce yourself'.tr,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextField(
                                  keyboardType: TextInputType.multiline,
                                  validator: Validation.fieldValidate,
                                  controller: logic.introduceYourSelfController,
                                  fontSize: 14,
                                  maxLines: null,
                                  height: 120.h,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomText(
                                  'Introduction about yourself by other languages you can teach in'
                                      .tr,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextField(
                                  keyboardType: TextInputType.multiline,
                                  validator: Validation.fieldValidate,
                                  controller: logic
                                      .introduceYourSelfOtherLanguageController,
                                  maxLines: null,
                                  fontSize: 14,
                                  height: 120.h,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomText(
                                  'Introduction Video'.tr,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        hintText:
                                            'Insert your introduction video URL here'
                                                .tr,
                                        keyboardType: TextInputType.url,
                                        validator: Validation.fieldValidate,
                                        controller: logic.linkController,
                                        fontSize: 14,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () => Get.to(PagePage(
                                              pageModel: Get.find<MainLogic>()
                                                  .recommendationsPage,
                                              type: 1,
                                            )),
                                        icon: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            padding: const EdgeInsets.all(2),
                                            child: const Icon(
                                              Icons.question_mark,
                                              size: 18,
                                            )))
                                  ],
                                ),
                                /*
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextField(
                                  hintText: 'Insert your custom URL here'.tr,
                                  keyboardType: TextInputType.url,
                                  validator: Validation.fieldValidate,
                                  controller: logic.customLinkController,
                                  fontSize: 14,
                                ),*/
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
