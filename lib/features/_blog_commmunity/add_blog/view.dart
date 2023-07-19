import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:you_learnt/entities/language_model.dart';
import 'package:you_learnt/utils/validation/validation.dart';

import '../../../constants/images.dart';
import '../../../constants/colors.dart';
import '../../../entities/CommonModel.dart';
import '../../../sub_features/add_subject_dialog.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/custom_widget/custom_text_field.dart';

import '../../_main/logic.dart';
import '../../page/view.dart';
import '../profile_blog/logic.dart';

class AddBlogPage extends StatelessWidget {
  final bool edit;
  final logic = Get.find<ProfileBlogLogic>();
  // final mainLogic = Get.find<MainLogic>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddBlogPage({Key? key, required this.edit}) : super(key: key);

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    logic.handleDraft(false);
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
                    'Blog'.tr,
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
                child: GetBuilder<ProfileBlogLogic>(
                    init: Get.find<ProfileBlogLogic>(),
                    id: 'addBlog',
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
                                'Title'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                hintText: 'title here'.tr,
                                controller: logic.titleController,
                                validator: Validation.fieldValidate,
                                keyboardType: TextInputType.name,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                'Subtitle'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                hintText: "Subtitle here".tr,
                                controller: logic.subTitleController,
                                validator: null,
                                keyboardType: TextInputType.name,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                'Article'.tr,
                                fontSize: 16,
                              ),
                              HtmlEditor(
                                controller:
                                    logic.descriptionController, //required
                                htmlToolbarOptions: const HtmlToolbarOptions(
                                    toolbarType: ToolbarType.nativeGrid,
                                    dropdownIconSize: 15,
                                    defaultToolbarButtons: [
                                      StyleButtons(style: true),
                                      //  FontSettingButtons(fontSizeUnit: false),
                                      //  FontButtons(clearAll: false),
                                      ColorButtons(),
                                      ListButtons(listStyles: false),
                                      ParagraphButtons(
                                          textDirection: false,
                                          increaseIndent: false,
                                          decreaseIndent: false,
                                          lineHeight: false,
                                          caseConverter: false),
                                    ]),

                                otherOptions: OtherOptions(
                                  height: 300.h,
                                ),
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
                                  itemCount: logic.tagsControllerList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
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
                              GestureDetector(
                                onTap: () {
                                  logic.addTag();
                                },
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.grey.shade300)),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<CommonModel>(
                                                isExpanded: true,
                                                hint: CustomText(
                                                  logic.selectedCategory
                                                          ?.categoryName ??
                                                      'Select'.tr,
                                                  fontSize: 16,
                                                  color:
                                                      logic.selectedCategory !=
                                                              null
                                                          ? Colors.black
                                                          : Colors
                                                              .grey.shade700,
                                                ),
                                                //   value: list[0],
                                                items: logic
                                                    .mainLogic.categoriesList
                                                    .map((e) =>
                                                        DropdownMenuItem<
                                                            CommonModel>(
                                                          child: CustomText(
                                                              e.categoryName),
                                                          value: e,
                                                        ))
                                                    .toList(),
                                                onChanged: (val) => logic
                                                    .onChangeCategory(val)),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Get.bottomSheet(AddSubjectDialog(
                                                    category: true))
                                                .then((value) {
                                              if (value != null) {
                                                var subject =
                                                    CommonModel.fromJson(value);
                                                logic.selectedCategory =
                                                    subject;
                                                logic.update(['addBlog']);
                                              }
                                            });
                                          },
                                          icon: const Icon(
                                              Icons.add_box_outlined))
                                    ],
                                  ),
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
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomText(
                                      'Cover image'.tr,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () => Get.to(PagePage(
                                            pageModel: Get.find<MainLogic>()
                                                .recommendationsPage,
                                            type: 2,
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
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  log("entered image");
                                  print("entered image");
                                  logic.addImage();
                                },
                                child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10),
                                    strokeWidth: 1,
                                    dashPattern: const [6],
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 20),
                                    color: Colors.grey.shade400,
                                    child: logic.imagePath != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              File(logic.imagePath!),
                                              width: double.infinity,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              Image.asset(
                                                iconImage,
                                                color: Colors.grey,
                                                scale: 2,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              CustomText(
                                                'Upload Cover Image'.tr,
                                                color: Colors.grey,
                                              )
                                            ],
                                          )),
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
                                          logic.addBlog(edit);
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
