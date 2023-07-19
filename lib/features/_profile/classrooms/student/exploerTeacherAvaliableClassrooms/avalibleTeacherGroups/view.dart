import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/core/helper_methods.dart';
import 'package:you_learnt/features/_profile/classrooms/logic.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../entities/TeacherModel.dart';
import '../../../../../../utils/custom_widget/custom_text.dart';
import '../avaliableTeacherCourseDetails/view.dart';

class AvalibleTeacherClassrooms extends StatefulWidget {
  const AvalibleTeacherClassrooms({Key? key, required this.teacherModel})
      : super(key: key);

  @override
  State<AvalibleTeacherClassrooms> createState() =>
      _AvalibleTeacherClassroomsState();

  final TeacherModel? teacherModel;
}

class _AvalibleTeacherClassroomsState extends State<AvalibleTeacherClassrooms> {
  final HelperMethods _helperMethods = HelperMethods();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // executes after build

    // });
    if (widget.teacherModel != null) {
      Get.find<ClassroomsLogic>()
          .getTeacherAvalibaleClassrooms(true, widget.teacherModel!);
    }
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
            title: CustomText(
              widget.teacherModel!.user!.fullName,
              color: Colors.white,
            ),
            centerTitle: false,
          ),
          body: GetBuilder<ClassroomsLogic>(
            builder: (logic) {
              return Container(
                color: secondaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'Available Classrooms'.tr,
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )
                        ],
                      ),
                    ),
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
                              : logic.classroomsList.isEmpty
                                  ? Center(
                                      child: CustomText(
                                        "No classrooms".tr,
                                        fontSize: 20,
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            controller: logic
                                                .studentClassroomListController,
                                            itemCount:
                                                logic.classroomsList.length,
                                            itemBuilder: (context, index) =>
                                                Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => Get.to(
                                                      AvalibleTeacherClassroomsDetails(
                                                    item: logic
                                                        .classroomsList[index],
                                                  )),
                                                  // logic
                                                  //     .goToStudentClassroomDetails(
                                                  //         logic.classroomsList[
                                                  //             index]),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade400,
                                                            width: 0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Stack(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              child: SizedBox(
                                                                height: 120.h,
                                                                child:
                                                                    CustomImage(
                                                                  url: logic
                                                                      .classroomsList[
                                                                          index]
                                                                      .imageUrl,
                                                                  width: double
                                                                      .infinity,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                //  color: primaryColor.withOpacity(0.2),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      CustomText(
                                                                    logic
                                                                        .classroomsList[
                                                                            index]
                                                                        .title,
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                                // GestureDetector(
                                                                //     onTap: () {
                                                                //       // logic.toggleMenu(
                                                                //       //     logic.classroomsList[
                                                                //       //         index]);
                                                                //     },
                                                                //     child:
                                                                //         const Icon(
                                                                //       Icons
                                                                //           .more_vert_outlined,
                                                                //       color: Colors
                                                                //           .grey,
                                                                //     ))
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            CustomText(
                                                              logic
                                                                  .classroomsList[
                                                                      index]
                                                                  .description,
                                                              fontSize: 12,
                                                              color:
                                                                  greyTextColor,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                PositionedDirectional(
                                                  end: 10,
                                                  top: 200,
                                                  child: AnimatedSize(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsetsDirectional
                                                                  .only(
                                                              end: 20, top: 5),
                                                      width: logic
                                                              .classroomsList[
                                                                  index]
                                                              .isSelected
                                                          ? 110.w
                                                          : 0,
                                                      height: logic
                                                              .classroomsList[
                                                                  index]
                                                              .isSelected
                                                          ? null
                                                          : 0,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 0.5)),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              // logic.editClassRoom(
                                                              //     logic.classroomsList[
                                                              //         index]);
                                                            },
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: CustomText(
                                                                'Edit'.tr,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 0.5,
                                                            color: Colors.grey,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              // _helperMethods
                                                              //     .showAlertDilog(
                                                              //         message:
                                                              //             "Are you sure to delete this classroom ?"
                                                              //                 .tr,
                                                              //         title: "Alert!",
                                                              //         context:
                                                              //             context,
                                                              //         function: () {
                                                              //           logic.deleteTeacherClassroom(logic
                                                              //               .classroomsList[
                                                              //                   index]
                                                              //               .id
                                                              //               .toString());
                                                              //         });
                                                            },
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: CustomText(
                                                                'Delete'.tr,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                        }),
                      ),
                    ),
                    if (logic.loadMoreItems)
                      Container(
                          height: 50,
                          color: Colors.white,
                          child: const Center(
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ))))
                  ],
                ),
              );
            },
          )),
    );
  }
}
