import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/_profile/logic.dart';
import 'package:you_learnt/utils/custom_widget/custom_button_widget.dart';
import 'package:you_learnt/utils/custom_widget/custom_text_field.dart';

import '../../../constants/colors.dart';
import '../../../entities/CommonModel.dart';
import '../../../sub_features/add_subject_dialog.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/validation/validation.dart';

class TutorRequestPage extends StatelessWidget {
  final List<String> list = ['1', '2'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TutorRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
      body: Container(
        color: secondaryColor,
        child: Form(
          key: _formKey,
          child: GetBuilder<ProfileLogic>(
              init: Get.find<ProfileLogic>(),
              id: 'addPost',
              builder: (logic) {
                return Column(
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
                            'Tutor request'.tr,
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
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25))),
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
                                      'Title'.tr,
                                      fontSize: 16,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomTextField(
                                      hintText: "E.g., I’m looking for…".tr,
                                      controller: logic.titleController,
                                      fontSize: 12,
                                      validator: Validation.fieldValidate,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomText(
                                      'Subject'.tr,
                                      fontSize: 16,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                border:
                                                    Border.all(color: Colors.grey.shade300)),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<CommonModel>(
                                                  isExpanded: true,
                                                  hint: CustomText(
                                                    logic.selectedSubject?.name ?? 'choose'.tr,
                                                    fontSize: 16,
                                                    color: logic.selectedSubject != null
                                                        ? Colors.black
                                                        : Colors.grey.shade400,
                                                  ),
                                                  //   value: list[0],
                                                  items: logic.authLogic.subjectsWithoutAddList
                                                      .map((e) => DropdownMenuItem<CommonModel>(
                                                            child: CustomText(e.name),
                                                            value: e,
                                                          ))
                                                      .toList(),
                                                  onChanged: (val) =>
                                                      logic.onChangeSubject(val)),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Get.bottomSheet(AddSubjectDialog()).then((value) {
                                                if (value != null) {
                                                  log(value.toString());
                                                  var subject = CommonModel.fromJson(value);
                                                  logic.selectedSubject = subject;
                                                  logic.update(['addPost']);
                                                }
                                              });
                                            },
                                            icon: const Icon(Icons.add_box_outlined))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomText(
                                      'Expected budget'.tr,
                                      fontSize: 16,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    /*
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(color: Colors.grey.shade300)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                            isExpanded: true,
                                            hint: CustomText(
                                              '\$15 - \$20'.tr,
                                              fontSize: 16,
                                              color: Colors.grey.shade400,
                                            ),
                                            //   value: list[0],
                                            items: list
                                                .map((e) => DropdownMenuItem<String>(
                                                      child: CustomText(e),
                                                      value: e,
                                                    ))
                                                .toList(),
                                            onChanged: (val) {}),
                                      ),
                                    ),*/
                                    Row(
                                      children: [
                                        Expanded(
                                            child: CustomTextField(
                                          hintText: 'Start'.tr,
                                          keyboardType: TextInputType.number,
                                          prefixIcon: const Icon(Icons.attach_money),
                                          validator: Validation.fieldValidate,
                                          controller: logic.startPriceController,
                                        )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: CustomTextField(
                                          hintText: 'End'.tr,
                                          keyboardType: TextInputType.number,
                                          prefixIcon: const Icon(Icons.attach_money),
                                          validator: Validation.fieldValidate,
                                          controller: logic.endPriceController,
                                        )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomText(
                                      'Details'.tr,
                                      fontSize: 16,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomTextField(
                                      fontSize: 12,
                                      maxLines: null,
                                      controller: logic.descriptionController,
                                      validator: Validation.fieldValidate,
                                      height: 120.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10, bottom: 30.h),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: CustomButtonWidget(
                                    title: 'Cancel'.tr,
                                    color: Colors.white,
                                    textColor: primaryColor,
                                    widthBorder: 0.5,
                                    onTap: () => Get.back(),
                                  )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: CustomButtonWidget(
                                    title: 'Submit'.tr,
                                    loading: logic.isLoading,
                                    onTap: () {
                                      if (_formKey.currentState?.validate() == true) {
                                        logic.addPost();
                                      }
                                    },
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
