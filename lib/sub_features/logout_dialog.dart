import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/utils/custom_widget/custom_button_widget.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';

import '../constants/colors.dart';
import '../features/_auth/logic.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20.h),
      child: GetBuilder<AuthLogic>(
          init: Get.find<AuthLogic>(),
          id: 'logout',
          builder: (logic) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomText(
                  'Log Out'.tr,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.h),
                  child: CustomText(
                    'Are you sure to log out from this account?'.tr,
                    fontSize: 15,
                    textAlign: TextAlign.center,
                    color: greyTextColor,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomButtonWidget(
                            title: 'Cancel'.tr,
                            color: Colors.white,
                            textColor: Colors.black,
                            widthBorder: 0.55,
                            textSize: 14,
                            onTap: () => Get.back())),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: CustomButtonWidget(
                            title: 'Log Out'.tr,
                            loading: logic.isLogoutLoading,
                            textSize: 14,
                            onTap: () => logic.logout())),
                  ],
                )
              ],
            );
          }),
    );
  }
}
