import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/utils/custom_widget/custom_button_widget.dart';
import 'package:you_learnt/utils/custom_widget/custom_text_field.dart';

import '../../../constants/colors.dart';
import '../../../entities/CommonModel.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/validation/validation.dart';
import '../../_auth/logic.dart';
import '../logic.dart';

class PersonalInformationPage extends StatelessWidget {
  PersonalInformationPage({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
      body: Container(
        color: secondaryColor,
        child: GetBuilder<ProfileLogic>(
            init: Get.find<ProfileLogic>(),
            id: 'personal',
            builder: (logic) {
              return Form(
                key: _formKey,
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
                            'Personal Information'.tr,
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
                                      'First name'.tr,
                                      fontSize: 16,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomTextField(
                                      // hintText: 'First name'.tr,
                                      keyboardType: TextInputType.name,
                                      validator: Validation.firstnameValidate,
                                      controller: logic.firstNameController,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomText(
                                      'Last name'.tr,
                                      fontSize: 16,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomTextField(
                                      //hintText: 'Last name'.tr,
                                      keyboardType: TextInputType.name,
                                      validator: Validation.lastnameValidate,
                                      controller: logic.lastNameController,
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
                                      //hintText: 'Email'.tr,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: Validation.emailValidate,
                                      controller: logic.emailController,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomText(
                                      'Phone'.tr,
                                      fontSize: 16,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomTextField(
                                      //hintText: 'Phone'.tr,
                                      keyboardType: TextInputType.phone,
                                      validator: Validation.phoneValidate,
                                      controller: logic.phoneController,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomText(
                                      'Date of birth'.tr,
                                      fontSize: 16,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomTextField(
                                      onTap: () => logic.onTapBirthday(),
                                      //hintText: 'Birthday'.tr,
                                      keyboardType: TextInputType.datetime,
                                      controller: logic.birthdayController,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    buildGetBuilder(),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
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
                                    onTap: () {
                                      logic.initUserModel();
                                      Get.back();
                                    },
                                  )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: CustomButtonWidget(
                                    title: 'Save'.tr,
                                    loading: logic.isPersonalLoading,
                                    onTap: () {
                                      if (_formKey.currentState?.validate() == true) {
                                        logic.updatePersonalInformation();
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

  GetBuilder<AuthLogic> buildGetBuilder() {
    return GetBuilder<AuthLogic>(
        init: Get.find<AuthLogic>(),
        builder: (logic) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Country'.tr,
                          fontSize: 16,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
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

                                        color: logic.selectedCountry == null
                                            ? Colors.grey.shade700
                                            : Colors.black,
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'City'.tr,
                          fontSize: 16,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
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
                                        color: logic.selectedCities == null
                                            ? Colors.grey.shade700
                                            : Colors.black,
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
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Time zone'.tr,
                          fontSize: 16,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GetBuilder<AuthLogic>(
                            id: 'timezone',
                            builder: (logic) {
                              return Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade300)),
                                child: logic.isTimezoneLoading
                                    ? const Center(
                                        child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1,
                                            )),
                                      )
                                    : DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                            isExpanded: true,
                                            hint: CustomText(
                                              logic.selectedTimezone ?? 'Time zone'.tr,
                                              fontSize: 16,
                                              color: logic.selectedTimezone == null
                                                  ? Colors.grey.shade700
                                                  : Colors.black,
                                            ),
                                            //   value: list[0],
                                            items: logic.timezoneList
                                                .map((e) => DropdownMenuItem<String>(
                                                      child: CustomText(e),
                                                      value: e,
                                                    ))
                                                .toList(),
                                            onChanged: (val) =>
                                                logic.onChangeTimezone(val)),
                                      ),
                              );
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Country of origin'.tr,
                          fontSize: 16,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GetBuilder<AuthLogic>(
                            id: 'origin',
                            builder: (logic) {
                              return Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade300)),
                                child: logic.isOriginLoading
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
                                              logic.selectedOrigin?.name ??
                                                  'Country of origin'.tr,
                                              fontSize:
                                                  logic.selectedOrigin == null ? 14 : 16,
                                              color: logic.selectedOrigin == null
                                                  ? Colors.grey.shade700
                                                  : Colors.black,
                                            ),
                                            //   value: list[0],
                                            items: logic.countriesList
                                                .map((e) => DropdownMenuItem<CommonModel>(
                                                      child: CustomText(e.name),
                                                      value: e,
                                                    ))
                                                .toList(),
                                            onChanged: (val) =>
                                                logic.onChangeOrigin(val)),
                                      ),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Language'.tr,
                          fontSize: 16,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GetBuilder<AuthLogic>(
                            id: 'language',
                            builder: (logic) {
                              return Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade300)),
                                child: logic.isLanguageLoading
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
                                              logic.selectedLanguage?.native ??
                                                  'Language'.tr,
                                              fontSize: 16,
                                              color: logic.selectedLanguage == null
                                                  ? Colors.grey.shade700
                                                  : Colors.black,
                                            ),
                                            //   value: list[0],
                                            items: logic.languagesList
                                                .map((e) => DropdownMenuItem<CommonModel>(
                                                      child: CustomText(e.native),
                                                      value: e,
                                                    ))
                                                .toList(),
                                            onChanged: (val) =>
                                                logic.onChangeLanguage2(val)),
                                      ),
                              );
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Level'.tr,
                          fontSize: 16,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GetBuilder<AuthLogic>(
                            id: 'level',
                            builder: (logic) {
                              return Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade300)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: CustomText(
                                        logic.selectedLevel ?? 'Level'.tr,
                                        fontSize: 16,
                                        color: logic.selectedLevel == null
                                            ? Colors.grey.shade700
                                            : Colors.black,
                                      ),
                                      //   value: list[0],
                                      items: logic.levelList
                                          .map((e) => DropdownMenuItem<String>(
                                                child: CustomText(e),
                                                value: e,
                                              ))
                                          .toList(),
                                      onChanged: (val) => logic.onChangeLevel(val)),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomText(
                'Gender'.tr,
                fontSize: 16,
              ),
              GetBuilder<ProfileLogic>(
                  init: Get.find<ProfileLogic>(),
                  id: 'gender',
                  builder: (logic) {
                    return Row(
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 'male',
                              groupValue: logic.genderValue,
                              onChanged: (val) => logic.changeGender(val),
                            ),
                            CustomText('Male'.tr)
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 'female',
                              groupValue: logic.genderValue,
                              onChanged: (val) => logic.changeGender(val),
                            ),
                            CustomText('Female'.tr)
                          ],
                        ), /*
                    Expanded(
                        child: RadioListTile(
                          value: 'other',
                          contentPadding: EdgeInsets.zero,
                          groupValue: logic.genderValue,
                          onChanged: (val) =>logic.changeGender(val),
                            title: CustomText('Other'.tr))),*/
                      ],
                    );
                  })
            ],
          );
        });
  }
}
