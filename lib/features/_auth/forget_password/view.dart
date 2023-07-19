import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/images.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/custom_widget/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/validation/validation.dart';
import '../logic.dart';

class ForgetPasswordPage extends StatelessWidget {
  final GlobalKey<FormState> _forgetFormKey = GlobalKey<FormState>();

  ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: GetBuilder<AuthLogic>(
          init: Get.find<AuthLogic>(),
          id: 'forgetPassword',
          builder: (logic) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _forgetFormKey,
                child: Column(
                  children: [
                    Image.asset(
                      iconLogo,
                      width: 280.w,
                    ),
                    const Spacer(),
                    CustomText(
                      'Forgot password'.tr,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomText(
                      'Please enter your email or phone number then we will help you create a new password'
                          .tr,
                      textAlign: TextAlign.center,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                      hintText: 'example@gmail.com'.tr,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validation.emailValidate,
                      controller: logic.emailForgetPasswordNameController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomButtonWidget(
                        title: 'Submit'.tr,
                        loading: logic.isForgetPasswordLoading,
                        onTap: () {
                          if (_forgetFormKey.currentState?.validate() == true) {
                            logic.forgetPassword(
                                email: logic
                                    .emailForgetPasswordNameController.text);
                          }
                        }),
                    const SizedBox(
                      height: 45,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
