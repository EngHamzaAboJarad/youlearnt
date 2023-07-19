import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/core/helper_methods.dart';

import '../../../../../constants/colors.dart';
import '../../../../../utils/custom_widget/custom_text.dart';
import '../../logic.dart';
import '../suggstedBooks/view.dart';

class SuggetStudentBooksPage extends StatelessWidget {
  SuggetStudentBooksPage({Key? key}) : super(key: key);

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
                        : logic.teacherSuggetsBookLists.isEmpty
                            ? Center(
                                child: CustomText(
                                  "No sugget books".tr,
                                  fontSize: 20,
                                ),
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      controller:
                                          logic.teacherSuggetsController,
                                      itemCount:
                                          logic.teacherSuggetsBookLists.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Get.to(StudentSuggstedBooksDetails(
                                              suggetsBookModel:
                                                  logic.teacherSuggetsBookLists[
                                                      index],
                                            ));
                                            // logic.goToStudentReschduledBooksDetails(
                                            //     logic.teacherSuggetsBookLists[
                                            //         index]);
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
                                                              _helperMethods
                                                                  .convertSuggestBookDate(logic
                                                                      .teacherSuggetsBookLists[
                                                                          index]
                                                                      .startAt
                                                                      .toString()),
                                                          color: secondaryColor,
                                                        ),
                                                      ),
                                                      CustomText(
                                                        logic
                                                            .teacherSuggetsBookLists[
                                                                index]
                                                            .status,
                                                        color: _helperMethods
                                                            .handleStatusColor(logic
                                                                .teacherSuggetsBookLists[
                                                                    index]
                                                                .status),
                                                      )
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
                                                        _helperMethods
                                                            .convertSuggestBookDate(logic
                                                                .teacherSuggetsBookLists[
                                                                    index]
                                                                .endAt
                                                                .toString()),
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
