import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/_profile/logic.dart';
import 'package:you_learnt/features/payment/view.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/custom_widget/custom_button_widget.dart';
import '../../withdraw/logic.dart';

class BuyPackageStudentTutorRequestOptions extends StatelessWidget {
  BuyPackageStudentTutorRequestOptions({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProfileLogic profileLogic = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawDepositLogic>(
      id: "buy-pakage",
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
                "Select package".tr,
                fontSize: 16,
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                // spacing: 5.0,
                // direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.generate(
                  profileLogic.packagesList.length,
                  (int index) {
                    return InkWell(
                      onTap: () {
                        logic.onChangeSelectedPackageType(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(10),
                        // width: double.infinity,
                        decoration: BoxDecoration(
                          color: logic.selectedPackageTypeIndex == index
                              ? mainColor
                              : Colors.white,
                          border: Border.all(
                            color: logic.selectedPackageTypeIndex == index
                                ? mainColor
                                : greyTextBoldColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              profileLogic.packagesList[index].name.toString(),
                              // +"lsadljassadasdasdsadasdasdasdkldjlsakdjaskljdklasjdlkasdjalsk",
                              color: logic.selectedPackageTypeIndex == index
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    "Hours : ${profileLogic.packagesList[index].hour.toString()}",
                                    // +"lsadljassadasdasdsadasdasdasdkldjlsakdjaskljdklasjdlkasdjalsk",
                                    color:
                                        logic.selectedPackageTypeIndex == index
                                            ? Colors.white
                                            : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Expanded(
                                  child: CustomText(
                                    "Price : ${profileLogic.packagesList[index].price.toString()}",
                                    // +"lsadljassadasdasdsadasdasdasdkldjlsakdjaskljdklasjdlkasdjalsk",
                                    color:
                                        logic.selectedPackageTypeIndex == index
                                            ? Colors.white
                                            : Colors.black,
                                    fontSize: 16,
                                    textAlign: TextAlign.end,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ).toList(),
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
                          title: logic.hasEnoughCredit ? "Book".tr : "Buy".tr,
                          color: secondaryColor,
                          loading: logic.isLoading,
                          onTap: () async {
                            if (_formKey.currentState?.validate() == true) {
                              if (logic.hasEnoughCredit) {
                                profileLogic.bookReservation(
                                    selectedPackage: profileLogic.packagesList[
                                        logic.selectedPackageTypeIndex!]);
                              } else {
                                await profileLogic.handleChargeWallet(
                                    context: context,
                                    comeFrom: ComeFrom.buyPackage);

                                await profileLogic.getPackages();
                                logic.refreshDataAfterBuying();
                              }
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
