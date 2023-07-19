import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:you_learnt/entities/BookModel.dart';
import 'package:you_learnt/features/_main/widgets/schedule_widget.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../data/hive/hive_controller.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../_auth/auth/view.dart';
import '../widgets/header_widget.dart';
import 'logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final logic = Get.find<CalendarLogic>();


  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColor,
      child: Column(
        children: [
          HeaderWidget(titleBig: 'Calendar'.tr, titleSmall: ''.tr),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25), topLeft: Radius.circular(25))),
              child: GetBuilder<CalendarLogic>(builder: (logic) {
                var list = logic.getBookByDay(DateTime.now());
                return HiveController.getToken() == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              'You should login or create new account to see your calender'
                                  .tr,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: CustomButtonWidget(
                                  title: 'Log In'.tr,
                                  textSize: 16,
                                  onTap: () => Get.to(AuthPage())
                                      ?.then((value) => setState(() {}))),
                            ),
                          ],
                        ),
                      )
                    : logic.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!logic.monthlyIsSelected)
                                  const SizedBox(
                                    height: 10,
                                  ),
                                if (!logic.monthlyIsSelected)
                                  SfCalendar(
                                    controller: logic.calendarController,
                                    onSelectionChanged: (date) {
                                      try {
                                        logic.update();
                                      } catch (e) {}
                                    },
                                    dataSource: MeetingDataSource(logic.bookList
                                        .map((e) => Meeting(
                                            e.title ?? '',
                                            DateTime.parse(e.start ?? '2022-10-05'),
                                            DateTime.parse(e.end ?? '2022-10-05'),
                                            e.type != 'one'
                                                ? secondaryColor
                                                : primaryColor,
                                            false))
                                        .toList()),
                                    onViewChanged: (val) {
                                      if (HiveController.getIsStudent()) {
                                        logic.getStudentBooks(
                                            month: val.visibleDates[10].month);
                                      } else {
                                        logic.getTeacherBooks(
                                            month: val.visibleDates[10].month);
                                      }
                                    },
                                    view: CalendarView.month,
                                  ),
                                if (logic.monthlyIsSelected)
                                  if (list.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: CustomText(
                                        'Today’s Class'.tr,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                if (logic.monthlyIsSelected)
                                  if (list.isNotEmpty)
                                    SizedBox(
                                      height: 210.h,
                                      child: ListView.builder(
                                          itemCount: list.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              buildContainer(list[index])),
                                    ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CustomText(
                                    'Classes Schedule'.tr,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () =>
                                            logic.changeSelected(mLoginIsSelected: true),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            CustomText(
                                              'Monthly'.tr,
                                              fontSize: 16,
                                              fontWeight: logic.monthlyIsSelected
                                                  ? FontWeight.bold
                                                  : null,
                                              color: logic.monthlyIsSelected
                                                  ? secondaryColor
                                                  : Colors.black,
                                            ),
                                            SizedBox(
                                              height: logic.monthlyIsSelected ? 5 : 8,
                                            ),
                                            AnimatedSize(
                                              duration: const Duration(milliseconds: 300),
                                              child: Container(
                                                height: logic.monthlyIsSelected ? 2 : 1,
                                                color: logic.monthlyIsSelected
                                                    ? secondaryColor
                                                    : secondaryLightColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () =>
                                            logic.changeSelected(mLoginIsSelected: false),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            CustomText(
                                              'Daily'.tr,
                                              fontSize: 16,
                                              fontWeight: !logic.monthlyIsSelected
                                                  ? FontWeight.bold
                                                  : null,
                                              color: !logic.monthlyIsSelected
                                                  ? secondaryColor
                                                  : Colors.black,
                                            ),
                                            SizedBox(
                                              height: !logic.monthlyIsSelected ? 5 : 8,
                                            ),
                                            AnimatedSize(
                                              duration: const Duration(milliseconds: 300),
                                              child: Container(
                                                height: !logic.monthlyIsSelected ? 2 : 1,
                                                color: !logic.monthlyIsSelected
                                                    ? secondaryColor
                                                    : secondaryLightColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                buildSchedule(logic),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Container buildContainer(BookModel item) {
    return Container(
      width: 160.w,
      margin: const EdgeInsetsDirectional.only(start: 10),
      child: Container(
        decoration: BoxDecoration(
            color: secondaryLightColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              left: 0,
              child: Image.asset(
                imageBgClass,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Container(
                    decoration: BoxDecoration(
                        color: greenColor, borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: CustomText(
                      item.startFormated,
                      color: Colors.white,
                    )),
                const Spacer(),
                Center(
                    child: CustomText(
                  item.classId?.teacherSubject?.subjectName,
                  fontSize: 15,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CustomImage(
                        url: item.user?.imageUrl,
                        height: 25.h,
                        fit: BoxFit.cover,
                        width: 25.h,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomText(
                      item.user?.fullName,
                      fontSize: 12,
                      maxLines: 1,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildSchedule(CalendarLogic logic) {
    return logic.monthlyIsSelected
        ? Container(
            padding: const EdgeInsets.all(10.0),
            height: 500,
            child: SfCalendar(
              view: CalendarView.month,
              controller: logic.calendarController,
              dataSource: MeetingDataSource(logic.bookList
                  .map((e) => Meeting(
                      e.title ?? '',
                      DateTime.parse(e.start ?? '2021-10-05'),
                      DateTime.parse(e.end ?? '2021-10-05'),
                      e.type != 'one' ? secondaryColor : primaryColor,
                      false))
                  .toList()),
              onViewChanged: (val) {
                if (HiveController.getIsStudent()) {
                  logic.getStudentBooks(month: val.visibleDates[10].month);
                } else {
                  logic.getTeacherBooks(month: val.visibleDates[10].month);
                }
              },
              monthViewSettings: const MonthViewSettings(showAgenda: true),
            ),
          )
        : ScheduleWidget(day: logic.calendarController.selectedDate ?? DateTime.now());
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
