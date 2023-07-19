import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:you_learnt/constants/colors.dart';
import 'package:you_learnt/features/_main/widgets/my_bottom_nav.dart';
import 'package:you_learnt/features/_main/widgets/my_drawer.dart';

import '../../data/hive/hive_controller.dart';
import 'logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainPage extends StatelessWidget {
  final logic = Get.put(MainLogic());

  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        toolbarHeight: 40.h,
        automaticallyImplyLeading: false,
      ),
      //   drawer: const MyDrawer(),
      bottomNavigationBar: const MyBottomNavigation(),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: GetBuilder<MainLogic>(builder: (logic) {
          return ZoomDrawer(
            controller: logic.zoomDrawerController,
            menuScreen: const MyDrawer(),
            mainScreen: logic.currentScreen,
            borderRadius: 24.0,
            showShadow: true,
            isRtl: HiveController.getLanguageCode()?.contains('ar') == true,
            angle: 0.0,
            drawerShadowsBackgroundColor: Colors.grey.shade300,
            slideWidth: MediaQuery.of(context).size.width * 0.65,
          );
        }),
      ),
    );
  }
}
