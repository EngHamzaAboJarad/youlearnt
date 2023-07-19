import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/utils/error_handler/error_handler.dart';

import '../../../data/remote/api_requests.dart';
import '../../../utils/functions.dart';

class ContactUsLogic extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

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

  void sendContactUs() async {
    isLoading = true;
    update();
    try {
      var res = await Get.find<ApiRequests>().contactUs(
        //  subjectId: id,
        name: nameController.text,
        body: detailsController.text,
        email: emailController.text,
        // phone:,
      );
      nameController.text = '';
      detailsController.text = '';
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    update();
  }
}
