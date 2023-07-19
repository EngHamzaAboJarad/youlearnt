import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/data/hive/hive_controller.dart';
import 'package:you_learnt/features/_auth/auth/view.dart';
import 'package:you_learnt/features/_auth/logic.dart';
import 'package:you_learnt/features/_main/find_tutor/logic.dart';
import 'package:you_learnt/features/_main/find_tutor/view.dart';
import 'package:you_learnt/features/_main/widgets/header_widget.dart';
import 'package:you_learnt/features/_main/widgets/schedule_widget.dart';
import 'package:you_learnt/sub_features/item_tutor.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../calendar/logic.dart';
import '../logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(
        init: Get.find<MainLogic>(),
        builder: (logic) {
          return Container(
            color: secondaryColor,
            child: Column(
              children: [
                HeaderWidget(
                    titleBig: logic.userModel?.fullName ?? '',
                    titleSmall: 'Welcome'.tr),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25))),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Get.find<AuthLogic>().getSubjects();
                        if (HiveController.getToken() != null) {
                          if (HiveController.getIsStudent()) {
                            await Get.find<CalendarLogic>().getStudentBooks();
                          } else {
                            await Get.find<CalendarLogic>().getTeacherBooks();
                          }
                          logic.getNotification();
                        }
                        await Get.find<FindTutorLogic>().getTutors();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CustomText(
                                'Subjects'.tr,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            buildSubjects(),
                            if (HiveController.getToken() == null)
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: AspectRatio(
                                    aspectRatio: 2.2,
                                    child:
                                        GetBuilder<MainLogic>(builder: (logic) {
                                      return Stack(
                                        children: [
                                          PageView.builder(
                                              itemCount:
                                                  logic.sliderItems.length,
                                              onPageChanged:
                                                  logic.onPageChanged,
                                              itemBuilder: (context, index) =>
                                                  GestureDetector(
                                                    onTap: () =>
                                                        Get.to(AuthPage()),
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(
                                                          imageSlider,
                                                        ),
                                                        PositionedDirectional(
                                                            start: 10,
                                                            top: 10,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                CustomText(
                                                                  'New\nClass !!'
                                                                      .tr,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                CustomText(
                                                                  'Register now,\ndon\'t miss it'
                                                                      .tr,
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ],
                                                            ))
                                                      ],
                                                    ),
                                                  )),
                                          PositionedDirectional(
                                            start: 10,
                                            bottom: 20,
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children:
                                                    logic.buildPageIndicator(),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            buildSchedule(),
                            if (false)
                              if (HiveController.getIsStudent())
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomText(
                                          'Popular Tutors'.tr,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () => logic
                                              .openDrawerPage(FindTutorPage()),
                                          child: CustomText('see all'.tr,
                                              color: secondaryColor))
                                    ],
                                  ),
                                ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (false)
                              if (HiveController.getIsStudent())
                                GetBuilder<FindTutorLogic>(
                                    init: Get.find<FindTutorLogic>(),
                                    builder: (logic) {
                                      return SizedBox(
                                          height: 265.h,
                                          child: logic.isLoading
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : ListView.builder(
                                                  itemCount:
                                                      logic.tutorList.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (context,
                                                          index) =>
                                                      ItemTutor(
                                                          tutor:
                                                              logic.tutorList[
                                                                  index])));
                                    }),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  GetBuilder<AuthLogic> buildSubjects() {
    return GetBuilder<AuthLogic>(
        init: Get.find<AuthLogic>(),
        id: 'subjects',
        builder: (logic) {
          return logic.isSubjectsLoading
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: 120.h,
                  child: ListView.builder(
                      itemCount: logic.subjectsWithoutAddList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              var findTutorLogic = Get.find<FindTutorLogic>();
                              findTutorLogic.selectedSubject =
                                  logic.subjectsWithoutAddList[index];
                              findTutorLogic.selectedCountry = null;
                              Get.find<MainLogic>()
                                  .openDrawerPage(FindTutorPage());
                            },
                            child: Container(
                              height: 90.h,
                              width: 110.w,
                              margin:
                                  const EdgeInsetsDirectional.only(start: 10),
                              child: Column(
                                children: [
                                  Container(
                                    width: 110.w,
                                    height: 85.h,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: secondaryColor.withOpacity(0.12),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CustomImage(
                                        url: logic.subjectsWithoutAddList[index]
                                            .image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  CustomText(
                                    logic.subjectsWithoutAddList[index].name,
                                    color: greyTextColor,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),
                          )),
                );
        });
  }

  buildSchedule() {
    return GetBuilder<CalendarLogic>(
        init: Get.find<CalendarLogic>(),
        builder: (logic) {
          var list = logic.getBookByDay(DateTime.now());
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (list.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: CustomText(
                    'Upcoming Schedule'.tr,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              if (list.isNotEmpty) ScheduleWidget(day: DateTime.now())
            ],
          );
        });
  }
}
