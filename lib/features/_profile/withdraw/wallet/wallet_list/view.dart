import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/utils/custom_widget/custom_button_widget.dart';

import '../../../../../constants/colors.dart';
import '../../../../../entities/wallet_account_model.dart';
import '../../../../../utils/custom_widget/custom_text.dart';
import '../../../../../utils/custom_widget/custom_text_field.dart';
import '../../../../../utils/validation/validation.dart';
import '../../logic.dart';

class TeacherWalletsList extends StatefulWidget {
  const TeacherWalletsList({Key? key}) : super(key: key);

  @override
  State<TeacherWalletsList> createState() => _TeacherWalletsListState();
}

class _TeacherWalletsListState extends State<TeacherWalletsList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // Get.find<WithdrawDepositLogic>().getTeacherWallets();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
      Get.find<WithdrawDepositLogic>().getTeacherWallets();
    });
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
                title: Center(
                  child: CustomText(
                    'Withdraw'.tr,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: GetBuilder<WithdrawDepositLogic>(
                  id: "withdraw_request",
                  builder: (logic) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: const Text(""),
                              ),
                              CustomText(
                                'Choose account'.tr,
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
                                        child: DropdownButton<
                                                WalletAccountModel>(
                                            isExpanded: true,
                                            hint: CustomText(
                                                logic.selectedAccountToPay !=
                                                        null
                                                    ? logic
                                                        .selectedAccountToPay!
                                                        .accountNumber
                                                        .toString()
                                                    : "",
                                                fontSize: 16,
                                                color: Colors.black),
                                            // value: list[0],c
                                            items: logic.walletAccountsList
                                                .map((e) => DropdownMenuItem<
                                                        WalletAccountModel>(
                                                      child: CustomText(
                                                          e.accountNumber),
                                                      value: e,
                                                    ))
                                                .toList(),
                                            onChanged: (val) =>
                                                logic.onSelectAccountToWithdrae(
                                                    val!)),
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
                                              .addWithdrawRequest()
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
                  return logic.isLoading
                      ? const SizedBox(
                          child: Center(
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ))))
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 10,
                                ),
                                itemCount: logic.walletAccountsList.length,
                                itemBuilder: (context, index) => Container(
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: ListTile(
                                    // tileColor: Colors.amber,
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   side: const BorderSide(color: Colors.black),
                                    // ),
                                    title: CustomText(
                                      logic.walletAccountsList[index]
                                              .accountHodler ??
                                          "",
                                      color: Colors.white,
                                    ),
                                    subtitle: CustomText(
                                      logic.walletAccountsList[index]
                                          .accountNumber,
                                      color: Colors.white,
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              logic.deleteWalletAccount(logic
                                                  .walletAccountsList[index]
                                                  .id),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        InkWell(
                                          onTap: () => logic.editAccountWallet(
                                              logic.walletAccountsList[index]),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 30.h),
                                    child: CustomButtonWidget(
                                      title: 'Add'.tr,
                                      onTap: () => logic.goToAddWallet(),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 30.h),
                                    child: CustomButtonWidget(
                                      title: 'Withdraw'.tr,
                                      color: secondaryColor,
                                      onTap: () =>
                                          showConfirmDilog(context: context),
                                    ),
                                  ),
                                ),
                              ],
                            )
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
