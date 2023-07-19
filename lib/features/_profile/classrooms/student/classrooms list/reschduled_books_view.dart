import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/core/helper_methods.dart';

import '../../../../../constants/colors.dart';
import '../../../../../utils/custom_widget/custom_text.dart';
import '../../logic.dart';

class ReschduldedStudentsBooksPage extends StatelessWidget {
  ReschduldedStudentsBooksPage({Key? key}) : super(key: key);

  final HelperMethods _helperMethods = HelperMethods();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClassroomsLogic>(
      builder: (logic) {
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
                    //     topRight: Radius.circular(25),
                    //     topLeft: Radius.circular(25))
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
                        : logic.studentRescduleBooksList.isEmpty
                            ? Center(
                                child: CustomText(
                                  "No rescheduled books".tr,
                                  fontSize: 20,
                                ),
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      controller: logic
                                          .studentReschduldedBookistController,
                                      itemCount:
                                          logic.studentRescduleBooksList.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            logic.goToStudentReschduledBooksDetails(
                                                logic.studentRescduleBooksList[
                                                    index]);
                                          },
                                          child: Card(
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Container(
                                              margin: const EdgeInsets.all(8),
                                              padding: const EdgeInsets.all(8),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                // border: Border.all(
                                                //     color: Colors
                                                //         .grey.shade300),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: CustomText(
                                                          "Start at : ".tr +
                                                              logic
                                                                  .studentRescduleBooksList[
                                                                      index]
                                                                  .startAt
                                                                  .toString(),
                                                          color: secondaryColor,
                                                        ),
                                                      ),
                                                      CustomText(
                                                        logic
                                                            .studentRescduleBooksList[
                                                                index]
                                                            .status,
                                                        color: _helperMethods
                                                            .handleStatusColor(logic
                                                                .studentRescduleBooksList[
                                                                    index]
                                                                .status),
                                                      )
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
                                                    "End at : ".tr +
                                                        logic
                                                            .studentRescduleBooksList[
                                                                index]
                                                            .endAt
                                                            .toString(),
                                                    color: mainColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
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
    );
  }
}
