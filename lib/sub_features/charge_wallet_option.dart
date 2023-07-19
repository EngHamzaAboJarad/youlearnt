import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/payment/view.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';

import '../constants/colors.dart';
import '../features/_profile/withdraw/logic.dart';
import '../utils/custom_widget/custom_button_widget.dart';
import '../utils/custom_widget/custom_text_field.dart';
import '../utils/validation/validation.dart';

class ChargeWallteOptions extends StatelessWidget {
  ChargeWallteOptions({Key? key, required this.comeFrom}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ComeFrom comeFrom;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawDepositLogic>(
      id: "charge-wallet",
      builder: (logic) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: const Text(""),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomText(
                "Select Charge method".tr,
                fontSize: 16,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // color: greyTextBoldColor
                    border: Border.all(color: greyTextBoldColor)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomButtonWidget(
                        title: 'Stripe'.tr,
                        color: logic.selectedChargeMethodIndex == 0
                            ? mainColor
                            : Colors.white,
                        textColor: logic.selectedChargeMethodIndex == 0
                            ? Colors.white
                            : Colors.black,
                        onTap: () {
                          logic.onChangeSelectedChargeMethod(0);
                          // Get.back();
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomButtonWidget(
                        title: 'Paypal'.tr,
                        textColor: logic.selectedChargeMethodIndex == 1
                            ? Colors.white
                            : Colors.black,
                        color: logic.selectedChargeMethodIndex == 1
                            ? secondaryColor
                            : Colors.white,
                        onTap: () {
                          logic.onChangeSelectedChargeMethod(1);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (logic.selectedChargeMethodIndex == 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Amount'.tr,
                      fontSize: 16,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextField(
                      hintText: '0.0',
                      controller: logic.chargeAmountController,
                      validator: Validation.fieldValidate,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 10, right: 10, bottom: 30.h),
                      child: CustomButtonWidget(
                        title: 'Cnacel'.tr,
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 30.h),
                        child: CustomButtonWidget(
                          title: "Charge".tr,
                          color: secondaryColor,
                          loading: logic.isLoading,
                          onTap: () async {
                            if (_formKey.currentState?.validate() == true) {
                              logic.chargeStudent(comeFrom: comeFrom);
                              // logic
                              //     .addWithdrawPayplayRequest()
                              //     .then((value) {});
                            }
                          },
                        )),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
