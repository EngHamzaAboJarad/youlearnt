import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/custom_widget/custom_text_field.dart';
import '../../utils/validation/validation.dart';
import 'logic.dart';

class ReportPage extends StatelessWidget {
final int? id;
  final logic = Get.put(ReportLogic());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

   ReportPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: secondaryColor,
        child: GetBuilder<ReportLogic>(builder: (logic) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'Report'.tr,
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
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                               //   hintText: 'title'.tr,
                                  keyboardType: TextInputType.name,
                                  validator: Validation.fieldValidate,
                                  controller: logic.titleController,
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
                                  keyboardType: TextInputType.multiline,
                                  validator: Validation.fieldValidate,
                                  controller: logic.detailsController,
                                  maxLines: 8,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomText(
                                  'Images'.tr,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                ListView.builder(
                                    itemCount: logic.imagesList.length,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => InkWell(
                                        onTap: () => logic.addImage(index),
                                        child: DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(10),
                                            strokeWidth: 1,
                                            dashPattern: const [6],
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            color: Colors.grey.shade400,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                File(logic.imagesList[index]),
                                                width: double.infinity,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            )))),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () => logic.addImage(null),
                                  child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(10),
                                      strokeWidth: 1,
                                      dashPattern: const [6],
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 20),
                                      color: Colors.grey.shade400,
                                      child: Row(
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
                                            logic.imagesList.isNotEmpty
                                                ? 'Upload new image'
                                                : 'Upload image'.tr,
                                            color: Colors.grey,
                                          )
                                        ],
                                      )),
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
                              left: 10, right: 10, bottom: 30.h),
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
                                title: 'Send'.tr,
                                loading: logic.isLoading,
                                onTap: () {
                                  if (_formKey.currentState?.validate() ==
                                      true) {
                                    logic.report(id);
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
            ),
          );
        }),
      ),
    );
  }
}
