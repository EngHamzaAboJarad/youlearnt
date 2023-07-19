import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:you_learnt/features/_profile/logic.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../entities/StatisticsModel.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';

class StatisticsPage extends StatelessWidget {
  StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<ProfileLogic>().getStatistics();
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
                    'Statistics'.tr,
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
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                child: GetBuilder<ProfileLogic>(
                    init: Get.find<ProfileLogic>(),
                    id: 'statistics',
                    builder: (logic) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              'Profile report'.tr,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 90.h,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 150.w,
                                        margin: const EdgeInsetsDirectional.only(end: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: const Color(0xff6149CD)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              '${logic.statisticsModel?.report?.profileViewsCount ?? 0}',
                                              fontSize: 22,
                                              color: Colors.white,
                                            ),
                                            CustomText(
                                              'Views'.tr,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 150.w,
                                        margin: const EdgeInsetsDirectional.only(end: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: const Color(0xffF96767)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              '${logic.statisticsModel?.report?.rating ?? 0}',
                                              fontSize: 22,
                                              color: Colors.white,
                                            ),
                                            CustomText(
                                              'Rate'.tr,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 150.w,
                                        margin: const EdgeInsetsDirectional.only(end: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: orangeColor),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              '${logic.statisticsModel?.report?.completeProfile ?? 0}%',
                                              fontSize: 22,
                                              color: Colors.white,
                                            ),
                                            CustomText(
                                              'Score'.tr,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              'Lessons And Students'.tr,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              'Hourly rate'.tr,
                              color: secondaryColor,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 100.h,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: logic
                                      .statisticsModel?.lessons?.teacherSubject?.length,
                                  itemBuilder: (context, index) {
                                    TeacherSubject? teacher = logic
                                        .statisticsModel?.lessons?.teacherSubject?[index];
                                    return Container(
                                      width: 150.w,
                                      margin: const EdgeInsetsDirectional.only(end: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.grey.shade200),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            '\$${teacher?.hourlyRate ?? 0} /hr',
                                            fontSize: 22,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          CustomText(
                                            teacher?.subject?.name?.en,
                                            fontSize: 16,
                                            color: Colors.grey.shade800,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              'Total Students'.tr,
                              color: secondaryColor,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: secondaryColor.withOpacity(0.2),
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                            '${logic.statisticsModel?.lessons?.totalStudents ?? 0}'),
                                        CustomText(
                                          'All'.tr,
                                          color: Colors.grey,
                                        )
                                      ],
                                    )
                                  ],
                                )),
                                Expanded(
                                    child: Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      color: secondaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                            '${logic.statisticsModel?.lessons?.totalStudentsNew ?? 0}'),
                                        CustomText(
                                          'New'.tr,
                                          color: Colors.grey,
                                        )
                                      ],
                                    )
                                  ],
                                )),
                                Expanded(
                                    child: SizedBox(
                                  height: 120.h,
                                  child: SfCircularChart(
                                      margin: EdgeInsets.zero,
                                      series: <CircularSeries>[
                                        DoughnutSeries<ChartData, String>(
                                            dataSource: [
                                              ChartData(
                                                  'New'.tr,
                                                  (logic.statisticsModel?.lessons
                                                              ?.totalStudentsNew ??
                                                          0)
                                                      .toDouble(),
                                                  color: const Color(0xffDBECF8)),
                                              ChartData(
                                                  'Old'.tr,
                                                  ((logic.statisticsModel?.lessons
                                                                  ?.totalStudents ??
                                                              0) -
                                                          (logic.statisticsModel?.lessons
                                                                  ?.totalStudentsNew ??
                                                              0))
                                                      .toDouble(),
                                                  color: const Color(0xff2C82BE))
                                            ],
                                            pointColorMapper: (ChartData data, _) =>
                                                data.color,
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y)
                                      ]),
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              'Total Lessons'.tr,
                              color: secondaryColor,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: secondaryColor.withOpacity(0.2),
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                                '${logic.statisticsModel?.lessons?.absences ?? '0'}'),
                                            CustomText(
                                              'Absences'.tr,
                                              color: Colors.grey,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: secondaryColor.withOpacity(0.2),
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                                '${logic.statisticsModel?.lessons?.canceledLessons ?? '0'}'),
                                            CustomText(
                                              'Canceled lessons'.tr,
                                              color: Colors.grey,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: secondaryColor.withOpacity(0.2),
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                                '${logic.statisticsModel?.lessons?.totalBooks ?? '0'} ' +
                                                    'Hours per week'.tr),
                                            CustomText(
                                              'Availability'.tr,
                                              color: Colors.grey,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: SizedBox(
                                  height: 180.h,
                                  child: SfCircularChart(
                                      margin: EdgeInsets.zero,
                                      series: <CircularSeries<ChartData, String>>[
                                        RadialBarSeries<ChartData, String>(
                                            dataSource: [
                                              ChartData(
                                                  '',
                                                  (logic.statisticsModel?.lessons
                                                              ?.absences ??
                                                          0)
                                                      .toDouble(),
                                                  color: const Color(0xff76DDFB)),
                                              ChartData(
                                                  '',
                                                  (logic.statisticsModel?.lessons
                                                              ?.canceledLessons ??
                                                          0)
                                                      .toDouble(),
                                                  color: const Color(0xffDBECF8)),
                                              ChartData(
                                                  '',
                                                  (logic.statisticsModel?.lessons
                                                              ?.totalBooks ??
                                                          0)
                                                      .toDouble(),
                                                  color: const Color(0xff2C82BE))
                                            ],
                                            xValueMapper: (ChartData data, _) => data.x,
                                            yValueMapper: (ChartData data, _) => data.y,
                                            pointColorMapper: (ChartData data, _) =>
                                                data.color,
                                            cornerStyle: CornerStyle.bothCurve,
                                            useSeriesColor: true,
                                            trackOpacity: 0.2,
                                            trackColor: Colors.white)
                                      ]),
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SfCartesianChart(series: <ChartSeries>[
                              SplineSeries<ChartData2, int>(
                                  dataSource: mapIndexed(
                                      logic.statisticsModel?.lessons?.newStuStatstic ??
                                          [],
                                      (index, item) => ChartData2(
                                          index, double.parse(item.toString()))).toList(),
                                  color: Colors.green,
                                  xValueMapper: (ChartData2 data, _) => data.x,
                                  yValueMapper: (ChartData2 data, _) => data.y),
                              SplineSeries<ChartData2, int>(
                                  dataSource: mapIndexed(
                                      logic.statisticsModel?.lessons
                                              ?.lastMonthStuStatstic ??
                                          [],
                                      (index, item) => ChartData2(
                                          index, double.parse(item.toString()))).toList(),
                                  color: Colors.blue,
                                  xValueMapper: (ChartData2 data, _) => data.x,
                                  yValueMapper: (ChartData2 data, _) => data.y),
                            ]),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              'Active student'.tr,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  iconColor,
                                  scale: 2,
                                  color: Colors.blue,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText('Last Month'.tr),
                                    CustomText(
                                      '${logic.statisticsModel?.lessons?.totalStudentsLastMonth ?? 0}',
                                      fontWeight: FontWeight.bold,
                                    )
                                  ],
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  margin: const EdgeInsets.symmetric(horizontal: 20),
                                  color: Colors.grey,
                                ),
                                Image.asset(
                                  iconColor,
                                  scale: 2,
                                  color: Colors.green,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText('This Month'.tr),
                                    CustomText(
                                      '${logic.statisticsModel?.lessons?.totalStudentsLastMonth ?? 0}',
                                      fontWeight: FontWeight.bold,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomText(
                              'Profile score'.tr,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Column(
                                  children: logic.statisticsModel?.report
                                          ?.completeMassages?.entries
                                          .map((e) => Padding(
                                                padding:
                                                    const EdgeInsets.only(bottom: 10),
                                                child: CustomText(
                                                  e.value,
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ))
                                          .toList() ??
                                      [],
/*                                  children: [
                                    Row(
                                      children: [
                                        CustomText(
                                          'Profile description'.tr,
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          '+15%'.tr,
                                          fontSize: 12,
                                          color: secondaryColor.withOpacity(0.8),
                                          fontWeight: FontWeight.bold,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        CustomText(
                                          'Teaching certification'.tr,
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          '+15%'.tr,
                                          fontSize: 12,
                                          color: secondaryColor.withOpacity(0.8),
                                          fontWeight: FontWeight.bold,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        CustomText(
                                          'upload image'.tr,
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          '+15%'.tr,
                                          fontSize: 12,
                                          color: secondaryColor.withOpacity(0.8),
                                          fontWeight: FontWeight.bold,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],*/
                                )),
                                Expanded(
                                  child: SizedBox(
                                    height: 150.h,
                                    child: SfCircularChart(
                                        margin: EdgeInsets.zero,
                                        annotations: <CircularChartAnnotation>[
                                          CircularChartAnnotation(
                                              widget: CustomText(
                                            '${logic.statisticsModel?.report?.completeProfile ?? 0}%',
                                            color: secondaryColor,
                                            fontWeight: FontWeight.bold,
                                          ))
                                        ],
                                        series: <CircularSeries>[
                                          DoughnutSeries<ChartData, String>(
                                              dataSource: [
                                                ChartData(
                                                    '',
                                                    (logic.statisticsModel?.report
                                                                ?.completeProfile ??
                                                            0)
                                                        .toDouble(),
                                                    color: const Color(0xff2C82BE)),
                                                ChartData(
                                                    '',
                                                    (100 -
                                                            (logic.statisticsModel?.report
                                                                    ?.completeProfile ??
                                                                0))
                                                        .toDouble(),
                                                    color: Colors.white),
                                              ],
                                              xValueMapper: (ChartData data, _) => data.x,
                                              yValueMapper: (ChartData data, _) => data.y,
                                              pointColorMapper: (ChartData data, _) =>
                                                  data.color,
                                              cornerStyle: CornerStyle.bothCurve,
                                              radius: '80%')
                                        ]),
                                  ),
                                )
                              ],
                            ),
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
      ),
    );
  }

  final List<ChartData> chartData4 = [
    ChartData('0', 60, color: Color(0xff2C82BE)),
    ChartData('1', 50, color: Color(0xff2C82BE)),
    ChartData('3', 5, color: Color(0xff2C82BE)),
    ChartData('5', 90, color: Color(0xff2C82BE)),
  ];
}

Float64List _resolveTransform(Rect bounds, TextDirection textDirection) {
  final GradientTransform transform = GradientRotation(_degreeToRadian(-90));
  return transform.transform(bounds, textDirection: textDirection)!.storage;
}

// Convert degree to radian
double _degreeToRadian(int deg) => deg * (3.141592653589793 / 180);

class ChartData {
  ChartData(this.x, this.y, {required this.color});

  final String x;
  final double y;
  final Color color;
}

class ChartData2 {
  ChartData2(this.x, this.y);

  final int x;
  final double y;
}
