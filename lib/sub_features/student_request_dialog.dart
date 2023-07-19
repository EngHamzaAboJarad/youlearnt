import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/_main/find_student/logic.dart';
import 'package:you_learnt/features/report/view.dart';
import 'package:you_learnt/utils/custom_widget/custom_text_field.dart';

import '../constants/colors.dart';
import '../constants/images.dart';
import '../entities/PostModel.dart';
import '../utils/custom_widget/custom_button_widget.dart';
import '../utils/custom_widget/custom_image.dart';
import '../utils/custom_widget/custom_text.dart';
import '../utils/validation/validation.dart';

class StudentRequestDialog extends StatelessWidget {
  final PostModel post;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  StudentRequestDialog({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
      child: Form(
        key: _formKey,
        child: GetBuilder<FindStudentLogic>(
            init: Get.find<FindStudentLogic>(),
            id: post.id ?? '0',
            builder: (logic) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CustomText(
                        post.title,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                            width: 45.sp,
                            height: 45.sp,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.sp),
                                color: greenColor),
                            padding: const EdgeInsets.all(1.5),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.sp),
                                child: CustomImage(
                                  url: post.profileImage,
                                ))),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: CustomText(
                          "${post.firstName ?? ''} ${post.lastName ?? ''}",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 14,
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        if (post.countryFlag != null)
                          CustomImage(
                            url: post.countryFlag,
                            height: 20,
                          ),
                        const SizedBox(
                          width: 10,
                        ),
                        if (post.languagesFlag != null)
                          Container(
                            margin: const EdgeInsetsDirectional.only(end: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: CustomImage(
                              url: post.subjectsImage,
                              height: 20,
                            ),
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(post.description),
                    if (post.subjectsName != null)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CustomText(
                              'Subject'.tr + ':',
                              fontSize: 16,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              margin: const EdgeInsetsDirectional.only(end: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: secondaryColor.withOpacity(0.1)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              child: CustomText(
                                post.subjectsName,
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          CustomText(
                            'Budget'.tr + ':',
                            fontSize: 16,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          CustomText(
                            "\$${post.startPrice ?? ''} - \$${post.endPrice ?? ''}",
                            fontWeight: FontWeight.w700,
                            color: secondaryColor,
                            fontSize: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomText(
                      'Hourly rate'.tr,
                      color: greyTextColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: Validation.fieldValidate,
                      prefixIcon: const Icon(Icons.attach_money),
                      controller: logic.priceController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      'Offer details'.tr,
                      color: greyTextColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      hintText: '',
                      keyboardType: TextInputType.text,
                      validator: Validation.fieldValidate,
                      controller: logic.descriptionController,
                      height: 120.h,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: CustomButtonWidget(
                                title: 'Cancel'.tr,
                                height: 80.h,
                                color: Colors.white,
                                textColor: Colors.black,
                                widthBorder: 0.55,
                                onTap: () => Get.back())),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: CustomButtonWidget(
                                title: 'Add offer'.tr,
                                loading: logic.isLoading,
                                height: 80.h,
                                onTap: () {
                                  if (_formKey.currentState?.validate() ==
                                      true) {
                                    logic.newProposal(post.id);
                                  }
                                })),
                        const SizedBox(width: 10,),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black)),
                            child: IconButton(
                                onPressed: () =>Get.to(ReportPage(id: post.userId,)),
                                icon: const Icon(Icons.report_gmailerrorred)))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
