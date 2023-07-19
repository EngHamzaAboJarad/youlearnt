
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/entities/CommonModel.dart';

import '../../../constants/colors.dart';
import '../../../entities/language_model.dart';
import '../../../sub_features/add_subject_dialog.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/custom_widget/custom_text_field.dart';
import '../../../utils/validation/validation.dart';
import '../profile_community/logic.dart';

class AddCommunityPage extends StatelessWidget {
  final bool edit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddCommunityPage({Key? key, required this.edit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<ProfileCommunityLogic>().handleDraft(edit);
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
                    'Community (Q&A) '.tr,
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
                child: GetBuilder<ProfileCommunityLogic>(
                    init: Get.find<ProfileCommunityLogic>(),
                    builder: (logic) {
                      return SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                'Question'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                // hintText: 'question here'.tr,
                                controller: logic.titleController,
                                validator: Validation.fieldValidate,
                                keyboardType: TextInputType.name,
                                maxLength: 100,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                'Answer'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                controller: logic.descriptionController,
                                validator: Validation.fieldValidate,
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                'Tags'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: logic.tagsControllerList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CustomTextField(
                                                hintText:
                                                    '#design    #arabic'.tr,
                                                controller: logic
                                                    .tagsControllerList[index],
                                                focusNode:
                                                    logic.tagsFocusList[index],
                                                validator:
                                                    Validation.fieldValidate,
                                                keyboardType:
                                                    TextInputType.multiline,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () =>
                                                    logic.removeTag(index),
                                                icon: const Icon(
                                                    Icons.delete_outline))
                                          ],
                                        ),
                                      )),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () => logic.addTag(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomText(
                                      '+ Add tag'.tr,
                                      color: secondaryColor,
                                      fontSize: 16,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300)),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<
                                                          CommonModel>(
                                                      isExpanded: true,
                                                      hint: CustomText(
                                                        logic.selectedSubject
                                                                ?.name ??
                                                            'Select'.tr,
                                                        fontSize: 16,
                                                        color:
                                                            logic.selectedSubject !=
                                                                    null
                                                                ? Colors.black
                                                                : Colors.grey
                                                                    .shade700,
                                                      ),
                                                      //   value: list[0],
                                                      items: logic.authLogic
                                                          .subjectsWithoutAddList
                                                          .map((e) =>
                                                              DropdownMenuItem<
                                                                  CommonModel>(
                                                                child:
                                                                    CustomText(
                                                                        e.name),
                                                                value: e,
                                                              ))
                                                          .toList(),
                                                      onChanged: (val) =>
                                                          logic.onChangeSubject(
                                                              val)),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Get.bottomSheet(
                                                          AddSubjectDialog())
                                                      .then((value) {
                                                    if (value != null) {
                                                      // log(value.toString());
                                                      var subject =
                                                          CommonModel.fromJson(
                                                              value);
                                                      logic.selectedSubject =
                                                          subject;
                                                      logic.update();
                                                    }
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.add_box_outlined))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          'Category'.tr,
                                          fontSize: 16,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300)),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<
                                                          CommonModel>(
                                                      isExpanded: true,
                                                      hint: CustomText(
                                                        logic.selectedCategory
                                                                ?.categoryName ??
                                                            'Select'.tr,
                                                        fontSize: 14,
                                                        color:
                                                            logic.selectedCategory !=
                                                                    null
                                                                ? Colors.black
                                                                : Colors.grey
                                                                    .shade700,
                                                      ),
                                                      //   value: list[0],
                                                      items: logic.mainLogic
                                                          .categoriesList
                                                          .map((e) =>
                                                              DropdownMenuItem<
                                                                  CommonModel>(
                                                                child: CustomText(
                                                                    e.categoryName),
                                                                value: e,
                                                              ))
                                                          .toList(),
                                                      onChanged: (val) => logic
                                                          .onChangeCategory(
                                                              val)),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Get.bottomSheet(
                                                      AddSubjectDialog(
                                                    category: true,
                                                  )).then((value) {
                                                    if (value != null) {
                                                      // log(value.toString());
                                                      var subject =
                                                          CommonModel.fromJson(
                                                              value);
                                                      logic.selectedCategory =
                                                          subject;
                                                      logic.update();
                                                    }
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.add_box_outlined))
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    'Language'.tr,
                                    fontSize: 16,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.grey.shade300)),
                                          child: DropdownButtonHideUnderline(
                                            child:
                                                DropdownButton<LanguageModel>(
                                                    isExpanded: true,
                                                    hint: CustomText(
                                                      logic
                                                              .mainLogic
                                                              .selectedLanguage
                                                              ?.name ??
                                                          'Select'.tr,
                                                      fontSize: 16,
                                                      color: logic.mainLogic
                                                                  .selectedLanguage !=
                                                              null
                                                          ? Colors.black
                                                          : Colors
                                                              .grey.shade700,
                                                    ),
                                                    //   value: list[0],
                                                    items: logic
                                                        .mainLogic.languagesList
                                                        .map((e) =>
                                                            DropdownMenuItem<
                                                                LanguageModel>(
                                                              child: CustomText(
                                                                  e.name),
                                                              value: e,
                                                            ))
                                                        .toList(),
                                                    onChanged: (val) => logic
                                                        .onChangeLanguage(val)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: 40.h, top: 40.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: CustomButtonWidget(
                                      title: 'Draft'.tr,
                                      color: Colors.white,
                                      textColor: primaryColor,
                                      widthBorder: 0.5,
                                      onTap: () => logic.draftBlog(),
                                    )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: CustomButtonWidget(
                                      title: 'Publish'.tr,
                                      loading: logic.isAddLoading,
                                      onTap: () {
                                        if (_formKey.currentState?.validate() ==
                                            true) {
                                          logic.addCommunity(edit);
                                        }
                                      },
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
