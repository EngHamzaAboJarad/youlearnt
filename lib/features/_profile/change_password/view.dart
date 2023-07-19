import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/utils/custom_widget/custom_button_widget.dart';
import 'package:you_learnt/utils/custom_widget/custom_text_field.dart';
import 'package:you_learnt/utils/validation/validation.dart';

import '../../../constants/colors.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'logic.dart';

class ChangePasswordPage extends StatelessWidget {
  final logic = Get.put(ChangePasswordLogic());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                    'Change password'.tr,
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
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                'Current password'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                controller: logic.currentPasswordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                validator: Validation.passwordValidate,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                'New password'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                controller: logic.newPasswordController,
                                validator: Validation.passwordValidate,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                'Re-enter new password'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                controller: logic.reNewPasswordController,
                                validator: Validation.passwordValidate,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            ],
                          ),
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
                          GetBuilder<ChangePasswordLogic>(builder: (logic) {
                            return Expanded(
                                child: CustomButtonWidget(
                                  title: 'Save'.tr,
                                  loading: logic.isLoading,
                                  onTap: () {
                                    if (_formKey.currentState?.validate() == true) {
                                      logic.changePassword();
                                    }
                                  },
                                ));
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
