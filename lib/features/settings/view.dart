import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/utils/custom_widget/custom_button_widget.dart';

import '../../../constants/colors.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'logic.dart';

class SettingsPage extends StatelessWidget {
  final logic = Get.put(SettingsLogic());

   SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
      body: GetBuilder<SettingsLogic>(
          init: Get.find<SettingsLogic>(),
          builder: (logic) {
            return Container(
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
                          'Settings'.tr,
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
                              topRight: Radius.circular(25), topLeft: Radius.circular(25))),
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
                                  InkWell(
                                    onTap: () => logic.goToLanguages(),
                                    child: Row(
                                      children: [
                                        Expanded(child: CustomText('Language'.tr)),
                                        CustomText(
                                          logic.getLanguageName(),
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(child: CustomText('Allow Notification'.tr)),
                                      Switch(
                                        value: logic.notificationSend,
                                        onChanged: (val) => logic.changeSend(val),
                                        activeColor: greenColor,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: CustomText('Allow  the Notification Rings'.tr)),
                                      Switch(
                                        value: logic.notificationSound,
                                        onChanged: (val) => logic.changeSound(val),
                                        activeColor: greenColor,
                                      )
                                    ],
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
                                  onTap: () => Get.back(),
                                )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: CustomButtonWidget(
                                  title: 'Save'.tr,
                                  loading: logic.isLoading,
                                  onTap: () => logic.updateSettings(),
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
    );
  }
}
