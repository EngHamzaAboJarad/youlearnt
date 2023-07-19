import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/core/helper_methods.dart';
import 'package:you_learnt/entities/classroom_model.dart';
import 'package:you_learnt/features/_profile/classrooms/logic.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../utils/custom_widget/custom_button_widget.dart';
import '../../../../../../utils/custom_widget/custom_text.dart';
import '../../../../view_profile/logic.dart';

class AvalibleTeacherClassroomsDetails extends StatefulWidget {
  const AvalibleTeacherClassroomsDetails({Key? key, required this.item})
      : super(key: key);

  @override
  State<AvalibleTeacherClassroomsDetails> createState() =>
      _AvalibleTeacherClassroomsDetailsState();
  final ClassRoomModel item;
}

class _AvalibleTeacherClassroomsDetailsState
    extends State<AvalibleTeacherClassroomsDetails> {
  final HelperMethods _helperMethods = HelperMethods();
  final ViewProfileLogic viewProfileLogic = Get.find();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // executes after build

    // });
    Get.find<ClassroomsLogic>()
        .getTeacherAvalibleClassroomDetails(widget.item.id);
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
                                                        url: logic
                                                            .classRoomDetails!
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
                                                                .classRoomDetails!
                                                                .userModel
                                                                ?.fullName,
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
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          child: Container(
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
                                                              color:
                                                                  Colors.white,
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
                                                                        "Start at : ".tr +
                                                                            logic.classRoomDetails!.booksList[index].startAt.toString(),
                                                                        color:
                                                                            secondaryColor,
                                                                      ),
                                                                    ),
                                                                    // InkWell(
                                                                    //   onTap:
                                                                    //       () {
                                                                    //     _helperMethods.showAlertDilog(
                                                                    //         message: "Are you sure to delete this time ?".tr,
                                                                    //         title: "Alert!",
                                                                    //         context: context,
                                                                    //         function: () {
                                                                    //           logic.deleteClassAddedTime(index);
                                                                    //         });
                                                                    //   },
                                                                    //   child:
                                                                    //       const Icon(
                                                                    //     Icons
                                                                    //         .delete,
                                                                    //     color: Colors
                                                                    //         .red,
                                                                    //   ),
                                                                    // )
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
                                                                  "End at : "
                                                                          .tr +
                                                                      logic
                                                                          .classRoomDetails!
                                                                          .booksList[
                                                                              index]
                                                                          .endAt
                                                                          .toString(),
                                                                  color:
                                                                      mainColor,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Divider(),
                                            ],
                                          ),
                                        )),
                                        // join this group
                                       ! logic.classRoomDetails!.isStudent
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 30.h),
                                                child: CustomButtonWidget(
                                                    loading:
                                                        logic.isOrderLoading,
                                                    title: 'Join group'.tr,
                                                    onTap: () {
                                                      logic.handleJoinClass(
                                                          classRoomModel:
                                                              widget.item,
                                                          context: context);
                                                      // AddNewClassRoomPage
                                                      // Get.to(AddNewClassRoomPage(
                                                      //   edit: false,
                                                      // ));
                                                      //   Get.to(
                                                      // AddBlogPage(
                                                      //   edit: false,
                                                      // ),
                                                    }),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 30.h),
                                                child: CustomButtonWidget(
                                                    loading:
                                                        logic.isOrderLoading,
                                                    title: 'You already joined!'.tr,
                                                    onTap: () {}),
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
