import 'package:get/get.dart';
import 'package:you_learnt/data/hive/hive_controller.dart';
import 'package:you_learnt/data/remote/api_requests.dart';
import 'package:you_learnt/features/_auth/choose_languages/view.dart';
import 'package:you_learnt/features/_auth/logic.dart';
import 'package:you_learnt/features/_main/logic.dart';
import '../../utils/error_handler/error_handler.dart';
import '../../utils/functions.dart';

class SettingsLogic extends GetxController {
  final AuthLogic authLogic = Get.find(); 
  final MainLogic mainLogic = Get.find();

  bool notificationSound = true;
  bool notificationSend = true;
  bool isLoading = false;

  @override
  onInit() {
    notificationSound = mainLogic.userModel?.notificationSound == 1;
    notificationSend = mainLogic.userModel?.notificationSend == 1;
    super.onInit();
  }

  changeSound(val) {
    notificationSound = val;
    update();
  }

  changeSend(val) {
    notificationSend = val;
    update();
  }

  goToLanguages() {
    Get.to(ChooseLanguagesPage(
      isFromProfile: false,
      isForRecommended: false,
    ))?.then((value) {
      update();
    });
  }

  String? getLanguageName() {
    String? lang;
    for (var element in authLogic.languagesList) {
      if (element.code == HiveController.getLanguageCode()) {
        lang = element.native;
      }
    }
    return lang;
  }

  void updateSettings() async {
    isLoading = true;
    update();
    try {
      var res = await Get.find<ApiRequests>()
          .updateNotificationUser(notificationSound, notificationSend);
      await Get.find<MainLogic>().getProfile();
      Get.back();
      showMessage(res.data['message'], 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }
}
