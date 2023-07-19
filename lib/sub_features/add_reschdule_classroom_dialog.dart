import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:you_learnt/features/_profile/classrooms/logic.dart';

import '../constants/colors.dart';
import '../constants/images.dart';
import '../utils/custom_widget/custom_button_widget.dart';
import '../utils/custom_widget/custom_text.dart';

class AddReschduleClassroomDialog extends StatelessWidget {
  const AddReschduleClassroomDialog(
      {Key? key,
      required this.bookId,
      required this.classroomId,
      required this.type})
      : super(key: key);

  final int? bookId;
  final int? classroomId;
  final String type;

  handleActionType(ClassroomsLogic logic) {
    switch (type) {
      case "rescdule":
        logic.reschduleNewTime(classRoomId: bookId!);
        break;
      case "Suggest-Book":
        logic.teachrSuggestNewTime(classRoomId: classroomId!);
        break;
      case "add-class-room":
        logic.addClassRoomsTimeToList();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassroomsLogic>(
        init: Get.find<ClassroomsLogic>(),
        id: "rescdule",
        builder: (logic) {
          return Container(
            height: 600.h,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30))),
            padding: const EdgeInsets.only(left: 12, right: 12, top: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.grey.shade500,
                          size: 12,
                        ),
                        CustomText(
                          'Back'.tr,
                          color: Colors.grey.shade500,
                          fontSize: 18,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: CustomText(
                      'Add new time'.tr,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    'Date'.tr,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () => logic.pickDate(),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          CustomText(
                            DateFormat.yMMMd().format(logic.selectedDate!),
                            fontSize: 16,
                          ),
                          const Spacer(),
                          Image.asset(
                            iconCalendar,
                            scale: 2.5,
                            color: secondaryLightColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    'Time'.tr,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => logic.pickFromTime(),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: CustomText(
                              logic.fromTime,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => logic.pickToTime(),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: CustomText(
                              logic.toTime,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // CustomText(
                  //   'Type'.tr,
                  //   fontSize: 16,
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Row(
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () => logic.changeTypeSelected(true),
                  //       child: Row(
                  //         children: [
                  //           Image.asset(
                  //             !logic.isPrivate ? iconCheckOff : iconCheckOn,
                  //             width: 15,
                  //           ),
                  //           const SizedBox(
                  //             width: 5,
                  //           ),
                  //           CustomText(
                  //             'Private'.tr,
                  //             fontSize: 16,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //       width: 30,
                  //     ),
                  //     GestureDetector(
                  //       onTap: () => logic.changeTypeSelected(false),
                  //       child: Row(
                  //         children: [
                  //           Image.asset(
                  //             logic.isPrivate ? iconCheckOff : iconCheckOn,
                  //             width: 15,
                  //           ),
                  //           const SizedBox(
                  //             width: 5,
                  //           ),
                  //           CustomText(
                  //             'Group'.tr,
                  //             fontSize: 16,
                  //           ),
                  //         ],
                  //       ),
                  //     )
                  //   ],
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButtonWidget(
                      title: 'Add'.tr,
                      loading: logic.isAddLoading,
                      onTap: () {
                        handleActionType(logic);
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
