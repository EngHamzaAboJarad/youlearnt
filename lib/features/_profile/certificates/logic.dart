import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/remote/api_requests.dart';
import '../../../entities/CertificationModel.dart';
import '../../../entities/CommonModel.dart';
import '../../../utils/error_handler/error_handler.dart';
import '../../../utils/functions.dart';
import '../../_auth/logic.dart';

class CertificatesLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final AuthLogic authLogic = Get.find();

  bool isLoading = false;
  bool isAddLoading = false;
  List<CertificationModel> certificationsList = [];
  List<CertificationModel> newCertificationsList = [CertificationModel()];

  List<String> backgroundHelperList = [];

  toggleMenu(cer) {
    certificationsList[certificationsList.indexOf(cer)].openMenu =
        !certificationsList[certificationsList.indexOf(cer)].openMenu;
    update();
  }

  onChangeSubject(CommonModel? val, int index) {
    newCertificationsList[index].selectedSubject = val;
    newCertificationsList[index].id = val?.id;
    update();
  }

  addImage(int index) async {
    try {
      XFile? image;
      final ImagePicker _picker = ImagePicker();
      image = await _picker.pickImage(source: ImageSource.gallery);
      newCertificationsList[index].certificationImage = image!.path;
      update();
    } catch (e) {
      log('image error => ${e.toString()}');
    }
  }

  getSubjectName(int? id) {
    String? name = '';
    for (var element in authLogic.subjectsList) {
      if (element.id == id) name = element.name;
    }
    return name;
  }

  void addCertification() async {
    isAddLoading = true;
    update();
    try {
      var res = await _apiRequests.addCertification(
          certificationsList: newCertificationsList);
      Get.back();
      showMessage(res.data['message'].toString(), 1);
      await getCertifications();
      newCertificationsList = [CertificationModel()];
      backgroundHelperList.clear();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isAddLoading = false;
    update();
  }

  Future<void> getCertifications() async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.getCertifications();
      log(res.data.toString());
      certificationsList = (res.data['object']['data'] as List)
          .map((e) => CertificationModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  Future<void> getBackgroundHelperCertifications(
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

  pickDate(context, int index) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 10000)),
            lastDate: DateTime.now())
        .then((value) {
      if (value != null) {
        newCertificationsList[index].issuedDate =
            value.toString().substring(0, 10);
        update();
      }
    });
  }

  deleteCertification(int? id) async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.deleteCertifications(id);
      await getCertifications();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  addNewCertification() {
    newCertificationsList.add(CertificationModel());
    update();
  }

  removeCertification(int index) {
    newCertificationsList.removeAt(index);
    update();
  }

  removeImage(int index) {
    newCertificationsList[index].certificationImage = null;
    update();
  }
}
