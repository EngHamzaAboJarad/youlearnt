import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/entities/CommonModel.dart';
import 'package:you_learnt/utils/custom_widget/custom_button_widget.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';
import 'package:you_learnt/utils/custom_widget/custom_text_field.dart';
import 'package:you_learnt/utils/validation/validation.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthPage extends StatelessWidget {
  final AuthLogic logic = Get.find();

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: GetBuilder<AuthLogic>(builder: (logic) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Image.asset(
                iconLogo,
                scale: 2,
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomText(
                logic.loginIsSelected ? 'Log In'.tr : 'Sign Up'.tr,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => logic.changeLoginState(mLoginIsSelected: true),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CustomText(
                            'Log In'.tr,
                            fontSize: 18,
                            fontWeight: logic.loginIsSelected ? FontWeight.bold : null,
                          ),
                          SizedBox(
                            height: logic.loginIsSelected ? 15 : 18,
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              height: logic.loginIsSelected ? 4 : 1,
                              color: logic.loginIsSelected ? secondaryColor : secondaryLightColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => logic.changeLoginState(mLoginIsSelected: false),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CustomText(
                            'Sign Up'.tr,
                            fontSize: 18,
                            color: !logic.loginIsSelected
                                ? logic.isTutor
                                    ? primaryColor
                                    : secondaryColor
                                : Colors.black,
                            fontWeight: !logic.loginIsSelected ? FontWeight.bold : null,
                          ),
                          SizedBox(
                            height: !logic.loginIsSelected ? 15 : 18,
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              height: !logic.loginIsSelected ? 4 : 1,
                              color: !logic.loginIsSelected
                                  ? logic.isTutor
                                      ? primaryColor
                                      : secondaryColor
                                  : secondaryLightColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(child: logic.loginIsSelected ? buildLogIn(logic) : buildSignUp(logic)),
            ],
          ),
        );
      }),
    );
  }

  SingleChildScrollView buildSignUp(AuthLogic logic) {
    return SingleChildScrollView(
      child: Form(
        key: _registerFormKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => logic.changeAccountState(mIsTutor: true),
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: logic.isTutor ? null : secondaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade200, width: 2)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          logic.isTutor
                              ? const Icon(
                                  Icons.radio_button_off,
                                  size: 30,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.check_circle_sharp,
                                  size: 30,
                                  color: secondaryColor,
                                ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  'I am a'.tr,
                                  fontSize: 14,
                                  color: logic.isTutor ? Colors.black : secondaryColor,
                                ),
                                CustomText(
                                  'STUDENT'.tr,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: logic.isTutor ? Colors.black : secondaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => logic.changeAccountState(mIsTutor: false),
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          color: !logic.isTutor ? null : primaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade200, width: 2)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          !logic.isTutor
                              ? const Icon(
                                  Icons.radio_button_off,
                                  size: 30,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.check_circle_sharp,
                                  size: 30,
                                  color: primaryColor,
                                ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  'I am a'.tr,
                                  fontSize: 14,
                                  color: !logic.isTutor ? Colors.black : primaryColor,
                                ),
                                CustomText(
                                  'TUTOR'.tr,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: !logic.isTutor ? Colors.black : primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              hintText: 'First name'.tr,
              keyboardType: TextInputType.name,
              validator: Validation.firstnameValidate,
              controller: logic.firstNameController,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              hintText: 'Last name'.tr,
              keyboardType: TextInputType.name,
              validator: Validation.lastnameValidate,
              controller: logic.lastNameController,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              hintText: 'Email'.tr,
              keyboardType: TextInputType.emailAddress,
              validator: Validation.emailValidate,
              controller: logic.emailRegisterNameController,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              hintText: 'Password'.tr,
              validator: Validation.passwordValidate,
              keyboardType: TextInputType.visiblePassword,
              controller: logic.passwordRegisterNameController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300)),
                    child: logic.isCountriesLoading
                        ? const Center(
                            child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                )),
                          )
                        : DropdownButtonHideUnderline(
                            child: DropdownButton<CommonModel>(
                                isExpanded: true,
                                hint: CustomText(
                                  logic.selectedCountry?.name ?? 'Country'.tr,
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                                //   value: list[0],
                                items: logic.countriesList
                                    .map((e) => DropdownMenuItem<CommonModel>(
                                          child: CustomText(e.name),
                                          value: e,
                                        ))
                                    .toList(),
                                onChanged: (val) => logic.onChangeCountry(val)),
                          ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300)),
                    child: logic.isCitiesLoading
                        ? const Center(
                            child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                )),
                          )
                        : DropdownButtonHideUnderline(
                            child: DropdownButton<CommonModel>(
                                isExpanded: true,
                                hint: CustomText(
                                  logic.selectedCities?.name ?? 'City'.tr,
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                                //   value: list[0],
                                items: logic.citiesList
                                    .map((e) => DropdownMenuItem<CommonModel>(
                                          child: CustomText(e.name),
                                          value: e,
                                        ))
                                    .toList(),
                                onChanged: (val) => logic.onChangeCity(val)),
                          ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            CustomButtonWidget(
                title: 'Sign Up'.tr,
                loading: logic.isRegisterLoading,
                onTap: () {
                  if (_registerFormKey.currentState?.validate() == true) {
                    logic.register();
                  }
                }),
            const SizedBox(
              height: 15,
            ),
            Center(
                child: CustomText(
              'OR\nSign Up with'.tr,
              color: Colors.grey.shade700,
              textAlign: TextAlign.center,
            )),
            const SizedBox(
              height: 15,
            ),
            buildSocialLogin(),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText('Have an account?'.tr),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                    onTap: () => logic.changeLoginState(mLoginIsSelected: true),
                    child: CustomText(
                      'Log In'.tr,
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildLogIn(AuthLogic logic) {
    return SingleChildScrollView(
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            CustomTextField(
              hintText: 'Email address or username'.tr,
              keyboardType: TextInputType.emailAddress,
              validator: Validation.emailValidate,
              controller: logic.emailLoginNameController,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              hintText: 'Password'.tr,
              keyboardType: TextInputType.visiblePassword,
              validator: Validation.passwordValidate,
              controller: logic.passwordLoginNameController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    margin: const EdgeInsetsDirectional.only(end: 10, start: 2),
                    padding: const EdgeInsets.all(2),
                    alignment: Alignment.center,
                    child: Image.asset(iconCheck2),
                  ),
                ),
                Expanded(
                    child: CustomText(
                  'Remember me'.tr,
                  color: Colors.grey.shade700,
                  fontSize: 16,
                )),
                GestureDetector(
                    onTap: () => logic.goToForgetPassword(),
                    child: CustomText(
                      'Forgot password?'.tr,
                      color: secondaryColor,
                      fontSize: 16,
                    )),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            CustomButtonWidget(
                title: 'Log In'.tr,
                loading: logic.isLoginLoading,
                onTap: () {
                  if (_loginFormKey.currentState?.validate() == true) {
                    logic.login();
                  }
                }),
            const SizedBox(
              height: 15,
            ),
            Center(
                child: CustomText(
              'OR\nLog in with'.tr,
              color: Colors.grey.shade700,
              textAlign: TextAlign.center,
            )),
            const SizedBox(
              height: 15,
            ),
            buildSocialLogin(),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText('Don’t have an account?'.tr),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                    onTap: () => logic.changeLoginState(mLoginIsSelected: false),
                    child: CustomText(
                      'Sign Up'.tr,
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  buildSocialLogin() {
    return (logic.isSocialLoading)
        ? const Center(child: CircularProgressIndicator())
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => logic.googleSignIn(),
                child: Image.asset(
                  btnGoogle,
                  scale: 3,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () => logic.facebookSignIn(),
                child: Image.asset(
                  btnFacebook,
                  scale: 3,
                ),
              ),
            ],
          );
  }
}
