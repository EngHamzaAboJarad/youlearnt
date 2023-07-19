import 'package:get/get.dart';
import 'package:you_learnt/features/_blog_commmunity/profile_community/logic.dart';
import 'package:you_learnt/features/_main/calendar/logic.dart';

import 'data/remote/api_requests.dart';
import 'features/_auth/logic.dart';
import 'features/_blog_commmunity/profile_blog/logic.dart';
import 'features/_main/find_tutor/logic.dart';
import 'features/_main/logic.dart';
import 'features/_profile/classrooms/logic.dart';
import 'features/_profile/logic.dart';
import 'features/_profile/view_profile/logic.dart';
import 'features/_profile/withdraw/logic.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiRequests>(() => ApiRequests());

    Get.put<AuthLogic>(AuthLogic(), permanent: true);
    Get.lazyPut<MainLogic>(() => MainLogic());
    Get.put<ViewProfileLogic>(ViewProfileLogic());
    Get.put<ProfileLogic>(ProfileLogic());

    Get.lazyPut<FindTutorLogic>(() => FindTutorLogic());
    Get.lazyPut<WithdrawDepositLogic>(() => WithdrawDepositLogic());
    // Get.put<WithdrawDepositLogic>(WithdrawDepositLogic(), permanent: true);
    Get.put<ProfileBlogLogic>(ProfileBlogLogic(), permanent: true);
    Get.put<ProfileCommunityLogic>(ProfileCommunityLogic(), permanent: true);
    Get.lazyPut<CalendarLogic>(() => CalendarLogic());

    Get.put<ClassroomsLogic>(ClassroomsLogic());
  }
}
