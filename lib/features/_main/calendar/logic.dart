import 'dart:developer';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:you_learnt/entities/BookModel.dart';

import '../../../data/remote/api_requests.dart';
import '../../../utils/error_handler/error_handler.dart';

class CalendarLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  bool monthlyIsSelected = false;
  CalendarController calendarController = CalendarController();
  bool isLoading = false;
  List<BookModel> bookList = [];
  List<BookModel> bookListThisMonth = [];

  changeSelected({required bool mLoginIsSelected}) {
    monthlyIsSelected = mLoginIsSelected;
    update();
  }

  Future<void> getStudentBooks({int? month}) async {
    //if(HiveController.getToken() == null) return;
    month ??= DateTime.now().month;
    isLoading = true;
    //  update();
    try {
      var res = await _apiRequests.getStudentBooks(month: month);
      bookList = (res.data['object'] as List)
          .map((e) => BookModel.fromJson(e))
          .toList();
      if (bookList.isNotEmpty) {
        calendarController.selectedDate = DateTime.parse(bookList.first.start!);
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  List<BookModel> getBookByDay(DateTime day) {
    List<BookModel> bookListToday = [];
    for (var element in bookList) {
      if (element.start != null) {
        if (DateTime.parse(element.start!).month == day.month &&
            DateTime.parse(element.start!).year == day.year &&
            DateTime.parse(element.start!).day == day.day) {
          bookListToday.add(element);
        }
      }
    }
    return bookListToday;
  }

  Future<void> getTeacherBooks({int? month}) async {
    //if(HiveController.getToken() == null) return;
    // return ;
    month ??= DateTime.now().month;
    isLoading = true;
    //  update();
    try {
      var res = await _apiRequests.getTimes(month: month);  
      // log(res.data.toString());
      bookList = (res.data['object']['books'] as List)
          .map((e) => BookModel.fromJson(e))
          .toList();
      if (bookList.isNotEmpty) {
        calendarController.selectedDate = DateTime.parse(bookList.first.start!);
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  goToMeet(int? id) async {
    try {
      var res = await _apiRequests.getMeetUrl(id: id);
      log(res.data.toString());
      launchUrl(Uri.parse(res.data), mode: LaunchMode.inAppWebView);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }
}
