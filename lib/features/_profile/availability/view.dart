import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'logic.dart';

class AvailabilityPage extends StatelessWidget {
  final logic = Get.put(AvailabilityLogic());

  AvailabilityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logic.getTimes();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
      body: Container(
        color: secondaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'Profile'.tr,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  CustomText(
                    'Availability'.tr,
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
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(25), topLeft: Radius.circular(25))),
              child: GetBuilder<AvailabilityLogic>(builder: (logic) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'Set your availability first by choosing the month, then the day, and finally the time you are available.'
                                .tr,
                            color: Colors.grey.shade500,
                            fontSize: 12,
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
                                        padding:
                                            const EdgeInsetsDirectional.only(end: 10),
                                        child: CustomText(
                                          logic.months[index].toString().toUpperCase(),
                                          fontWeight: logic.selectedMonth == index
                                              ? FontWeight.w900
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
                                itemCount:
                                    DateTime(DateTime.now().year, logic.selectedMonth, 0)
                                        .day,
                                itemBuilder: (context, index) => buildDay(logic, index)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomText(
                            'Times'.tr,
                            fontSize: 16,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          logic.isLoading
                              ? const LinearProgressIndicator()
                              : GridView.builder(
                                  itemCount: logic.getTimeByDay().length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 4.5,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                  itemBuilder: (context, index) =>
                                      buildTime(logic, index)),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      )),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 40.h),
                      child: CustomButtonWidget(
                        title: 'Add new time'.tr,
                        onTap: () => logic.openDialog(),
                      ),
                    ),
                  ],
                );
              }),
            )),
          ],
        ),
      ),
    );
  }

  Container buildTime(AvailabilityLogic logic, int index) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 1)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              logic.getTimeFormat(logic.getTimeByDay()[index]),
              fontSize: 12,
            ),
          ),
          if (logic.getTimeByDay()[index].eventName == 'group')
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: blueColor.withOpacity(0.2)),
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                child: CustomText(
                  'Group'.tr,
                  color: blueColor,
                  fontSize: 11,
                )),
          GestureDetector(
              onTap: ()=>logic.deleteAvailability(logic.getTimeByDay()[index].id),
              child: const Icon(Icons.close))
        ],
      ),
    );
  }

  GestureDetector buildDay(AvailabilityLogic logic, int index) {
    return GestureDetector(
      onTap: () => logic.changeSelectedDay(index),
      child: Container(
        width: 55,
        decoration: BoxDecoration(
            color: index == logic.selectedDay ? secondaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsetsDirectional.only(end: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              DateFormat().add_E().format(
                  DateTime(DateTime.now().year, logic.selectedMonth + 1, index + 1)),
              color: index == logic.selectedDay ? Colors.white : Colors.black,
            ),
            CustomText(
              (index + 1).toString(),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: index == logic.selectedDay ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
