import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/entities/CommonModel.dart';
import 'package:you_learnt/features/_auth/logic.dart';
import 'package:you_learnt/features/_main/logic.dart';

import '../../../data/hive/hive_controller.dart';
import '../../../data/remote/api_requests.dart';
import '../../../entities/TutorModel.dart';
import '../../../utils/error_handler/error_handler.dart';

class FindTutorLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final AuthLogic authLogic = Get.find();

  bool isLoading = false;
  bool isUnderLoading = false;
  bool isFavLoading = false;
  List<TutorModel> tutorList = [];
  List<TutorModel> favoriteList = [];
  int mPage = 1;
  String? next;
  CommonModel? selectedSubject;
  CommonModel? selectedCountry;
  CommonModel? selectedLanguage;
  String? selectedTimezone;
  CommonModel? selectedSpeak;
  ScrollController scrollController = ScrollController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  String? startedTime;
  String? endTime;
  Timer? timerFrom;
  Timer? timerTo;
  String? ordering;
  String? orderingSelected = 'Default';
  String? soringDirection;

  @override
  onInit() {
    getTutors();
    scrollController.addListener(_reviewsScrollListener);
    /*  fromController.addListener(() {
      timerFrom?.cancel();
      timerFrom = Timer(const Duration(seconds: 1), () {
        getTutors();
      });
    });
    toController.addListener(() {
      timerTo?.cancel();
      timerTo = Timer(const Duration(seconds: 1), () {
        getTutors();
      });
    });*/
    super.onInit();
  }

  void _reviewsScrollListener() async {
    try {
      var scrollable = Platform.isAndroid
          ? !scrollController.position.outOfRange
          : scrollController.position.outOfRange;

      if (scrollController.offset >= scrollController.position.maxScrollExtent &&
          scrollable &&
          isLoading == false) {
        if (next != null) {
          getTutors(page: ++mPage, forPagination: true);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getTutors(
      {bool withoutLoading = false, int page = 1, bool forPagination = false}) async {
    if (selectedSubject == null) return;
    if (!withoutLoading && !forPagination) isLoading = true;
    if (forPagination && tutorList.isNotEmpty) isUnderLoading = true;
    if (!withoutLoading) update();
    try {
      var lastName = Get.find<MainLogic>().searchController.text;
      var res = await _apiRequests.getTutors(
          page: page,
          name: lastName.isNotEmpty ? lastName : null,
          subjectId: selectedSubject?.id,
          languageId: selectedLanguage?.id,
          countryId: selectedCountry?.id,
          speakId: selectedSpeak?.id,
          startPrice: fromController.text,
          endPrice: toController.text,
          startedTime: startedTime,
          endTime: endTime,
          timezone: selectedTimezone,
          ordering: ordering,
          soringDirection: soringDirection);
      // log(res.data.toString());
      next = res.data['object']['next_page_url'];
      if (forPagination) {
        var newPageList = (res.data['object']['data'] as List)
            .map((e) => TutorModel.fromJson(e))
            .toList();
        tutorList.addAll(newPageList);
      } else {
        tutorList = (res.data['object']['data'] as List)
            .map((e) => TutorModel.fromJson(e))
            .toList();
      }
    } catch (e,s) {
      ErrorHandler.handleError(e, s: s);
    }
    isLoading = false;
    isUnderLoading = false;
    update();
  }

  Future<void> getFavoriteItems({bool withoutLoading = false}) async {
    if (!withoutLoading) isLoading = true;
    if (!withoutLoading) update();
    try {
      var res = await _apiRequests.getFavoriteItems();
      favoriteList = (res.data['object']['data'] as List)
          .map((e) => TutorModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  Future<void> addToFavorite(
      {String? slug, bool isForFav = false, bool isForProfile = false}) async {
    isFavLoading = true;
    update([slug ?? '']);
    try {
      var res = await _apiRequests.addToFavorite(slug: slug);
      if (isForFav) {
        await getFavoriteItems(withoutLoading: true);
      } else {
        if (!isForProfile) await getTutors(withoutLoading: true);
        if (!isForProfile) {
          await getTutors(withoutLoading: true);
        }
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isFavLoading = false;
    update([slug ?? '']);
  }

  onChangeSubject(CommonModel? val) {
    selectedSubject = val;
    update();
  }

  onChangeCountry(CommonModel? val) {
    selectedCountry = val;
    Get.find<AuthLogic>().getTimezone(countryId: val?.id);
    update();
  }

  onChangeLanguage(CommonModel? val) {
    selectedLanguage = val;
    update();
  }

  onChangeSpeak(CommonModel? val) {
    selectedSpeak = val;
    update();
  }

  onChangeTimezone(String? val) {
    selectedTimezone = val;
    update();
  }

  onChangeStartedTime(TimeOfDay? value) {
    if (value != null) {
      startedTime = '${formatNumber(value.hour)}:${formatNumber(value.minute)}';
      update();
    }
  }

  onChangeEndTime(TimeOfDay? value) {
    if (value != null) {
      endTime = '${formatNumber(value.hour)}:${formatNumber(value.minute)}';
      update();
    }
  }

  var orderingList = ['Default', 'Best rating', 'Most rating', 'Recent'];

  onChangeOrdering(String? val) {
    if (val == orderingList[0]) {
      orderingSelected = 'Default';
      ordering = null;
      soringDirection = null;
    } else if (val == orderingList[1]) {
      orderingSelected = orderingList[1];
      ordering = 'rating';
      soringDirection = 'asc';
    } else if (val == orderingList[2]) {
      orderingSelected = orderingList[2];
      ordering = 'reviews';
      soringDirection = 'desc';
    } else if (val == orderingList[3]) {
      orderingSelected = orderingList[3];
      ordering = 'created_at';
      soringDirection = 'desc';
    }

    update();
  }

  String formatNumber(int num) {
    if ('$num'.length == 1) {
      return '0$num';
    }
    return num.toString();
  }

  restFilters() {
    selectedSubject = null;
    selectedLanguage = null;
    selectedSpeak = null;
    selectedCountry = null;
    fromController.text = '';
    toController.text = '';
    startedTime = null;
    endTime = null;
    selectedTimezone = null;
    orderingSelected = 'Default';
    ordering = null;
    soringDirection = null;
    update();
  }
}
