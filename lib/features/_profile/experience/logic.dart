import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/remote/api_requests.dart';
import '../../../entities/ExperienceModel.dart';
import '../../../utils/error_handler/error_handler.dart';
import '../../../utils/functions.dart';
import '../../_auth/logic.dart';

class ExperienceLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final AuthLogic authLogic = Get.find();

  bool showOtherTextField = false;
  bool isLoading = false;
  bool isAddLoading = false;
  List<ExperienceModel> experienceList = [];
  List<ExperienceModel> newExperienceList = [];

  List<String> backgroundHelperList = [];

  final List<String> list = [
    'Associate',
    'Bachelor',
    'Master',
    'Doctorate',
    'Non-Degree',
    'Diploma',
    'BootCamps',
    'Other'
  ];

  toggleMenu(education) {
    experienceList[experienceList.indexOf(education)].openMenu =
        !experienceList[experienceList.indexOf(education)].openMenu;
    update();
  }

  void addExperience() async {
    isAddLoading = true;
    update();
    try {
      var res =
          await _apiRequests.addExperience(educationsList: newExperienceList);
      Get.back();
      showMessage(res.data['message'].toString(), 1);
      newExperienceList = [ExperienceModel()];
      await getExperience();
      backgroundHelperList.clear();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isAddLoading = false;
    update();
  }

  Future<void> getBackgroundHelperExperince(
      {required String type, required String searchKey}) async {
    // isLoading = true;
    // update();
    try {
      var res = await _apiRequests.geBackgroundHelper(
          type: type, searchKey: searchKey);
      log(res.data.toString());
      backgroundHelperList =
          (res.data['helpers'] as List).map((e) => e.toString()).toList();
    } catch (e) {
      // ErrorHandler.handleError(e);
    }
    // isLoading = false;
    update();
  }

  Future<void> getExperience() async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.getExperience();
      log(res.data.toString());
      experienceList = (res.data['object']['data'] as List)
          .map((e) => ExperienceModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  pickDate(context, bool start, index) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 10000)),
            lastDate: DateTime.now())
        .then((value) {
      if (value != null) {
        if (start) {
          newExperienceList[index].startAt = value.toString().substring(0, 10);
        } else {
          newExperienceList[index].endAt = value.toString().substring(0, 10);
        }
        update();
      }
    });
  }

  deleteEducation(int? id) async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.deleteEducation(id);
      await getExperience();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  addNewEducation() {
    newExperienceList.add(ExperienceModel());
    update();
  }

  removeEducation(int index) {
    newExperienceList.removeAt(index);
    update();
  }
}
