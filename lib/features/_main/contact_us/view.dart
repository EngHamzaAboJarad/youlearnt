import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/custom_widget/custom_text_field.dart';
import '../../../utils/validation/validation.dart';
import 'logic.dart';

class ContactUsPage extends StatelessWidget {
  final logic = Get.put(ContactUsLogic());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
      body: Container(
        color: secondaryColor,
        child: GetBuilder<ContactUsLogic>(builder: (logic) {
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
                        ''.tr,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      CustomText(
                        'Contact Us'.tr,
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
                                  'Name'.tr,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextField(
                                //  hintText: 'Name'.tr,
                                  keyboardType: TextInputType.name,
                                  validator: Validation.nameValidate,
                                  controller: logic.nameController,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomText(
                                  'Email'.tr,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextField(
                                //  hintText: 'Email'.tr,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: Validation.emailValidate,
                                  controller: logic.emailController,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomText(
                                  'Contact reason'.tr,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.grey.shade300)),
                                  child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                              isExpanded: true,
                                              hint: CustomText(
                                                logic.selectedReason,
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                              //   value: list[0],
                                              items: logic.reasonList
                                                  .map((e) =>
                                                      DropdownMenuItem<String>(
                                                        child: CustomText(e),
                                                        value: e,
                                                      ))
                                                  .toList(),
                                              onChanged: (val) =>
                                                  logic.onReasonSelected(val)),
                                        ),
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
                                  maxLines: 5,
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
                                    logic.sendContactUs();
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
