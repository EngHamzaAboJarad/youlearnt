import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/core/helper_methods.dart';

import '../../../../../constants/colors.dart';
import '../../../../../utils/custom_widget/custom_image.dart';
import '../../../../../utils/custom_widget/custom_text.dart';
import '../../logic.dart';

class StudentCancelledBooksPage extends StatefulWidget {
  const StudentCancelledBooksPage({Key? key}) : super(key: key);

  @override
  State<StudentCancelledBooksPage> createState() =>
      _StudentCancelledBooksPageState();
}

class _StudentCancelledBooksPageState extends State<StudentCancelledBooksPage> {
  final HelperMethods _helperMethods = HelperMethods();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<ClassroomsLogic>().getStudentsCancelledBooks();
    });
  }

  String handleType(String type) {
    switch (type) {
      case "cancelled":
        return "Cancelled";
      case "unable_to_attend":
        return "Unable to attend";
      default:
        return type;
    }
  }

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
                        : logic.studentCancelledBooksList.isEmpty
                            ? Center(
                                child: CustomText(
                                  "No canceled books".tr,
                                  fontSize: 20,
                                ),
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      // controller:
                                      //     logic.teacherSuggetsController,
                                      itemCount: logic
                                          .studentCancelledBooksList.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            // Get.to(StudentSuggstedBooksDetails(
                                            //   suggetsBookModel:
                                            //       logic.teacherSuggetsBookLists[
                                            //           index],
                                            // ));
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
                                                  GestureDetector(
                                                    onTap: () {
                                                      // if (item.user?.type != 'student') {
                                                      //   Get.to(ViewProfilePage(
                                                      //       slug: item.user?.slug));
                                                      // }
                                                    },
                                                    // user header
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.sp),
                                                          child: CustomImage(
                                                            url: logic
                                                                .studentCancelledBooksList[
                                                                    index]
                                                                .teacherImage,
                                                            height: 35.sp,
                                                            fit: BoxFit.cover,
                                                            width: 35.sp,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              CustomText(
                                                                logic
                                                                    .studentCancelledBooksList[
                                                                        index]
                                                                    .teacherFullName,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              CustomText(
                                                                handleType(logic
                                                                    .studentCancelledBooksList[
                                                                        index]
                                                                    .type),
                                                                color: _helperMethods
                                                                    .handleStatusColor(logic
                                                                        .studentCancelledBooksList[
                                                                            index]
                                                                        .type),
                                                                fontSize: 12,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: CustomText(
                                                          "Start at : ".tr +
                                                              logic
                                                                  .studentCancelledBooksList[
                                                                      index]
                                                                  .startAt,
                                                          color: secondaryColor,
                                                        ),
                                                      ),
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
                                                            .studentCancelledBooksList[
                                                                index]
                                                            .startAt,
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
              // if (logic.loadMoreItems)
              //   Container(
              //       height: 50,
              //       color: Colors.white,
              //       child: const Center(
              //           child: SizedBox(
              //               height: 30,
              //               width: 30,
              //               child: CircularProgressIndicator(
              //                 strokeWidth: 2,
              //               ))))
            ],
          ),
        );
      },
    );
  }
}
