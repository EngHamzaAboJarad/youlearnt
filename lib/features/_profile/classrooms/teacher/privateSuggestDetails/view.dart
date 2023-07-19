import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/core/helper_methods.dart';
import 'package:you_learnt/features/_profile/classrooms/logic.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';

import '../../../../../constants/colors.dart';
import '../../../../../entities/suggetsBookModel.dart';
import '../../../../../utils/custom_widget/custom_button_widget.dart';
import '../../../../../utils/custom_widget/custom_text.dart';
import '../../../logic.dart';

class PrivateSuggestDetails extends StatefulWidget {
  const PrivateSuggestDetails({
    Key? key,
    required this.suggetsBookModel,
  }) : super(key: key);

  @override
  State<PrivateSuggestDetails> createState() => _PrivateSuggestDetailsState();
  final SuggetsBookModel? suggetsBookModel;
}

class _PrivateSuggestDetailsState extends State<PrivateSuggestDetails> {
  final HelperMethods _helperMethods = HelperMethods();

  ProfileLogic profileLogic = Get.find<ProfileLogic>();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // executes after build

    // });
    Get.find<ClassroomsLogic>()
        .getTeacherPrivateSuggestDetails(widget.suggetsBookModel!.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.find<ClassroomsLogic>().closeAllOpentoggeldMenues();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: secondaryColor,
            centerTitle: false,
            title: CustomText(
              "Suggest Book".tr,
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: GetBuilder<ClassroomsLogic>(
            id: "delete-suggest",
            builder: (logic) {
              return Container(
                color: secondaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25))),
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
                              : logic.teacherSuggetsBookDetails == null
                                  ? Center(
                                      child: CustomText(
                                        "No Suggest details!".tr,
                                        fontSize: 20,
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: SingleChildScrollView(
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
                                                          BorderRadius.circular(
                                                              30.sp),
                                                      child: CustomImage(
                                                        url: logic
                                                            .teacherSuggetsBookDetails!
                                                            .userModel!
                                                            .imageUrl,
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
                                                                .teacherSuggetsBookDetails!
                                                                .userModel!
                                                                .fullName,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Wrap(
                                                direction: Axis.horizontal,
                                                spacing: 5,
                                                children: [
                                                  Chip(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      backgroundColor:
                                                          mainColor,
                                                      label: CustomText(
                                                        "status : ".tr +
                                                            logic
                                                                .teacherSuggetsBookDetails!
                                                                .status
                                                                .toString(),
                                                        color: Colors.white,
                                                      )),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Divider(),
                                              CustomText(
                                                "Suggest Book".tr,
                                                fontSize: 20,
                                              ),
                                              Card(
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(8),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    // border: Border.all(
                                                    //     color: Colors
                                                    //         .grey.shade300),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: CustomText(
                                                              "Start at : ".tr +
                                                                  _helperMethods.convertSuggestBookDate(logic
                                                                      .teacherSuggetsBookDetails!
                                                                      .startAt
                                                                      .toString()),
                                                              color:
                                                                  secondaryColor,
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
                                                            _helperMethods
                                                                .convertSuggestBookDate(logic
                                                                    .teacherSuggetsBookDetails!
                                                                    .endAt
                                                                    .toString()),
                                                        color: mainColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Divider(),
                                            ],
                                          ),
                                        )),
                                        if (logic.teacherSuggetsBookDetails!
                                                .status ==
                                            "pending")
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                bottom: 30.h),
                                            child: CustomButtonWidget(
                                                title: 'Delete'.tr,
                                                loading:
                                                    logic.isUpdatingReschdule,
                                                onTap: () {
                                                  _helperMethods.showAlertDilog(
                                                      message:
                                                          "Are you sure to delete this Suggest book?",
                                                      title: "Alert!".tr,
                                                      context: context,
                                                      function: () {
                                                        logic.deleteTeacherSuggestBook(
                                                            logic
                                                                .teacherSuggetsBookDetails!
                                                                .id);
                                                      });
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
            },
          )),
    );
  }
}
