import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:you_learnt/constants/colors.dart';
import 'package:you_learnt/features/_auth/logic.dart';

import '../../../constants/images.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';

class ValidationCodePage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ValidationCodePage({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: GetBuilder<AuthLogic>(
          init: Get.find<AuthLogic>(),
          id: "checkCode",
          builder: (logic) {
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      iconLogo,
                      width: 280.w,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'A code containing 6 numbers has been sent to your email ',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: email,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text:
                                  '  to verify that you are trying to change your password'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    logic.isForgetPasswordLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(mainColor))
                        : InkWell(
                            onTap: () {
                              logic.forgetPassword(email: email);
                            },
                            child: const CustomText(
                              "Send the verification code again.",
                              textAlign: TextAlign.center,
                              color: secondaryColor,
                              lineThrough: true,
                              textDecoration: TextDecoration.underline,
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      // color: Colors.red,
                      // height: 100,
                      // width: 300,
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 2.0),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: PinCodeTextField(
                              // appContext: context,
                              length: 6,
                              appContext: context,
                              // backgroundColor: null,
                              // obsecureText: true,
                              obscureText: false,
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                              // backgroundColor: ,

                              animationType: AnimationType.fade,
                              validator: (v) {
                                if (v!.length < 6) {
                                  return "";
                                } else {
                                  return null;
                                }
                              },
                              // animationCurve: ,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                borderWidth: 1,
                                errorBorderColor: Colors.red,
                                fieldHeight: 55,
                                fieldWidth: 50,
                                selectedColor: greyTextColor,
                                inactiveColor: greyTextColor,
                                inactiveFillColor: Colors.white,
                                selectedFillColor: Colors.white,
                                activeColor: Colors.white,
                                activeFillColor: Colors.grey.withOpacity(0.4),
                              ),

                              animationDuration:
                                  const Duration(milliseconds: 300),
                              // backgroundColor: null,
                              enableActiveFill: true,
                              errorAnimationController: logic.errorController,
                              keyboardType: TextInputType.number,
                              // backgroundColor: Colors.grey,

                              controller: logic.codePinController,
                              onCompleted: (v) {
                                print("Completed");
                                // print(v);
                              },
                              onChanged: (value) {
                                // print(value);
                                // setState(() {
                                //   currentText = value;
                                // });
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return false;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    CustomButtonWidget(
                        title: 'Verify'.tr,
                        loading: logic.isCheckingValdtionCode,
                        onTap: () {
                          logic.checkValdationCode(
                            email: email
                          );
                          // _formKey.currentState!.validate();
                          // if (_formKey.currentState?.validate() == true) {
                          //   // logic.forgetPassword();
                          // }
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
