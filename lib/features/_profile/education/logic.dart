import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/remote/api_requests.dart';
import '../../../entities/EducationModel.dart';
import '../../../utils/error_handler/error_handler.dart';
import '../../../utils/functions.dart';
import '../../_auth/logic.dart';

class EducationLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final AuthLogic authLogic = Get.find();

  bool showOtherTextField = false;
  bool isLoading = false;
  bool isAddLoading = false;
  List<EducationModel> educationsList = [];
  List<EducationModel> newEducationsList = [];

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
    educationsList[educationsList.indexOf(education)].openMenu =
        !educationsList[educationsList.indexOf(education)].openMenu;
    update();
  }

  onChangeType(val, index) {
    showOtherTextField = val == list.last;
    newEducationsList[index].degreeType.text = val;
    if (val == list.last) {
      newEducationsList[index].degreeType.text = '';
    }
    update();
  }

  addImage(index) async {
    try {
      XFile? image;
      final ImagePicker _picker = ImagePicker();
      image = await _picker.pickImage(source: ImageSource.gallery);
      newEducationsList[index].educationImage = image!.path;
      update();
    } catch (e) {
      log('image error => ${e.toString()}');
    }
  }

  void addEducation() async {
    isAddLoading = true;
    update();
    try {
      var res =
          await _apiRequests.addEducation(educationsList: newEducationsList);
      Get.back();
      showMessage(res.data['message'].toString(), 1);
      await getEducation();
      newEducationsList.clear();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isAddLoading = false;
    update();
  }

  Future<void> getBackgroundHelperEducation(
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

  Future<void> getEducation() async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.getEducation();
      educationsList = (res.data['object']['data'] as List)
          .map((e) => EducationModel.fromJson(e))
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
          newEducationsList[index].startAt = value.toString().substring(0, 10);
        } else {
          newEducationsList[index].endAt = value.toString().substring(0, 10);
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
      await getEducation();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  addNewEducation() {
    newEducationsList.add(EducationModel());
    update();
  }

  removeEducation(int index) {
    newEducationsList.removeAt(index);
    update();
  }

  removeImage(int index) {
    newEducationsList[index].educationImage = null;
    update();
  }
}
