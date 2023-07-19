import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:you_learnt/constants/env.dart';
import 'package:you_learnt/entities/CommonModel.dart';
import 'package:you_learnt/entities/UserModel.dart';
import 'package:you_learnt/features/_main/calendar/logic.dart';
import 'package:you_learnt/utils/functions.dart';

import '../../../data/remote/api_requests.dart';
import '../../../entities/RatingModel.dart';
import '../../../entities/SubjectModel.dart';
import '../../../entities/TeacherModel.dart';
import '../../../sub_features/book_session_dialog.dart';
import '../../../sub_features/buy_package_option.dart';
import '../../../sub_features/charge_wallet_option.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/error_handler/error_handler.dart';
import '../../_auth/logic.dart';
import '../../_main/logic.dart';
import '../../payment/view.dart';
import '../logic.dart';

class ViewProfileLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final AuthLogic authLogic = Get.find();
  final ProfileLogic profileLogic = Get.put(ProfileLogic());
  // final ProfileLogic profileLogic = Get.find();
  bool showCertificates = true;
  bool showEducation = true;
  bool isLoading = true;
  bool isTimesLoading = false;
  bool isOrderLoading = false;
  bool bookedBefore = false;
  TeacherModel? teacherModel;
  RatingModel? ratingModel;
  SubjectModel? selectedSubject;
  CommonModel? selectedTime;
  CommonModel? selectedPlan;
  late int selectedMonth;
  int selectedDay = 0;
  int selectedState = 1;
  List<CommonModel> timesList = [];
  List<CommonModel> packagesList = [];
  ScrollController scrollController = ScrollController();
  List months = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec'
  ];

  @override
  onInit() {
    selectedMonth = DateTime.now().month - 1;
    selectedDay = DateTime.now().day;
    super.onInit();
  }

  toggleCertificates() {
    showCertificates = !showCertificates;
    update();
  }

  toggleEducation() {
    showEducation = !showEducation;
    update();
  }

  goToBook() {
    if (teacherModel == null) return;
    getTimes();
    checkIfOrderBefore();
    Get.bottomSheet(BookSessionDialog(teacherModel!), isScrollControlled: true);
  }

  changePlanSelected(int index) {
    for (var element in packagesList) {
      element.isSelected = false;
    }
    selectedPlan = packagesList[index];
    selectedPlan?.isSelected = true;
    update();
  }

  onChangeSubject(SubjectModel? val) {
    selectedSubject = val;
    update();
  }

  changeSelectedMonth(int index) {
    selectedMonth = index;
    update();
  }

  changeSelectedDay(int index) {
    selectedDay = index;
    update();
  }

  changeSelectedTime(CommonModel item) {
    selectedTime = item;
    for (var element in timesList) {
      element.isSelected = false;
    }
    item.isSelected = true;
    update();
  }

  String? getTimeFormat(CommonModel timeByDay) {
    try {
      DateTime start = DateTime.parse(timeByDay.start!);
      DateTime end = DateTime.parse(timeByDay.end!);
      return '${DateFormat().add_Hm().format(start)} - ${DateFormat().add_Hm().format(end)}';
    } catch (e) {}
    return null;
  }

  List<CommonModel> getTimeByDay() {
    List<CommonModel> list = [];
    DateTime day =
        DateTime(DateTime.now().year, selectedMonth + 1, selectedDay + 1);
    for (var element in timesList) {
      try {
        DateTime start = DateTime.parse(element.start!);
        if (start.year == day.year &&
            start.month == day.month &&
            start.day == day.day) {
          list.add(element);
        }
      } catch (e) {}
    }
    return list;
  }

  Future<void> getProfileBySlug(String? slug,
      {bool withoutLoading = false}) async {
    // if (teacherModel != null) return;
    if (!withoutLoading) isLoading = true;
    if (!withoutLoading) update();
    try {
      var res = await _apiRequests.getTeacherBySlug(slug);

      ///log(json.encode(res.data));
      teacherModel = TeacherModel.fromJson(res.data['object']);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    try {
      var res = await _apiRequests.getRatingTeacherBySlug(slug);
      ratingModel = RatingModel.fromJson(res.data['object']);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  Future<void> getTimes() async {
    isTimesLoading = true;
    update();
    try {
      var res = await _apiRequests.getTimesBySlug(teacherModel?.user?.slug);
      // log(json.encode(res.data));
      timesList = (res.data['object'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isTimesLoading = false;
    update();
    await Future.delayed(const Duration(seconds: 1));
    if (selectedDay > 5) {
      scrollController.animateTo(selectedDay * 55,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    }
  }

  Future<void> checkIfOrderBefore() async {
    isTimesLoading = true;
    update();
    try {
      var res =
          await _apiRequests.checkIfOrderBefore(slug: teacherModel?.user?.slug);
      // bookedBefore = true;
    } catch (e) {
      if (e is DioError) {
        bookedBefore = e.response.toString().contains('YOU_SHOULD_BUY_PACKAGE');
      } else {
        ErrorHandler.handleError(e);
      }
    }

    try {
      onChangeSubject(teacherModel?.subjects?.first);
      if (bookedBefore) getPackages();
    } catch (e) {}
    isTimesLoading = false;
    update();
  }

  // Future<void> getPackages() async {
  //   isTimesLoading = true;
  //   update();
  //   try {
  //     var res = await _apiRequests.getPackages(
  //         slug: teacherModel?.user?.slug,
  //         teacherSubjectId: selectedSubject?.id);
  //     packagesList = (res.data['object'] as List)
  //         .map((e) => CommonModel.fromJson(e))
  //         .toList();
  //   } catch (e) {
  //     ErrorHandler.handleError(e);
  //   }
  //   isTimesLoading = false;
  //   update();
  // }

  Future<void> createOrder() async {
    isOrderLoading = true;
    update();
    try {
      var res = await _apiRequests.createOrder(
          slug: teacherModel?.user?.slug,
          bookId: selectedTime?.id,
          hour: selectedPlan?.hour,
          teacherSubjectId: selectedSubject?.id);

      Get.to(PaymentScreen(
          comeFrom: ComeFrom.defaul,
          url: '${baseUrl}orders/${res.data['object']['id']}/payments/create'));

      Get.find<CalendarLogic>().getStudentBooks();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isOrderLoading = false;
    update();
  }

  Future<void> handleStudentBookSeestions(
      {required BuildContext context}) async {
    isOrderLoading = true;
    update();

    try {
      if (selectedTime == null) {
        log("time is empty");
        isOrderLoading = false;
        update();
        showMessage("Select Book time!".tr, 2);
        return;
      }

      // log("id  : " + profileLogic.userModel!.id.toString());
      // await handleChargeWallet(context: context);
      // log(selectedSubject?.id.toString());

      //check if the student has a free lessons or not first
      // String? tt = teacherModel?.user?.slug.toString();
      // String? ss = selectedSubject?.id.toString();
      // log("id  : " + tt.toString());
      // log("id  : " + ss.toString());
      var res = await _apiRequests.checkHasfreeLessons(
          teacherSlug: teacherModel?.user?.slug,
          teacherSubjectId: selectedSubject?.id);

      // then we check localy if he has enough money in wallet or not  before sending to book the sessions and if he dosen't have will convert him to pay page
      if (res.data["status"]) {
        // the user has free lesson now will check his mount
        await Get.find<MainLogic>().getProfile();
        UserModel? updatedUserData = Get.find<MainLogic>().userModel;
        if (updatedUserData != null) {
          int subjuctHourlyrate = selectedSubject!.hourlyRate ?? 0;
          double userWallet = updatedUserData.wallet ?? 0;

          if (userWallet > subjuctHourlyrate) {
            log("have enough credit");
            await experimentalBookLesson();
          } else {
            // log("dose not have enough credit"); and we will convert him to pay from paypal or stripe
            // log("dose not have enough credit");
            await handleChargeWallet(
                context: context, comeFrom: ComeFrom.bookSessionDilog);
            // to get wallet
            await Get.find<MainLogic>().getProfile();
            UserModel? updatedUserData = Get.find<MainLogic>().userModel;
            // the charge wasn't enough charge more
            // log("wallet now : " + updatedUserData!.wallet!.toString());
            if (updatedUserData!.wallet! < subjuctHourlyrate) {
              showMessage("The charged amount was not enough".tr, 2);
              isOrderLoading = false;
              update();
              return;
            }
            await experimentalBookLesson();
          }
        }
      } else {
        // will buy packges
      }
    } catch (e) {
      // to buy packges
      ErrorHandler.handleError(e);
      if (e is DioError) {
        if (e.response?.statusCode == 400 &&
            e.response!.data["message"] == "YOU_SHOULD_BUY_PACKAGE") {
          // log((e.response?.statusCode ?? 0).toString());
          // log(e.response.toString());
          handleBuyPackegs(context: context);
        }
      }
      // log(e.toString());

      // if(e)
    }
    isOrderLoading = false;
    update();
  }

  // book free lesson for subject

  Future<void> experimentalBookLesson() async {
    try {
      var res = await _apiRequests.createExperimnetalBook(
        teachersubjectID: selectedSubject?.id.toString(),
        bookId: selectedTime!.id,
      );
      log(res.data.toString());
      await Get.find<CalendarLogic>().getStudentBooks();
      await Get.find<MainLogic>().getProfile();
      Get.back();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  Future<void> handleChargeWallet(
      {required BuildContext context, required ComeFrom comeFrom}) async {
    await showDialog(
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
                    "Charge wallet",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: ChargeWallteOptions(
                  comeFrom: comeFrom,
                ),
              ),
            ));
  }

  Future<void> handleBuyPackegs({required BuildContext context}) async {
    await getPackages();
    await showDialog(
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
                    "Packages",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: BuyPackageOptions(),
              ),
            ));
  }

  checkifTheUserHasEnoughCreditToBookPackage(
      {required int selectedPackageIndex}) async {
    await Get.find<MainLogic>().getProfile();
    UserModel? updatedUserData = Get.find<MainLogic>().userModel;
    if (packagesList.isEmpty) {
      return true;
    }
    // the charge wasn't enough charge more
    // log("wallet now : " + updatedUserData!.wallet!.toString());

    // log(packagesList[selectedPackageIndex].price.toString());
    // log(packagesList[selectedPackageIndex].name.toString());
    // log(updatedUserData!.wallet!.toString());
    if (updatedUserData!.wallet! < packagesList[selectedPackageIndex].price!) {
      return false;
    } else {
      return true;
    }
  }

// if he has packages (enough credites we will not but we will book dierctly)
  Future<void> bookReservation({required CommonModel selectedPackage}) async {
    try {
      log(selectedPackage.name.toString());
      log(selectedPackage.hour.toString());
      var res = await _apiRequests.reservationBookIFPackagesExists(
          teachersubjectID: selectedSubject?.id.toString(),
          bookId: selectedTime!.id,
          hour: selectedPackage.hour);
      log(res.data.toString());
      await Get.find<CalendarLogic>().getStudentBooks();
      await Get.find<MainLogic>().getProfile();
      Get.back();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  bool checkDayTimes(int index) {
    DateTime day = DateTime(DateTime.now().year, selectedMonth + 1, index + 1);
    for (var element in timesList) {
      DateTime start = DateTime.parse(element.start!);
      if (start.year == day.year &&
          start.month == day.month &&
          start.day == day.day) {
        return true;
      }
    }
    return false;
  }

  changeState({required int type}) {
    selectedState = type;
    update(['tabs']);
  }

  Future<void> getPackages() async {
    // isTimesLoading = true;
    update();
    try {
      var res = await _apiRequests.getPackages(
          slug: teacherModel?.user?.slug,
          teacherSubjectId: selectedSubject?.id);
      packagesList = (res.data['object'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    // isTimesLoading = false;
    update();
  }
}
