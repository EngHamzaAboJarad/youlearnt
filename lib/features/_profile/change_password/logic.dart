import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/remote/api_requests.dart';
import '../../../utils/error_handler/error_handler.dart';
import '../../../utils/functions.dart';
import '../../_main/logic.dart';

class ChangePasswordLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final MainLogic mainLogic = Get.find();

  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController reNewPasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> changePassword() async {
    if(newPasswordController.text != reNewPasswordController.text){
      return showMessage("Re-enter password doesn't match".tr, 2);
    }
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.changePassword(
        currentPassword: currentPasswordController.text,
        password: newPasswordController.text,
        passwordConfirmation: reNewPasswordController.text,
      );
      Get.back();
      showMessage(res.data['message'].toString(), 1);
      currentPasswordController.text = '';
      newPasswordController.text = '';
      reNewPasswordController.text = '';
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

}
