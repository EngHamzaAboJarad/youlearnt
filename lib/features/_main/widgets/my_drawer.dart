import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:you_learnt/data/hive/hive_controller.dart';
import 'package:you_learnt/features/_main/contact_us/view.dart';
import 'package:you_learnt/features/_main/faq/view.dart';
import 'package:you_learnt/features/_main/favorites/view.dart';
import 'package:you_learnt/features/_main/find_student/view.dart';
import 'package:you_learnt/features/_main/find_tutor/view.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import 'package:get/get.dart';

import '../../_auth/auth/view.dart';
import '../../_blog_commmunity/community/view.dart';
import '../logic.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 15, bottom: 0, top: 15),
      child: GetBuilder<MainLogic>(
          init: Get.find<MainLogic>(),
          builder: (logic) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (HiveController.getToken() != null)
                    GestureDetector(
                      onTap: () => logic.addImage(),
                      child: Container(
                          width: 55.sp,
                          height: 55.sp,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.sp),
                              color: logic.userModel?.status == 'active' &&
                                      !logic.isProfileLoading
                                  ? greenColor
                                  : primaryColor),
                          padding: const EdgeInsets.all(1.5),
                          child: logic.isProfileLoading
                              ? const SizedBox(
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                        color: secondaryColor,
                                      ),
                                    ),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(30.sp),
                                  child: CustomImage(
                                      fit: BoxFit.cover,
                                      width: 55.sp,
                                      height: 55.sp,
                                      url: logic.userModel?.imageUrl))),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (HiveController.getToken() != null)
                    CustomText(
                      logic.userModel?.fullName,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (HiveController.getToken() != null)
                    Row(
                      children: [
                        Image.asset(
                          iconDegree,
                          scale: 2,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CustomText(
                            logic.userModel?.profile?.level?.capitalizeFirst,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (HiveController.getIsStudent())
                    buildDrawerItem(
                        onTap: () => logic.openDrawerPage(FindTutorPage()),
                        text: 'Find Tutor'.tr,
                        icon: iconExplore),
                  if (!HiveController.getIsStudent())
                    buildDrawerItem(
                        onTap: () => logic.openDrawerPage(FindStudentPage()),
                        text: 'Find Student'.tr,
                        icon: iconEducation),
                  if (HiveController.getIsStudent())
                    buildDrawerItem(
                        onTap: () => logic.openDrawerPage(const FavoritesPage()),
                        text: 'My Favorites'.tr,
                        icon: iconFavourite),
                  buildDrawerItem(
                      onTap: () {
                        logic.searchController.text = '';
                        logic.openDrawerPage(const CommunityPage());
                      },
                      text: 'Community'.tr,
                      icon: iconCommunity),
                  buildDrawerItem(
                      onTap: () => logic.openDrawerPage(FaqPage()),
                      text: "FAQ".tr,
                      icon: iconQuestion),
                  buildDrawerItem(
                      onTap: () => logic.goToSetting(),
                      text: 'Settings'.tr,
                      icon: iconSetting),
                  const SizedBox(
                    height: 30,
                  ),
                  buildDrawerItem(
                      onTap: () {},
                      text: 'Customer Service'.tr,
                      icon: iconCustomerService),
                  buildDrawerItem(
                      onTap: () => Get.to(ContactUsPage()),
                      text: 'Contact us'.tr,
                      icon: 'call'),
                  (HiveController.getToken() != null)
                      ? buildDrawerItem(
                          onTap: () => logic.openLogoutDialog(),
                          text: 'Logout'.tr,
                          icon: iconLogout)
                      : buildDrawerItem(
                          onTap: () => Get.to(AuthPage()),
                          text: 'Log In'.tr,
                          icon: iconLogout),
                ],
              ),
            );
          }),
    );
  }

  InkWell buildDrawerItem(
      {GestureTapCallback? onTap, required String text, required String icon}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            icon == 'call'
                ? Image.asset(
                    iconContact,
                    width: 24,
                    color: Colors.white,
                  )
                : Image.asset(
                    icon,
                    scale: 2,
                  ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: CustomText(
              text,
              fontSize: 16,
              color: Colors.white,
            )),
          ],
        ),
      ),
    );
  }
}
