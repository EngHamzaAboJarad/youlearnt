import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constants/colors.dart';
import '../constants/images.dart';
import '../entities/SubjectModel.dart';
import '../entities/TeacherModel.dart';
import '../features/_profile/profile/view.dart';
import '../features/_profile/view_profile/logic.dart';
import '../utils/custom_widget/custom_button_widget.dart';
import '../utils/custom_widget/custom_image.dart';
import '../utils/custom_widget/custom_text.dart';

class BookSessionDialog extends StatelessWidget {
  final TeacherModel teacherModel;

  BookSessionDialog(this.teacherModel, {Key? key}) : super(key: key);
  final List<String> list = ['1', '2'];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ViewProfileLogic>(
        init: Get.find<ViewProfileLogic>(),
        builder: (logic) {
          return Container(
            margin: EdgeInsets.only(top: 100.h),
            decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30))),
            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            child: logic.isTimesLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
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
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Container(
                                  width: 70.sp,
                                  height: 70.sp,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.sp),
                                      color: greenColor),
                                  padding: const EdgeInsets.all(3),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.sp),
                                      child: CustomImage(
                                        url: logic.teacherModel?.user?.imageUrl,
                                      ))),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: CustomText(
                                          logic.teacherModel?.user?.fullName,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      CustomImage(
                                        url: logic
                                            .teacherModel?.profile?.countryFlag,
                                        height: 20,
                                        width: 30,
                                      ),
                                      if (logic.teacherModel?.user?.verified ==
                                          true)
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      if (logic.teacherModel?.user?.verified ==
                                          true)
                                        Image.asset(
                                          iconTrusted,
                                          scale: 1.5,
                                        ),
                                      if (logic.teacherModel?.user?.verified ==
                                          true)
                                        const SizedBox(
                                          width: 5,
                                        ),
                                      if (logic.teacherModel?.user?.verified ==
                                          true)
                                        CustomText(
                                          'Verified'.tr,
                                          fontSize: 9,
                                          color: greenColor,
                                        )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        iconDegree,
                                        scale: 2,
                                        color: orangeColor,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      CustomText(
                                        logic.teacherModel?.profile?.level,
                                        color: orangeColor,
                                      )
                                    ],
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: CustomText(
                          'Book private session'.tr,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          'Select the subject of the session'.tr,
                          fontSize: 16,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        buildTimes(logic),
                        const Divider(),
                        CustomText(
                          'Summary'.tr,
                          fontSize: 16,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        buildContainer([
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: CustomText(
                                'Schedule'.tr,
                                color: Colors.grey.shade600,
                              )),
                              CustomText(logic.selectedTime == null
                                  ? ''
                                  : logic.getTimeFormat(logic.selectedTime!)),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: CustomText(
                                'Class Type'.tr,
                                color: Colors.grey.shade600,
                              )),
                              CustomText(logic.selectedTime == null
                                  ? ''
                                  : logic.selectedTime?.eventName == 'group'
                                      ? 'Group'.tr
                                      : 'Private'.tr),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: CustomText(
                                'Cost'.tr,
                                color: Colors.grey.shade600,
                              )),
                              CustomText(logic.selectedSubject == null &&
                                      logic.selectedPlan == null
                                  ? null
                                  : '\$${logic.bookedBefore ? logic.selectedPlan?.price ?? 0 : logic.selectedSubject?.hourlyRate ?? 0}'),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ]),
                        const SizedBox(
                          height: 20,
                        ),
                        if (logic.bookedBefore)
                          CustomText(
                            'Choose a plan'.tr,
                            fontSize: 16,
                          ),
                        if (logic.bookedBefore)
                          const SizedBox(
                            height: 10,
                          ),
                        if (logic.bookedBefore)
                          ListView.builder(
                              itemCount: logic.packagesList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => GestureDetector(
                                    onTap: () =>
                                        logic.changePlanSelected(index),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: logic
                                                .packagesList[index].isSelected
                                            ? secondaryColor.withOpacity(0.1)
                                            : Colors.white,
                                        border: Border.all(
                                            color: logic.packagesList[index]
                                                    .isSelected
                                                ? secondaryColor
                                                : greyTextBoldColor,
                                            width: 0.5),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            logic.packagesList[index].isSelected
                                                ? iconCheck
                                                : iconUncheck,
                                            width: 20,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          CustomText(
                                            '${logic.packagesList[index].hour ?? 0}',
                                            fontWeight: FontWeight.bold,
                                            color: secondaryColor,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          CustomText(
                                            'lessons'.tr,
                                            color: secondaryColor,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              CustomText(
                                                '\$${logic.packagesList[index].price ?? 0}/hr',
                                                color: secondaryColor,
                                              ),
                                              if ((logic.packagesList[index]
                                                          .discount ??
                                                      0) >
                                                  0.0)
                                                CustomText(
                                                  'you save'.tr +
                                                      ' ${logic.packagesList[index].discount ?? 0}\$',
                                                  fontSize: 12,
                                                  color: orangeColor,
                                                ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButtonWidget(
                          title: 'Continue'.tr,
                          loading: logic.isOrderLoading,
                          onTap: () {
                            logic.handleStudentBookSeestions(context: context);  
                            // logic
                            //     .createOrder();
                            /*
                            Fluttertoast.showToast(
                                msg: 'This button will open payment webview page');*/
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  Column buildTimes(ViewProfileLogic logic) {
    var times = logic.getTimeByDay();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<SubjectModel>(
                isExpanded: true,
                hint: CustomText(
                  logic.selectedSubject?.subjectName ?? 'choose'.tr,
                  fontSize: 16,
                  color: logic.selectedSubject != null
                      ? Colors.black
                      : Colors.grey.shade700,
                ),
                //   value: list[0],
                items: logic.teacherModel?.subjects
                    ?.map((e) => DropdownMenuItem<SubjectModel>(
                          child: CustomText(e.subjectName),
                          value: e,
                        ))
                    .toList(),
                onChanged: (val) => logic.onChangeSubject(val)),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        CustomText(
          'Select date'.tr,
          fontSize: 16,
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 30.h,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: logic.months.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () => logic.changeSelectedMonth(index),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 10),
                      child: CustomText(
                        logic.months[index].toString().toUpperCase(),
                        fontWeight: logic.selectedMonth == index
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  )),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 80.h,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: logic.scrollController,
              itemCount:
                  DateTime(DateTime.now().year, logic.selectedMonth, 0).day,
              itemBuilder: (context, index) {
                bool haveTimes = logic.checkDayTimes(index);
                return GestureDetector(
                  onTap: () => logic.changeSelectedDay(index),
                  child: Container(
                    width: 55,
                    decoration: BoxDecoration(
                        color: index == logic.selectedDay
                            ? secondaryColor
                            : haveTimes
                                ? primaryColor
                                : Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsetsDirectional.only(end: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          DateFormat().add_E().format(DateTime(
                              DateTime.now().year,
                              logic.selectedMonth + 1,
                              index + 1)),
                          color: index == logic.selectedDay || haveTimes
                              ? Colors.white
                              : Colors.black,
                        ),
                        CustomText(
                          (index + 1).toString(),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: index == logic.selectedDay || haveTimes
                              ? Colors.white
                              : Colors.black,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        const SizedBox(
          height: 20,
        ),
        times.isEmpty
            ? Center(
                child: CustomText(
                  'No times for this day'.tr,
                  fontSize: 16,
                ),
              )
            : CustomText(
                'Times'.tr,
                fontSize: 16,
              ),
        const SizedBox(
          height: 10,
        ),
        GridView.builder(
            itemCount: times.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              var item = times[index];
              return InkWell(
                onTap: () => logic.changeSelectedTime(item),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: item.isSelected ? secondaryColor : Colors.grey,
                          width: item.isSelected ? 2 : 1)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          logic.getTimeFormat(item),
                          fontSize: 12,
                        ),
                      ),
                      if (item.eventName == 'group')
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: blueColor.withOpacity(0.2)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 1),
                            child: CustomText(
                              'Group'.tr,
                              color: blueColor,
                              fontSize: 11,
                            ))
                    ],
                  ),
                ),
              );
            }),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Container buildContainer(List<Row> list) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 0.5)),
      child: Column(
        children: mapIndexed<Column, Row>(
            list,
            (index, item) => Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 12),
                        child: item),
                    if (index != list.length - 1)
                      Container(
                        width: double.infinity,
                        height: 0.5,
                        color: Colors.grey.shade400,
                      )
                  ],
                )).toList(),
      ),
    );
  }
}
