import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/core/helper_methods.dart';
import 'package:you_learnt/features/_profile/classrooms/teacher/add_class_room/view.dart';

import '../../../../../constants/colors.dart';
import '../../../../../utils/custom_widget/custom_button_widget.dart';
import '../../../../../utils/custom_widget/custom_image.dart';
import '../../../../../utils/custom_widget/custom_text.dart';
import '../../logic.dart';

class TeacherAvalibaleClassrooms extends StatelessWidget {
  TeacherAvalibaleClassrooms({Key? key}) : super(key: key);

  final HelperMethods _helperMethods = HelperMethods();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(
                //   topRight: Radius.circular(25),
                //   topLeft: Radius.circular(25),
                // ),
              ),
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
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: logic.classroomsList.length,
                              itemBuilder: (context, index) => Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        logic.goToTeacherClassroomDetails(
                                            classroomModel:
                                                logic.classroomsList[index],
                                            bookModel: null),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade400,
                                              width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: SizedBox(
                                                  height: 140.h,
                                                  child: CustomImage(
                                                    url: logic
                                                        .classroomsList[index]
                                                        .imageUrl,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
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
                                                    child: CustomText(
                                                      logic
                                                          .classroomsList[index]
                                                          .title,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () =>
                                                          logic.toggleMenu(logic
                                                                  .classroomsList[
                                                              index]),
                                                      child: const Icon(
                                                        Icons
                                                            .more_vert_outlined,
                                                        color: Colors.grey,
                                                      ))
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              CustomText(
                                                logic.classroomsList[index]
                                                    .description,
                                                fontSize: 12,
                                                color: greyTextColor,
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
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: Container(
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                                end: 20, top: 5),
                                        width: logic.classroomsList[index]
                                                .isSelected
                                            ? 110.w
                                            : 0,
                                        height: logic.classroomsList[index]
                                                .isSelected
                                            ? null
                                            : 0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey,
                                                width: 0.5)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () => logic.editClassRoom(
                                                  logic.classroomsList[index]),
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: CustomText(
                                                  'Edit'.tr,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 0.5,
                                              color: Colors.grey,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _helperMethods.showAlertDilog(
                                                    message:
                                                        "Are you sure to delete this classroom ?"
                                                            .tr,
                                                    title: "Alert!",
                                                    context: context,
                                                    function: () {
                                                      logic.deleteTeacherClassroom(
                                                          logic
                                                              .classroomsList[
                                                                  index]
                                                              .id
                                                              .toString());
                                                    });
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: CustomText(
                                                  'Delete'.tr,
                                                  color: Colors.grey.shade500,
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
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 30.h),
                            child: CustomButtonWidget(
                                title: 'Add new Classroom'.tr,
                                onTap: () {
                                  // AddNewClassRoomPage
                                  Get.to(AddNewClassRoomPage(
                                    edit: false,
                                  ));
                                  //   Get.to(
                                  // AddBlogPage(
                                  //   edit: false,
                                  // ),
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
  }
}
