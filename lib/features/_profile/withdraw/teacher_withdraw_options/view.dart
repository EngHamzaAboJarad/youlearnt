import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/custom_widget/custom_button_widget.dart';
import '../../../../utils/custom_widget/custom_text.dart';
import '../../../../utils/custom_widget/custom_text_field.dart';
import '../../../../utils/validation/validation.dart';
import '../../../_blog_commmunity/profile_blog/logic.dart';
import '../logic.dart';

class ProfileTeacherWithdrawOptions extends StatefulWidget {
  const ProfileTeacherWithdrawOptions({Key? key}) : super(key: key);

  @override
  State<ProfileTeacherWithdrawOptions> createState() =>
      _ProfileTeacherWithdrawOptionsState();
}

class _ProfileTeacherWithdrawOptionsState
    extends State<ProfileTeacherWithdrawOptions> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.find<ProfileBlogLogic>().getBlogs();
    super.initState();
  }

  showConfirmDilog({required BuildContext context}) {  
    showDialog(
        context: context,
        builder: (ctx) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AlertDialog(
                scrollable: true,
                contentPadding: const EdgeInsets.all(8),
                insetPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: const Center(
                  child: CustomText(
                    "Withdraw",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: GetBuilder<WithdrawDepositLogic>(
                  id: "withdraw_paypal",
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
                            'Email'.tr,
                            fontSize: 16,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            hintText:  'example@gmail.com'.tr,
                            controller: logic.withdrawPaypalEmailController,
                            validator: Validation.emailValidate,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomText(
                            'Amount'.tr,
                            fontSize: 16,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            hintText: '0.0',
                            controller: logic.withdrawAmountController,
                            validator: Validation.fieldValidate,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 30.h),
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
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 30.h),
                                    child: CustomButtonWidget(
                                      title: "Withdraw".tr,
                                      color: secondaryColor,
                                      loading: logic.isLoading,
                                      onTap: () async {
                                        if (_formKey.currentState?.validate() ==
                                            true) {
                                          logic
                                              .addWithdrawPayplayRequest()
                                              .then((value) {});
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
                ),
              ),
            ));
  }

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
                    'Wallet'.tr,
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
                child: GetBuilder<WithdrawDepositLogic>(builder: (logic) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 30.h),
                        child: CustomButtonWidget(
                            title: 'Wallet'.tr,
                            onTap: () => logic.goToTeacherWalletsList()),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 30.h),
                        child: CustomButtonWidget(
                            title: 'Paypal'.tr,
                            onTap: () => showConfirmDilog(context: context)),
                      ),
                    ],
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
