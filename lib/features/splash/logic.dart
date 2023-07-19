import 'dart:async';
import 'package:get/get.dart';
import 'package:you_learnt/data/hive/hive_controller.dart';
import 'package:you_learnt/features/_main/view.dart';
import '../_main/calendar/logic.dart';
import '../_main/logic.dart';
import '../on_boarding/view.dart';

class SplashLogic extends GetxController {
  final MainLogic _mainLogic = Get.find();
  final CalendarLogic _calendarLogic = Get.find();

  @override
  void onInit() async {
    super.onInit();

    if (HiveController.getToken() != null) {
      _mainLogic.getProfile(); 
      if (HiveController.getIsStudent()) {
        _calendarLogic.getStudentBooks();
      } else {
        _calendarLogic.getTeacherBooks();
      }
    }
    Future.delayed(const Duration(seconds: 2)).then(
        (value) => Get.off(HiveController.getToken() != null ? MainPage() : OnBoardingPage()));
  }
}
