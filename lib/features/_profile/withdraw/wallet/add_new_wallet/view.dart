import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/utils/validation/validation.dart';

import '../../../../../constants/colors.dart';
import '../../../../../utils/custom_widget/custom_button_widget.dart';
import '../../../../../utils/custom_widget/custom_text.dart';
import '../../../../../utils/custom_widget/custom_text_field.dart';
import '../../logic.dart';

class AddWalletAccountPage extends StatelessWidget {
  final bool edit;
  final logic = Get.find<WithdrawDepositLogic>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddWalletAccountPage({Key? key, required this.edit}) : super(key: key);

  FocusNode focusNode = FocusNode();

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
                    'Add Account'.tr,
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
                child: GetBuilder<WithdrawDepositLogic>(
                    init: Get.find<WithdrawDepositLogic>(),
                    id: 'addWalletAccount',
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    'Account type'.tr,
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
                                            child: DropdownButton<String>(
                                                isExpanded: true,
                                                hint: CustomText(
                                                    logic.selectAccountType,
                                                    fontSize: 16,
                                                    color: Colors.black),
                                                //   value: list[0],
                                                items: logic.accountsTypeList
                                                    .map((e) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                          child: CustomText(e),
                                                          value: e,
                                                        ))
                                                    .toList(),
                                                onChanged: (val) => logic
                                                    .onChangeCategory(val!)),
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
                              CustomText(
                                'Email'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                hintText: 'example@gmail.com'.tr,
                                controller: logic.emailController,
                                validator: logic.selectAccountType == "wise"
                                    ? Validation.noValdation
                                    : Validation.emailValidate,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                'Account number'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                hintText: '',
                                controller: logic.accountNumberController,
                                validator: Validation.fieldValidate,
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                'Account Holder'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                hintText: '',
                                controller: logic.accountHolderController,
                                validator: logic.selectAccountType != "wise"
                                    ? Validation.noValdation
                                    : Validation.fieldValidate,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                'Routing number'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                hintText: '',
                                controller: logic.routongNumberController,
                                validator: logic.selectAccountType != "wise"
                                    ? Validation.noValdation
                                    : Validation.fieldValidate,
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                'Swift bic'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                hintText: '',
                                controller: logic.swiftBicController,
                                validator: logic.selectAccountType != "wise"
                                    ? Validation.noValdation
                                    : Validation.fieldValidate,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              CustomButtonWidget(
                                title: edit ? "Edit".tr : 'Add'.tr,
                                loading: logic.isLoading,
                                onTap: () {
                                  if (_formKey.currentState?.validate() ==
                                      true) {
                                    logic.addWalletAccount(
                                      edit,
                                    );
                                  }
                                },
                              )
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
