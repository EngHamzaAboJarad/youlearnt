import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/core/helper_methods.dart';
import 'package:you_learnt/features/_profile/classrooms/logic.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';

import '../../../../../constants/colors.dart';
import '../../../../../entities/reschduldedBookModel.dart';
import '../../../../../utils/custom_widget/custom_button_widget.dart';
import '../../../../../utils/custom_widget/custom_text.dart';

class StudentReschduledBooksClassroomDetails extends StatefulWidget {
  const StudentReschduledBooksClassroomDetails({Key? key, required this.item})
      : super(key: key);

  @override
  State<StudentReschduledBooksClassroomDetails> createState() =>
      _StudentReschduledBooksClassroomDetailsState();
  final ReschduldedBookModel item;
}

class _StudentReschduledBooksClassroomDetailsState
    extends State<StudentReschduledBooksClassroomDetails> {
  final HelperMethods _helperMethods = HelperMethods();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // executes after build

    // });
    Get.find<ClassroomsLogic>()
        .getStudentReschduledBookClassroomDetails(widget.item.id);
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
              'Book details'.tr,
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
                        child: GetBuilder<ClassroomsLogic>(
                            id: "update_rescdule",
                            builder: (logic) {
                              return logic.isUpdatingReschdule
                                  ? const SizedBox(
                                      child: Center(
                                          child: SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ))))
                                  : logic.studentReschduldedBookModelDetails ==
                                          null
                                      ? Center(
                                          child: CustomText(
                                            "No Details available!".tr,
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
                                                              BorderRadius
                                                                  .circular(
                                                                      30.sp),
                                                          child: CustomImage(
                                                            url: logic
                                                                .studentReschduldedBookModelDetails!
                                                                .userModel
                                                                ?.imageUrl,
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
                                                                logic
                                                                    .studentReschduldedBookModelDetails!
                                                                    .userModel
                                                                    ?.fullName,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              // CustomText(
                                                              //   logic
                                                              //       .classRoomDetails!
                                                              //       .title,
                                                              //   fontSize: 12,
                                                              //   color:
                                                              //       greyTextColor,
                                                              //   // overflow:
                                                              //   //     TextOverflow
                                                              //   //         .ellipsis,
                                                              // ),
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
                                                      Chip(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          backgroundColor:
                                                              secondaryColor,
                                                          label: CustomText(
                                                            "status : ".tr +
                                                                logic
                                                                    .studentReschduldedBookModelDetails!
                                                                    .status
                                                                    .toString(),
                                                            color: Colors.white,
                                                          )),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  if (logic
                                                          .studentReschduldedBookModelDetails!
                                                          .status ==
                                                      "Pending")
                                                    Column(
                                                      children: [
                                                        const Divider(),
                                                        CustomText(
                                                          "Old book".tr,
                                                          fontSize: 20,
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
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
                                                                              .studentReschduldedBookModelDetails!
                                                                              .classroomBookModel!
                                                                              .startAt
                                                                              .toString(),
                                                                      color:
                                                                          secondaryColor,
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
                                                                    logic
                                                                        .studentReschduldedBookModelDetails!
                                                                        .classroomBookModel!
                                                                        .endAt
                                                                        .toString(),
                                                                color:
                                                                    mainColor,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  const Divider(),
                                                  CustomText(
                                                    "New book".tr,
                                                    fontSize: 20,
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(8),
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                                                              child: CustomText(
                                                                "Start at : "
                                                                        .tr +
                                                                    logic
                                                                        .studentReschduldedBookModelDetails!
                                                                        .startAt
                                                                        .toString(),
                                                                color:
                                                                    secondaryColor,
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
                                                              logic
                                                                  .studentReschduldedBookModelDetails!
                                                                  .endAt
                                                                  .toString(),
                                                          color: mainColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Divider(),
                                                ],
                                              ),
                                            )),
                                          ],
                                        );
                            }),
                      ),
                    ),

                    // accept and reject

                    logic.studentReschduldedBookModelDetails == null
                        ? Container()
                        : Container(
                            color: Colors.white,
                            child: (logic.studentReschduldedBookModelDetails!.status !=
                        "Pending") ? Container() : Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 30.h),
                                    child: CustomButtonWidget(
                                        title: 'Approve'.tr,
                                        loading: logic.isUpdatingReschdule,
                                        onTap: () {
                                          logic
                                              .updateStudentRescduledBookStatus(
                                                  widget.item.id, "approved");
                                        }),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 30.h),
                                    child: CustomButtonWidget(
                                        loading: logic.isUpdatingReschdule,
                                        title: 'Rejcet'.tr,
                                        onTap: () {
                                          _helperMethods.showAlertDilog(
                                              message:
                                                  "Are you sure to reject the new book?",
                                              title: "Alert!".tr,
                                              context: context,
                                              function: () {
                                                logic
                                                    .updateStudentRescduledBookStatus(
                                                        widget.item.id,
                                                        "cancelled");
                                              });
                                        }),
                                  ),
                                )
                              ],
                            ),
                          )
                  ],
                ),
              );
            },
          )),
    );
  }
}
