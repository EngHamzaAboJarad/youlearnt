import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/_main/logic.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';

import '../../../constants/colors.dart';
import '../../_main/widgets/header_widget.dart';
import 'logic.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatelessWidget {
  final logic = Get.put(NotificationsLogic());

  NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColor,
      child: Column(
        children: [
          HeaderWidget(
            titleBig: 'Notifications'.tr,
            titleSmall: ''.tr,
            showSearch: false,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25), topLeft: Radius.circular(25))),
              child: GetBuilder<MainLogic>(
                  init: Get.find<MainLogic>(),
                  builder: (logic) {
                    return RefreshIndicator(
                      onRefresh: () => logic.getNotification(),
                      child: logic.isNotificationLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: ListView.builder(
                                  itemCount: logic.notificationList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),

                                  itemBuilder: (context, index1) => Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            logic.notificationList[index1].createdAt,
                                            color: Colors.grey.shade700,
                                          ),
                                          ListView.builder(
                                              itemCount: logic
                                                  .notificationList[index1].notifications.length,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) => Padding(
                                                    padding: EdgeInsets.only(top: 10.h),
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(40.sp),
                                                          child: Container(
                                                            width: 40.sp,
                                                            height: 40.sp,
                                                            color: Colors.grey.shade300,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                            children: [
                                                              CustomText(
                                                                logic.notificationList[index1]
                                                                    .notifications[index].title,
                                                                color: Colors.grey.shade800,
                                                              ),
                                                              CustomText(
                                                                timeago.format(DateTime
                                                                    .fromMillisecondsSinceEpoch(
                                                                        int.parse(logic
                                                                            .notificationList[
                                                                                index1]
                                                                            .notifications[index]
                                                                            .createdAt!))),
                                                                fontSize: 12,
                                                                color: Colors.grey.shade600,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                          const SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      ))),
                            ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
