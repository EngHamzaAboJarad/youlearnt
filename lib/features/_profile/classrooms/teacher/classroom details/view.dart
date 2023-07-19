import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/core/helper_methods.dart';
import 'package:you_learnt/entities/BookModel.dart';
import 'package:you_learnt/entities/classroom_model.dart';
import 'package:you_learnt/features/_profile/classrooms/logic.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';

import '../../../../../constants/colors.dart';
import '../../../../../entities/classroom_book_model.dart';
import '../../../../../utils/custom_widget/custom_button_widget.dart';
import '../../../../../utils/custom_widget/custom_text.dart';
import '../../../logic.dart';

class TeacherClassroomDetails extends StatefulWidget {
  const TeacherClassroomDetails(
      {Key? key, required this.classroomModel, required this.bookCalenderModel})
      : super(key: key);

  @override
  State<TeacherClassroomDetails> createState() =>
      _TeacherClassroomDetailsState();
  final ClassRoomModel? classroomModel;
  final BookModel? bookCalenderModel;
}

class _TeacherClassroomDetailsState extends State<TeacherClassroomDetails> {
  final HelperMethods _helperMethods = HelperMethods();

  ProfileLogic profileLogic = Get.find<ProfileLogic>();
  String classroomId = "";
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // executes after build

    // });
    if (widget.classroomModel == null) {
      if (widget.bookCalenderModel!.classId == null) return;
      classroomId = widget.bookCalenderModel!.classId!.id.toString();
    } else {
      classroomId = widget.classroomModel!.id.toString();
    }
    log(classroomId);
    Get.find<ClassroomsLogic>()
        .getTeacherClassroomDetails(int.parse(classroomId));
  }

  Future<void> bookSettings({
    required BuildContext context,
    required ClassroomBookModel classroomBookModel,
    required ClassroomsLogic logic,
    // required int bookIndex,
  }) async {
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
                    "Book Actions".tr,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: GetBuilder<ClassroomsLogic>(builder: (logic) {
                  // log(classroomBookModel.cancelled.toString());
                  // log(classroomBookModel.rescheduled.toString());
                  // log(logic.classRoomDetails!.type.toString());

                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                  "Start at : ".tr +
                                      classroomBookModel.startAt.toString(),
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
                                classroomBookModel.endAt.toString(),
                            color: mainColor,
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // this is for a private student
                          if (logic.classRoomDetails!.type == "one" &&
                              classroomBookModel.rescheduled!)
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10.h),
                              child: CustomButtonWidget(
                                  color: secondaryColor,
                                  loading: logic.isLoading,
                                  title: 'Rescheduled'.tr,
                                  onTap: () {
                                    // check if group or not and check of become less than 2 hours
                                    logic.openTimeDialog(
                                        type: "rescdule",
                                        classroomId: null,
                                        bookId: int.parse(
                                            classroomBookModel.id.toString()));
                                  }),
                            ),
                          // this is for a  student group
                          if (logic.classRoomDetails!.type == "group" && logic.classRoomDetails!.studentCount! >0 )
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10.h),
                              child: CustomButtonWidget(
                                  color: secondaryColor,
                                  loading: logic.isLoading,
                                  title: 'Rescheduled'.tr,
                                  onTap: () {
                                    // check if group or not and check of become less than 2 hours
                                    logic.openTimeDialog(
                                        type: "rescdule",
                                        classroomId: null,
                                        bookId: int.parse(
                                            classroomBookModel.id.toString()));
                                  }),
                            ),
                          if (logic.classRoomDetails!.type == "one" &&
                              classroomBookModel.cancelled!)
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10.h),
                              child: CustomButtonWidget(
                                  color: mainColor,
                                  loading: logic.isLoading,
                                  title: 'Cancel book'.tr,
                                  onTap: () {
                                    _helperMethods.showAlertDilog(
                                        message:
                                            "Are you sure to cancel this book ?"
                                                .tr,
                                        title: "Alert!".tr,
                                        context: context,
                                        function: () {
                                          logic.cancelTeacherPrivateClass(
                                              classRoomId:
                                                  widget.classroomModel != null
                                                      ? widget
                                                          .classroomModel!.id
                                                      : widget
                                                          .bookCalenderModel!
                                                          .classId!
                                                          .id!,
                                              bookId: classroomBookModel.id!,
                                              isTeacher: true);
                                        });
                                    // logic.openTimeDialog(
                                    //     classroom: classroomBookModel,
                                    //     classRoomId: widget.item!.id);
                                  }),
                            ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10.h),
                            child: CustomButtonWidget(
                                title: 'Delete'.tr,
                                loading: logic.isLoading,
                                onTap: () {
                                  _helperMethods.showAlertDilog(
                                      message:
                                          "Are you sure to delete this time ?"
                                              .tr,
                                      title: "Alert!",
                                      context: context,
                                      function: () {
                                        logic.deleteTeacherClassroomBookedTime(
                                            classroomBookModel.id.toString(),
                                            widget.classroomModel!.id);
                                        // logic.deleteClassAddedTime(index);
                                      });
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10.h),
                            child: CustomButtonWidget(
                                title: 'Close'.tr,
                                loading: logic.isLoading,
                                onTap: () {
                                  Get.back();
                                }),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.find<ClassroomsLogic>().closeAllOpentoggeldMenues();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: secondaryColor,
            centerTitle: false,
            title: CustomText(
              'Classroom'.tr,
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: GetBuilder<ClassroomsLogic>(
            builder: (logic) {
              return Container(
                color: secondaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: 10, right: 10, bottom: 10),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       CustomText(
                    //         'Classroom'.tr,
                    //         color: Colors.white,
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25))),
                        child: GetBuilder<ClassroomsLogic>(builder: (logic) {
                          return logic.isLoading
                              ? const SizedBox(
                                  child: Center(
                                      child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ))))
                              : logic.classRoomDetails == null
                                  ? Center(
                                      child: CustomText(
                                        "No classrooms".tr,
                                        fontSize: 20,
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  // if (item.user?.type != 'student') {
                                                  //   Get.to(ViewProfilePage(
                                                  //       slug: item.user?.slug));
                                                  // }
                                                },
                                                // user header
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.sp),
                                                      child: CustomImage(
                                                        url: profileLogic
                                                            .userModel!
                                                            .imageUrl,
                                                        height: 35.sp,
                                                        fit: BoxFit.cover,
                                                        width: 35.sp,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          CustomText(
                                                            profileLogic
                                                                .userModel!
                                                                .fullName,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          CustomText(
                                                            logic
                                                                .classRoomDetails!
                                                                .title,
                                                            fontSize: 12,
                                                            color:
                                                                greyTextColor,
                                                            // overflow:
                                                            //     TextOverflow
                                                            //         .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Wrap(
                                                direction: Axis.horizontal,
                                                spacing: 5,
                                                children: [
                                                  if (logic.classRoomDetails!
                                                      .subjectName!.isNotEmpty)
                                                    Chip(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        backgroundColor:
                                                            secondaryColor,
                                                        label: CustomText(
                                                          "Subject name : ".tr +
                                                              logic
                                                                  .classRoomDetails!
                                                                  .subjectName
                                                                  .toString(),
                                                          color: Colors.white,
                                                        )),
                                                  Chip(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      backgroundColor:
                                                          secondaryColor,
                                                      label: CustomText(
                                                        logic.classRoomDetails!
                                                                    .type
                                                                    .toString() ==
                                                                "one"
                                                            ? 'Private'.tr
                                                            : 'Group'.tr,
                                                        color: Colors.white,
                                                      )),
                                                  Chip(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      backgroundColor:
                                                          mainColor,
                                                      label: CustomText(
                                                        "Price : ".tr +
                                                            logic
                                                                .classRoomDetails!
                                                                .price
                                                                .toString(),
                                                        color: Colors.white,
                                                      )),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              logic.classRoomDetails!
                                                          .description ==
                                                      null
                                                  ? Container()
                                                  : CustomText(
                                                      logic.classRoomDetails!
                                                          .description,
                                                      color: greyTextColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Divider(),
                                              CustomText(
                                                "Books".tr,
                                                fontSize: 20,
                                              ),
                                              Column(
                                                children: List.generate(
                                                  logic.classRoomDetails!
                                                      .booksList.length,
                                                  (index) => Card(
                                                    elevation: 2,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              8),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        // border: Border.all(
                                                        //     color: Colors
                                                        //         .grey.shade300),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    CustomText(
                                                                  "Start at : "
                                                                          .tr +
                                                                      logic
                                                                          .classRoomDetails!
                                                                          .booksList[
                                                                              index]
                                                                          .startAt
                                                                          .toString(),
                                                                  color:
                                                                      secondaryColor,
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  // _helperMethods
                                                                  //     .showAlertDilog(
                                                                  //         message: "Are you sure to delete this time ?"
                                                                  //             .tr,
                                                                  //         title:
                                                                  //             "Alert!",
                                                                  //         context:
                                                                  //             context,
                                                                  //         function:
                                                                  //             () {
                                                                  //           logic.deleteTeacherClassroomBookedTime(logic.classRoomDetails!.booksList[index].id.toString(),
                                                                  //               widget.item.id);
                                                                  //           // logic.deleteClassAddedTime(index);
                                                                  //         });
                                                                  bookSettings(
                                                                      classroomBookModel: logic
                                                                              .classRoomDetails!
                                                                              .booksList[
                                                                          index],
                                                                      context:
                                                                          context,
                                                                      logic:
                                                                          logic);
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.edit,
                                                                  color:
                                                                      secondaryColor,
                                                                ),
                                                              )
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
                                                                logic
                                                                    .classRoomDetails!
                                                                    .booksList[
                                                                        index]
                                                                    .endAt
                                                                    .toString(),
                                                            color: mainColor,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Divider(),
                                            ],
                                          ),
                                        )),
                                        if (logic.classRoomDetails!.type ==
                                            "one")
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                bottom: 30.h),
                                            child: CustomButtonWidget(
                                                title: 'Suggest Book'.tr,
                                                onTap: () {
                                                  logic.openTimeDialog(
                                                      type: 'Suggest-Book',
                                                      bookId: null,
                                                      classroomId: int.parse(
                                                          classroomId));
                                                }),
                                          ),
                                      ],
                                    );
                        }),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
