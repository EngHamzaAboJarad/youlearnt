import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:you_learnt/data/remote/api_requests.dart';

import '../../utils/error_handler/error_handler.dart';
import '../../utils/functions.dart';

class ReportLogic extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  List<String> imagesList = [];
  String? selectedReason;
  bool isLoading = false;

  List<String> reasonList = [
    'Enquiry',
    'Suggestion',
    'Feedback',
    'Complaint',
    'Report a problem',
    'Other'
  ];

  onReasonSelected(String? val) {
    selectedReason = val;
    update();
  }

  void report(id) async {
    isLoading = true;
    update();
    try {
      var res = await Get.find<ApiRequests>().report(
          reportedId: id,
          title: titleController.text,
          description: detailsController.text,
          imagesList: imagesList);
      titleController.text = '';
      detailsController.text = '';
      imagesList = [];
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    update();
  }

  addImage(int? index) async {
    try {
      XFile? image;
      final ImagePicker _picker = ImagePicker();
      image = await _picker.pickImage(source: ImageSource.gallery);
      if (index == null) {
        imagesList.add(image!.path);
      } else {
        imagesList[index] = image!.path;
      }
      update();
    } catch (e) {
      log('image error => ${e.toString()}');
    }
  }
}
