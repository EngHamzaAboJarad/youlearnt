import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:you_learnt/features/_profile/logic.dart';
import 'package:you_learnt/utils/custom_widget/custom_button_widget.dart';

import '../../../constants/colors.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'logic.dart';

class WithdrawPage extends StatelessWidget {
  final bool isStudent;

  const WithdrawPage({Key? key, required this.isStudent}) : super(key: key);

  // final withDrawDepostLogic = Get.put(WithdrawDepositLogic());

  @override
  Widget build(BuildContext context) {
    Get.find<ProfileLogic>().getWithdraw();
    //  Get.find<WithdrawDepositLogic>().transactionList.clear();
    Get.find<WithdrawDepositLogic>().getTransctionList(true);
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
                    isStudent ? 'Payments' : 'Withdraw'.tr,
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
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25))),
                child: GetBuilder<ProfileLogic>(
                    init: Get.find<ProfileLogic>(),
                    id: 'withdraw',
                    builder: (logic) {
                      return logic.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  if (!isStudent)
                                    CustomText(
                                      'Profile report'.tr,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  if (!isStudent)
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  Container(
                                    width: double.infinity,
                                    height: 90.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: secondaryLightColor
                                            .withOpacity(0.5)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          isStudent
                                              ? 'Total Spent'.tr
                                              : 'Balance'.tr,
                                          fontSize: 16,
                                        ),
                                        CustomText(
                                          '${logic.withdrawModel?.balance ?? 0}\$',
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    isStudent ? 'Payments'.tr : 'Earnings'.tr,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SfCartesianChart(
                                      primaryXAxis: CategoryAxis(),
                                      series: <ColumnSeries<ChartData, String>>[
                                        ColumnSeries<ChartData, String>(
                                          dataSource: [
                                            ChartData(
                                                DateFormat()
                                                    .add_E()
                                                    .format(DateTime.now()),
                                                logic.withdrawModel?.statistic
                                                        ?.day0 ??
                                                    0),
                                            ChartData(
                                                DateFormat().add_E().format(
                                                    DateTime.now().subtract(
                                                        const Duration(
                                                            days: 1))),
                                                logic.withdrawModel?.statistic
                                                        ?.day1 ??
                                                    0),
                                            ChartData(
                                                DateFormat().add_E().format(
                                                    DateTime.now().subtract(
                                                        const Duration(
                                                            days: 2))),
                                                logic.withdrawModel?.statistic
                                                        ?.day2 ??
                                                    0),
                                            ChartData(
                                                DateFormat().add_E().format(
                                                    DateTime.now().subtract(
                                                        const Duration(
                                                            days: 3))),
                                                logic.withdrawModel?.statistic
                                                        ?.day3 ??
                                                    0),
                                            ChartData(
                                                DateFormat().add_E().format(
                                                    DateTime.now().subtract(
                                                        const Duration(
                                                            days: 4))),
                                                logic.withdrawModel?.statistic
                                                        ?.day4 ??
                                                    0),
                                            ChartData(
                                                DateFormat().add_E().format(
                                                    DateTime.now().subtract(
                                                        const Duration(
                                                            days: 5))),
                                                logic.withdrawModel?.statistic
                                                        ?.day5 ??
                                                    0),
                                            ChartData(
                                                DateFormat().add_E().format(
                                                    DateTime.now().subtract(
                                                        const Duration(
                                                            days: 6))),
                                                logic.withdrawModel?.statistic
                                                        ?.day6 ??
                                                    0),
                                          ],
                                          xValueMapper: (ChartData data, _) =>
                                              data.x,
                                          yValueMapper: (ChartData data, _) =>
                                              data.y,
                                        )
                                      ]),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              isStudent
                                                  ? 'Your payments this month'
                                                      .tr
                                                  : 'Your earnings this month'
                                                      .tr,
                                              fontSize: 12,
                                              color: greyTextColor,
                                            ),
                                            CustomText(
                                              DateFormat()
                                                  .format(DateTime.now()),
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomText(
                                          '${logic.withdrawModel?.totalEarningCanDrow ?? 0}\$'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomText(
                                    'Transaction'.tr,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // Transaction section
                                  // final withDrawDepostLogic = Get.put(WithdrawDepositLogic());
                                  GetBuilder<WithdrawDepositLogic>(
                                      init: Get.find<WithdrawDepositLogic>(),
                                      id: 'transction',
                                      builder: (withDrawDepostLogic) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              'Choose status and type'.tr,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Wrap(
                                                    spacing: 5.0,
                                                    children:
                                                        List<Widget>.generate(
                                                      withDrawDepostLogic
                                                          .transactionStatusTypeList
                                                          .length,
                                                      (int index) {
                                                        return Container(
                                                          // width: 81,
                                                          child: ChoiceChip(
                                                            backgroundColor:
                                                                withDrawDepostLogic
                                                                            .selectedTransactionStatusTypeIndex ==
                                                                        index
                                                                    ? mainColor
                                                                    : secondaryColor,
                                                            selectedColor:
                                                                withDrawDepostLogic
                                                                            .selectedTransactionStatusTypeIndex ==
                                                                        index
                                                                    ? mainColor
                                                                    : secondaryColor,
                                                            // selectedColor: ,
                                                            side: BorderSide(
                                                              width: withDrawDepostLogic
                                                                          .selectedTransactionStatusTypeIndex ==
                                                                      index
                                                                  ? 2
                                                                  : 1,
                                                              color: withDrawDepostLogic
                                                                          .selectedTransactionStatusTypeIndex ==
                                                                      index
                                                                  ? mainColor
                                                                  : secondaryColor,
                                                            ),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                            ),
                                                            // padding: EdgeInsets.all(8),
                                                            label: SizedBox(
                                                              // width: 50,
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Visibility(
                                                                    visible: withDrawDepostLogic
                                                                            .selectedTransactionStatusTypeIndex ==
                                                                        index,
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  CustomText(
                                                                    withDrawDepostLogic
                                                                            .transactionStatusTypeList[
                                                                        index],
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 8,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            selected:
                                                                withDrawDepostLogic
                                                                        .selectedTransactionStatusTypeIndex ==
                                                                    index,
                                                            onSelected: (bool
                                                                selected) {
                                                              withDrawDepostLogic
                                                                  .onChangeStatusType(
                                                                      selected
                                                                          ? index
                                                                          : null);
                                                              // setState(() {
                                                              // _selectedRatingIndex =
                                                              //     selected ? index : null;
                                                              // });
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Wrap(
                                                    spacing: 5.0,
                                                    children:
                                                        List<Widget>.generate(
                                                      withDrawDepostLogic
                                                          .transactionypeList
                                                          .length,
                                                      (int index) {
                                                        return Container(
                                                          // width: 81,
                                                          child: ChoiceChip(
                                                            backgroundColor:
                                                                withDrawDepostLogic
                                                                            .selectedTransactionTypeIndex ==
                                                                        index
                                                                    ? mainColor
                                                                    : secondaryColor,
                                                            selectedColor:
                                                                withDrawDepostLogic
                                                                            .selectedTransactionTypeIndex ==
                                                                        index
                                                                    ? mainColor
                                                                    : secondaryColor,
                                                            // selectedColor: ,
                                                            side: BorderSide(
                                                              width: withDrawDepostLogic
                                                                          .selectedTransactionTypeIndex ==
                                                                      index
                                                                  ? 2
                                                                  : 1,
                                                              color: withDrawDepostLogic
                                                                          .selectedTransactionTypeIndex ==
                                                                      index
                                                                  ? mainColor
                                                                  : secondaryColor,
                                                            ),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                            ),
                                                            // padding: EdgeInsets.all(8),
                                                            label: SizedBox(
                                                              // width: 50,
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Visibility(
                                                                    visible: withDrawDepostLogic
                                                                            .selectedTransactionTypeIndex ==
                                                                        index,
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  CustomText(
                                                                    withDrawDepostLogic
                                                                            .transactionypeList[
                                                                        index],
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 8,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            selected:
                                                                withDrawDepostLogic
                                                                        .selectedTransactionTypeIndex ==
                                                                    index,
                                                            onSelected: (bool
                                                                selected) {
                                                              withDrawDepostLogic
                                                                  .onChangeTranctionsType(
                                                                      selected
                                                                          ? index
                                                                          : null);
                                                              // setState(() {
                                                              // _selectedRatingIndex =
                                                              //     selected ? index : null;
                                                              // });
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // transction table
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              // width: d,
                                              height: withDrawDepostLogic
                                                      .transactionList.isEmpty
                                                  ? 20
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                      width: 1)),
                                              child: withDrawDepostLogic
                                                      .isLoading
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                  : RefreshIndicator(
                                                      onRefresh: () async {
                                                        withDrawDepostLogic
                                                            .onRefresh();
                                                      },
                                                      child:
                                                          SingleChildScrollView(
                                                        // scrollDirection: Axis.horizontal,
                                                        // physics: const NeverScrollableScrollPhysics(),
                                                        controller:
                                                            withDrawDepostLogic
                                                                .transactionListController,
                                                        child: SizedBox(
                                                          // width: 1000,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          child: Scrollbar(
                                                            child:
                                                                SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    3,
                                                                child: Table(
                                                                    // defaultColumnWidth:
                                                                    //     const FixedColumnWidth(
                                                                    //         120.0),
                                                                    border: TableBorder.all(
                                                                        color: Colors
                                                                            .black,
                                                                        style: BorderStyle
                                                                            .solid,
                                                                        width:
                                                                            2),
                                                                    children: [
                                                                      if (withDrawDepostLogic
                                                                          .transactionList
                                                                          .isNotEmpty)
                                                                        const TableRow(
                                                                          children: [
                                                                            CustomText(
                                                                              "Transaction number",
                                                                              fontSize: 14,
                                                                              color: secondaryColor,
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            CustomText(
                                                                              "Amount",
                                                                              fontSize: 14,
                                                                              color: secondaryColor,
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            CustomText(
                                                                              "type",
                                                                              fontSize: 14,
                                                                              color: secondaryColor,
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            CustomText(
                                                                              "Status",
                                                                              fontSize: 14,
                                                                              color: secondaryColor,
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            CustomText(
                                                                              "Payment method",
                                                                              fontSize: 14,
                                                                              color: secondaryColor,
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ...withDrawDepostLogic
                                                                          .transactionList
                                                                          .map((tranctionItem) =>
                                                                              TableRow(
                                                                                children: [
                                                                                  CustomText(
                                                                                    tranctionItem.transctionNumber,
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  CustomText(
                                                                                    tranctionItem.transctionAmount,
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  CustomText(
                                                                                    tranctionItem.transctionType,
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  CustomText(
                                                                                    tranctionItem.transctionStatus,
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  CustomText(
                                                                                    tranctionItem.transctionPaymentMethod,
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                          .toList()
                                                                    ]
                                                                    //  const [
                                                                    // TableRow(children: [
                                                                    //     Text('Website',
                                                                    //         style: TextStyle(
                                                                    //             fontSize:
                                                                    //                 20.0)),
                                                                    //     Text('Website',
                                                                    //         style: TextStyle(
                                                                    //             fontSize:
                                                                    //                 20.0)),
                                                                    //     Text('Website',
                                                                    //         style: TextStyle(
                                                                    //             fontSize:
                                                                    //                 20.0))
                                                                    //   ]),
                                                                    // TableRow(
                                                                    //     children: withDrawDepostLogic
                                                                    //         .transactionList
                                                                    //         .map(
                                                                    //             (tranctionItem) =>
                                                                    //                 Column(
                                                                    //                   children: [
                                                                    //                     CustomText(tranctionItem.id),
                                                                    //                     CustomText(tranctionItem.transctionAmount),
                                                                    //                     CustomText(tranctionItem.transctionAmount),
                                                                    //                   ],
                                                                    //                 ))
                                                                    //         .toList()),
                                                                    // ],
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                              // ListView.builder(
                                              //     shrinkWrap: true,
                                              //     // physics:
                                              //     // const NeverScrollableScrollPhysics(),
                                              //     itemCount:
                                              //         withDrawDepostLogic
                                              //             .transactionList
                                              //             .length,
                                              //     itemBuilder:
                                              //         (BuildContext
                                              //                 context,
                                              //             int index) {
                                              //       return CustomText(
                                              //           withDrawDepostLogic
                                              //               .transactionList[
                                              //                   index]
                                              //               .transctionNumber);
                                              //     },
                                              //   ),
                                            ),
                                          ],
                                        );
                                      }),

                                  if (!isStudent)
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  if (!isStudent)
                                    GetBuilder<ProfileLogic>(
                                        id: 'withdraw_button',
                                        builder: (logic) {
                                          return CustomButtonWidget(
                                            title: 'Withdraw'.tr,
                                            loading: logic.isLoading,
                                            onTap: () => logic.withdraw(),
                                            textSize: 14,
                                            fontWeight: FontWeight.bold,
                                          );
                                        }),
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
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}
