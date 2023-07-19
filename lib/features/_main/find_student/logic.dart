
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:you_learnt/data/hive/hive_controller.dart';

import '../../../data/remote/api_requests.dart';
import '../../../entities/PostModel.dart';
import '../../../sub_features/student_request_dialog.dart';
import '../../../utils/error_handler/error_handler.dart';
import '../../../utils/functions.dart';

class FindStudentLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();

  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;
  List<PostModel> postList = [];

  void getStudents() async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.getStudents();
      postList = (res.data['object']['data'] as List).map((e) => PostModel.fromJson(e,{})).toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  void newProposal(int? id) async {
    isLoading = true;
    update([id ?? '0']);
    try {
      var res = await _apiRequests.newProposal(
        id: id,
        price: priceController.text,
        description: descriptionController.text,
      );
      priceController.text = '';
      descriptionController.text = '';
      Get.back();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update([id ?? '0']);
  }

  void openDialog(PostModel postList) {
    if (HiveController.getIsStudent() == true) return;
    Get.bottomSheet(StudentRequestDialog(post: postList), isScrollControlled: true);
  }
}
