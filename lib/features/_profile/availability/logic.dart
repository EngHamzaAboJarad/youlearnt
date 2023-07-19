import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:you_learnt/features/_main/logic.dart';
import 'package:you_learnt/sub_features/add_availability_dialog.dart';

import '../../../data/remote/api_requests.dart';
import '../../../entities/CommonModel.dart';
import '../../../utils/error_handler/error_handler.dart';
import '../../../utils/functions.dart';

class AvailabilityLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();

  DateTime selectedDate = DateTime.now();
  String? fromTime = 'From'.tr;
  String? toTime = 'To'.tr;
  TimeOfDay? fromTimeOfDay;
  TimeOfDay? toTimeOfDay;

  bool isAddLoading = false;
  bool isLoading = false;
  bool isPrivate = true;

  late int selectedMonth;
  int selectedDay = 0;

  List<CommonModel> timesList = [];

  @override
  onInit() {
    selectedMonth = DateTime.now().month - 1;
    // getTimes();
    super.onInit();
  }

  changeSelectedMonth(int index) {
    selectedMonth = index;
    update();
  }

  changeSelectedDay(int index) {
    selectedDay = index;
    update();
  }

  void openDialog() {
    selectedDate = DateTime(DateTime.now().year, selectedMonth + 1, selectedDay + 1);
    Get.bottomSheet(const AddAvailabilityDialog(), isScrollControlled: true);
  }

  pickDate() {
    showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)))
        .then((value) {
      if (value != null) {
        selectedDate = value;
        update();
      }
    });
  }

  // pickFromTime() {
  //   showCustomTimePicker(
  //     context: Get.context!,
  //     onFailValidation: (context) => log('Unavailable selection'),
  //     selectableTimePredicate: (time) => time == null ? false : time.minute % 15 == 0,
  //     initialTime: fromTimeOfDay ?? const TimeOfDay(hour: 8, minute: 0),
  //   ).then((value) {
  //     if (value != null) {
  //       fromTimeOfDay = value;
  //       fromTime = '${formatNumber(value.hour)}:${formatNumber(value.minute)}';
  //       //  '${formatNumber(value.hourOfPeriod)}:${formatNumber(value.minute)}       ${value.period.index == 0 ? 'AM' : 'PM'}';
  //       if (toTimeOfDay == null) {
  //         toTimeOfDay = TimeOfDay(hour: value.hour + 1, minute: value.minute);
  //         toTime = '${formatNumber(value.hour + 1)}:${formatNumber(value.minute)}';
  //       }
  //       update();
  //     }
  //   });
  // }
  //
  // pickToTime() {
  //   showCustomTimePicker(
  //     context: Get.context!,
  //     onFailValidation: (context) => log('Unavailable selection'),
  //     selectableTimePredicate: (time) => time == null ? false : time.minute % 15 == 0,
  //     initialTime: fromTimeOfDay ?? const TimeOfDay(hour: 9, minute: 0),
  //   ).then((value) {
  //     if (value != null) {
  //       toTimeOfDay = value;
  //       toTime = '${formatNumber(value.hour)}:${formatNumber(value.minute)}';
  //       //   '${formatNumber(value.hourOfPeriod)}:${formatNumber(value.minute)}       ${value.period.index == 0 ? 'AM' : 'PM'}';
  //       update();
  //     }
  //   });
  // }

  String formatNumber(int num) {
    if ('$num'.length == 1) {
      return '0$num';
    }
    return num.toString();
  }

  changeTypeSelected(bool misPrivate) {
    isPrivate = misPrivate;
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
    DateTime day = DateTime(DateTime.now().year, selectedMonth + 1, selectedDay + 1);
    timesList.forEach((element) {
      try {
        DateTime start = DateTime.parse(element.start!);
        if (start.year == day.year && start.month == day.month && start.day == day.day) {
          list.add(element);
        }
      } catch (e) {}
    });
    return list;
  }

  Future<void> getTimes() async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.getTimesBySlug(Get.find<MainLogic>().userModel?.slug);
    //  log(json.encode(res.data));
      timesList =
          (res.data['object'] as List).map((e) => CommonModel.fromJson(e)).toList();
      int? testDay;
      for (var element in timesList) {
        if (element.start?.startsWith(
                '${DateTime.now().year}-${(selectedMonth + 1).toString().padLeft(2, '0')}') ==
            true) {
          if (testDay == null) {
            selectedDay = DateTime.parse(element.start ?? '').day - 1;
            testDay = DateTime.parse(element.start ?? '').day - 1;
          }
        }
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  void addAvailability() async {
    if (fromTimeOfDay == null) {
      Fluttertoast.showToast(msg: 'Add start time first'.tr);
      return;
    }
    if (toTimeOfDay == null) {
      Fluttertoast.showToast(msg: 'Add end time first'.tr);
      return;
    }
    isAddLoading = true;
    update();
    try {
      var res = await _apiRequests.addBook(
          title: selectedDate.toString().substring(0, 10),
          startAt: selectedDate.toString().substring(0, 11) +
              '${formatNumber(fromTimeOfDay!.hour)}:${formatNumber(fromTimeOfDay!.minute)}',
          endAt: selectedDate.toString().substring(0, 11) +
              '${formatNumber(toTimeOfDay!.hour)}:${formatNumber(toTimeOfDay!.minute)}',
          status: 'available',
          type: isPrivate ? 'one' : 'group');
      await getTimes();
      Get.back();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isAddLoading = false;
    update();
  }

  void deleteAvailability(int? id) async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.deleteBook(id: id);
      await getTimes();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      await getTimes();
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  List<String> months = [
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
}
