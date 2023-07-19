import 'package:you_learnt/constants/colors.dart';

import '../../../constants/images.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../logic.dart';

class MyBottomNavigation extends StatelessWidget {
  const MyBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(builder: (logic) {
      double iconSize = 26.sp;
      return Container(
        color: logic.zoomDrawerController.isOpen?.call() == true
            ? secondaryColor
            : Colors.white,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          backgroundColor: primaryColor,
          unselectedItemColor: Colors.white60,
          selectedItemColor: logic.navigatorValue == null ? Colors.white60 : Colors.white,
          currentIndex: logic.navigatorValue ?? 0,
          selectedLabelStyle: TextStyle(fontSize: 13.sp, overflow: TextOverflow.ellipsis),
          unselectedLabelStyle:
              TextStyle(fontSize: 13.sp, overflow: TextOverflow.ellipsis),
          onTap: (index) => logic.changeSelectedValue(index, true),
          items: [
            BottomNavigationBarItem(
                icon: Image.asset(
                  iconHome,
                  width: iconSize,
                  height: iconSize,
                  color: logic.navigatorValue == 0 ? Colors.white : Colors.white60,
                ),
                label: "Home".tr),
            BottomNavigationBarItem(
                icon: Image.asset(
                  iconCalendar,
                  width: iconSize,
                  height: iconSize,
                  color: logic.navigatorValue == 1 ? Colors.white : Colors.white60,
                ),
                label: "Calendar".tr),
            BottomNavigationBarItem(
                icon: Center(
                  child: Image.asset(
                    iconProfile,
                    width: iconSize,
                    height: iconSize,
                    color: logic.navigatorValue == 2 ? Colors.white : Colors.white60,
                  ),
                ),
                label: "Profile".tr),
            BottomNavigationBarItem(
                icon: Image.asset(
                  iconChat,
                  width: iconSize,
                  height: iconSize,
                  color: logic.navigatorValue == 3 ? Colors.white : Colors.white60,
                ),
                label: "Messages".tr),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Image.asset(
                      iconBlog,
                      width: iconSize,
                      height: iconSize,
                      color: logic.navigatorValue == 4 ? Colors.white : Colors.white60,
                    ),
                  ),
                ),
                label: "Blog".tr),
          ],
        ),
      );
    });
  }
}
