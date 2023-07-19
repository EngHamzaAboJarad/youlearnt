import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/core/helper_methods.dart';
import 'package:you_learnt/entities/BookModel.dart';
import 'package:you_learnt/features/_profile/classrooms/logic.dart';

import '../../../constants/colors.dart';
import '../../../data/hive/hive_controller.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';
import '../../_profile/logic.dart';
import '../calendar/logic.dart';

// work here
class ScheduleWidget extends StatelessWidget {
  final DateTime day;

  ScheduleWidget({required this.day, Key? key}) : super(key: key);
  ProfileLogic profileLogic = Get.find();

  Future<void> handelStudentOption(
      {required BuildContext context, required BookModel item}) async {
    // log(item.cancelled.toString());
    // log(item.rescheduled.toString());
    // log(item.unableToAttend.toString());
    await showDialog(
        context: context,
        builder: (ctx) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AlertDialog(
                  scrollable: true,
                  contentPadding: const EdgeInsets.all(8),
                  insetPadding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  title: Center(
                    child: CustomText(
                      "Student Actions".tr,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: GetBuilder<ClassroomsLogic>(
                    id: "student-action",
                    builder: (logic) {
                      //
                      return Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                          ),
                          if (item.rescheduled!)
                            CustomButtonWidget(
                              title: 'rescheduled'.tr,
                              color: secondaryColor,
                              loading: logic.isStudentActionUpdaitng,
                              onTap: () async {
                                log(item.user!.slug.toString());
                                log(item.teacherSubjectId.toString());
                                if (item.user != null) {
                                  await logic.getTeacherAvalibleSuggstedBooks(
                                    teacherSlug: item.user!.slug.toString(),
                                    teacherSubjectId:
                                        item.teacherSubjectId.toString(),
                                  );
                                  if (logic
                                      .teacherAvalibleSuggstedBooks.isEmpty) {
                                    showMessage(
                                        "There are no other books!".tr, 2);
                                  } else {
                                    showTeacherAvalibaleOption(
                                        context: context, item: item);
                                  }
                                } else {
                                  showMessage("Not Available".tr, 2);
                                }

                                // updateStudentBookActions
                              },
                            ),
                          if (item.unableToAttend!)
                            const SizedBox(
                              height: 15,
                            ),
                          if (item.unableToAttend!)
                            CustomButtonWidget(
                              title: 'Unable to attend'.tr,
                              color: secondaryColor,
                              loading: logic.isStudentActionUpdaitng,
                              onTap: () {
                                if (item.id == null) return;
                                logic.updateStudentBookActions(
                                  bookId: item.id!,
                                  type: "unable_to_attend",
                                );
                              },
                            ),
                          if (item.cancelled!)
                            const SizedBox(
                              height: 15,
                            ),
                          if (item.cancelled!)
                            CustomButtonWidget(
                              title: 'Cancelled'.tr,
                              loading: logic.isStudentActionUpdaitng,
                              onTap: () {
                                if (item.id == null) return;
                                logic.updateStudentBookActions(
                                  bookId: item.id!,
                                  type: "cancelled",
                                );
                              },
                            ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomButtonWidget(
                            title: 'close'.tr,
                            // color: secondaryColor,
                            loading: logic.isStudentActionUpdaitng,
                            onTap: () {
                              Get.back();
                            },
                          ),
                        ],
                      );
                    },
                  )),
            ));
  }

  final HelperMethods _helperMethods = HelperMethods();

  Future<void> showTeacherAvalibaleOption(
      {required BuildContext context, required BookModel item}) async {
    await showDialog(
        context: context,
        builder: (ctx) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AlertDialog(
                  scrollable: true,
                  contentPadding: const EdgeInsets.all(8),
                  insetPadding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  title: Center(
                    child: CustomText(
                      "Choose a new book".tr,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: GetBuilder<ClassroomsLogic>(
                    id: "student-action",
                    builder: (logic) {
                      //
                      return Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                          ),
                          Column(
                            children: List.generate(
                                logic.teacherAvalibleSuggstedBooks.length,
                                (index) {
                              return InkWell(
                                onTap: () {
                                  logic
                                      .onChangeSelectedtTeacherAvalibleSuggstedBooksType(
                                          index);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(12),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: logic
                                                .selectedtTeacherAvalibleSuggstedBooksIndex !=
                                            index
                                        ? Border.all(
                                            width: 1,
                                            color: Colors.grey.shade300)
                                        : Border.all(
                                            width: 2,
                                            color:
                                                logic.selectedtTeacherAvalibleSuggstedBooksIndex ==
                                                        index
                                                    ? secondaryColor
                                                    : Colors.grey.shade300),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (logic
                                              .teacherAvalibleSuggstedBooks[
                                                  index]
                                              .subjectName !=
                                          null)
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: CustomText(
                                            logic
                                                    .teacherAvalibleSuggstedBooks[
                                                        index]
                                                    .subjectName ??
                                                "",
                                            color: Colors.white,
                                          ),
                                        ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              "Start at : ".tr +
                                                  _helperMethods
                                                      .convertSuggestBookDate(
                                                    logic
                                                        .teacherAvalibleSuggstedBooks[
                                                            index]
                                                        .start
                                                        .toString(),
                                                  ),
                                              color: secondaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Divider(),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      CustomText(
                                        "End at : ".tr +
                                            _helperMethods
                                                .convertSuggestBookDate(logic
                                                    .teacherAvalibleSuggstedBooks[
                                                        index]
                                                    .end
                                                    .toString()),
                                        color: mainColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButtonWidget(
                                  title: 'close'.tr,
                                  // color: secondaryColor,
                                  loading: logic.isStudentActionUpdaitng,
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: CustomButtonWidget(
                                  title: 'Choose'.tr,
                                  color: secondaryColor,
                                  loading: logic.isStudentActionUpdaitng,
                                  onTap: () {
                                    logic.updateStudentBookActions(
                                      bookId: item.id!,
                                      type: "rescheduled",
                                      newBookId: logic
                                          .teacherAvalibleSuggstedBooks[logic
                                              .selectedtTeacherAvalibleSuggstedBooksIndex]
                                          .id
                                          .toString(),
                                    );
                                    // Get.back();
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarLogic>(
        init: Get.find<CalendarLogic>(),
        builder: (logic) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: logic.getBookByDay(day).length,
                      itemBuilder: (context, index) {
                        var item = logic.getBookByDay(day)[index];
                        // log("item ${item.eventName} : " + item.type.toString());
                        return SizedBox(
                          height: 110.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 15, top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        item.startFormated,
                                        color: greyTextColor,
                                        fontSize: 12,
                                      ),
                                      CustomText(
                                        item.endFormated,
                                        color: greyTextColor,
                                        fontSize: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  height: double.infinity,
                                  width: 1,
                                  color: Colors.grey.shade300),
                              Expanded(
                                flex: 4,
                                child: Stack(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        height: 1,
                                        color: Colors.grey.shade300),
                                    Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(top: 22.h),
                                        height: 1,
                                        color: Colors.grey.shade300),
                                    Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(top: 44.h),
                                        height: 1,
                                        color: Colors.grey.shade300),
                                    Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(top: 66.h),
                                        height: 1,
                                        color: Colors.grey.shade300),
                                    Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(top: 88.h),
                                        height: 1,
                                        color: Colors.grey.shade300),
                                    Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(
                                            top:
                                                logic.getBookByDay(day).length -
                                                            1 ==
                                                        index
                                                    ? 109.h
                                                    : 110.h),
                                        height: 1,
                                        color: Colors.grey.shade300),
                                    InkWell(
                                      onTap: () => logic.goToMeet(item.id),
                                      child: Container(
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                                bottom: 10, start: 20),
                                        decoration: BoxDecoration(
                                            color: item.type == 'one'
                                                ? const Color(0xffFFF4F1)
                                                : const Color(0xffEBF6FF),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  item.classId?.teacherSubject
                                                      ?.subjectName,
                                                  maxLines: 1,
                                                  fontSize: 15,
                                                ),
                                                CustomText(
                                                  '${item.startFormated ?? ''} - ${item.endFormated ?? ''}',
                                                  fontSize: 13,
                                                  maxLines: 1,
                                                  color: Colors.grey.shade400,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                item.students != null
                                                    ? (item.type == 'one' ||
                                                            item.students!
                                                                    .length <
                                                                2)
                                                        ? Row(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                child:
                                                                    CustomImage(
                                                                  url: item
                                                                      .students
                                                                      ?.firstWhereOrNull((element) =>
                                                                          element !=
                                                                          null)
                                                                      ?.imageUrl,
                                                                  height: 20.h,
                                                                  width: 20.h,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Flexible(
                                                                // flex:,
                                                                child:
                                                                    CustomText(
                                                                  item.students
                                                                      ?.firstWhereOrNull((element) =>
                                                                          element !=
                                                                          null)
                                                                      ?.fullName,
                                                                  fontSize: 12,
                                                                  maxLines: 1,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Row(
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    child:
                                                                        CustomImage(
                                                                      url: item
                                                                          .students![
                                                                              0]
                                                                          .imageUrl,
                                                                      height:
                                                                          20.h,
                                                                      width:
                                                                          20.h,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsetsDirectional
                                                                            .only(
                                                                        start:
                                                                            20),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      child:
                                                                          CustomImage(
                                                                        url: item
                                                                            .students![1]
                                                                            .imageUrl,
                                                                        height:
                                                                            20.h,
                                                                        width:
                                                                            20.h,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              if (item.students!
                                                                      .length >
                                                                  2)
                                                                CustomText(
                                                                  (item.students!
                                                                              .length -
                                                                          2)
                                                                      .toString(),
                                                                  fontSize: 12,
                                                                  maxLines: 1,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                ),
                                                            ],
                                                          )
                                                    : Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child: CustomImage(
                                                              url: item.user
                                                                  ?.imageUrl,
                                                              height: 20.h,
                                                              width: 20.h,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          CustomText(
                                                            item.user?.fullName,
                                                            fontSize: 12,
                                                            maxLines: 1,
                                                            color: Colors
                                                                .grey.shade400,
                                                          ),
                                                        ],
                                                      )
                                              ],
                                            )),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: item.type == 'one'
                                                    ? const Color(0xffFFE0D6)
                                                    : const Color(0xffDBEEFF),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              child: CustomText(
                                                item.type == 'one'
                                                    ? 'Private'.tr
                                                    : 'Group'.tr,
                                                fontSize: 12,
                                                color: item.type == 'one'
                                                    ? primaryColor
                                                    : secondaryColor,
                                                // textAlign: TexA,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            if (item.type == 'one')
                                              Transform(
                                                transform:
                                                    Matrix4.translationValues(
                                                        0, 5, 0),
                                                child: InkWell(
                                                  onTap: () {
                                                    // sudent option
                                                    if (HiveController
                                                        .getIsStudent()) {
                                                      log("Student ${item.id}");
                                                      handelStudentOption(
                                                          context: context,
                                                          item: item);
                                                    } else {
                                                      if (item.classId ==
                                                          null) {
                                                        showMessage(
                                                            "No Classroom for this book!",
                                                            2);
                                                        return;
                                                      }
                                                      log("teacher");

                                                      log(item.classId!.id
                                                          .toString());

                                                      Get.find<
                                                              ClassroomsLogic>()
                                                          .goToTeacherClassroomDetails(
                                                              classroomModel:
                                                                  null,
                                                              bookModel: item);
                                                    }
                                                    // return;
                                                  },
                                                  child: const Icon(
                                                    Icons.edit,
                                                    color: secondaryColor,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      })),
            ],
          );
        });
  }
}
