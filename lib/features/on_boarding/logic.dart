import 'package:get/get.dart';

import '../_auth/auth/view.dart';

class OnBoardingLogic extends GetxController {

  goToAuth(){
    Get.off(AuthPage());
  }
}
