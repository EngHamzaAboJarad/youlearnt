import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/images.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/custom_widget/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/validation/validation.dart';
import '../logic.dart';

class ResetPasswordPage extends StatelessWidget {
  final GlobalKey<FormState> _forgetFormKey = GlobalKey<FormState>();

  ResetPasswordPage({Key? key, required this.email, required this.code})
      : super(key: key);

  final String email;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: GetBuilder<AuthLogic>(
          init: Get.find<AuthLogic>(),
          id: 'resetPassword',
          builder: (logic) {
            logic.emailResetController.text = email;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Form(
                  key: _forgetFormKey,
                  child: Column(
                    children: [
                      Image.asset(
                        iconLogo,
                        width: 280.w,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // const Spacer(),
                      CustomText(
                        "Reset password".tr,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomText(
                        'Please enter your new password'.tr,
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
                        controller: logic.emailResetController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        hintText: 'Password'.tr,
                        keyboardType: TextInputType.visiblePassword,
                        validator: Validation.passwordValidate,
                        controller: logic.passwordResetController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        hintText: 'Confirmation password'.tr,
                        keyboardType: TextInputType.visiblePassword,
                        validator: Validation.passwordValidate,
                        controller: logic.confirmationPasswordResetController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      CustomButtonWidget(
                          title: 'Submit'.tr,
                          loading: logic.isresetingNewPassword,
                          onTap: () {
                            if (_forgetFormKey.currentState?.validate() ==
                                true) {
                              logic.resetNewPassword(
                                  email: email,
                                  confirmationPassword: logic
                                      .confirmationPasswordResetController.text,
                                  password: logic.passwordResetController.text,
                                  code: code);
                            }
                          }),
                      const SizedBox(
                        height: 45,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
