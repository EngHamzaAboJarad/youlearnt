import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/core/helper_methods.dart';
import 'package:you_learnt/entities/PostModel.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';

import '../../../../../constants/colors.dart';
import '../../../../../utils/custom_widget/custom_button_widget.dart';
import '../../../../../utils/custom_widget/custom_text.dart';
import '../../../../../utils/functions.dart';
import '../../../logic.dart';

class ShowTeacherRequtesToStudentPage extends StatefulWidget {
  const ShowTeacherRequtesToStudentPage({Key? key, required this.postModel})
      : super(key: key);

  @override
  State<ShowTeacherRequtesToStudentPage> createState() =>
      _ShowTeacherRequtesToStudentPageState();
  final PostModel postModel;
}

class _ShowTeacherRequtesToStudentPageState
    extends State<ShowTeacherRequtesToStudentPage> {
  final HelperMethods _helperMethods = HelperMethods();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // executes after build

    // });
    Get.find<ProfileLogic>().getStudentReqestProposals(widget.postModel.id!);
  }

  Future<void> showTeacherAvalibaleOption({
    required BuildContext context,
    required PropaslPostModel propaslPostModel,
  }) async {
    await showDialog(
        context: context,
        builder: (ctx) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AlertDialog(
                  scrollable: true,
                  contentPadding: const EdgeInsets.all(8),
                  insetPadding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  title: Center(
                    child: CustomText(
                      "Choose a new book".tr,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: GetBuilder<ProfileLogic>(
                    id: "stdunt_offers_requests",
                    builder: (logic) {
                      //
                      return Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                          ),
                          Column(
                            children: List.generate(
                                logic.teacherAvalibleSuggstedBooks.length,
                                (index) {
                              return InkWell(
                                onTap: () {
                                  logic
                                      .onChangeSelectedtTeacherAvalibleSuggstedBooksType(
                                          index);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(12),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: logic
                                                .selectedtTeacherAvalibleSuggstedBooksIndex !=
                                            index
                                        ? Border.all(
                                            width: 1,
                                            color: Colors.grey.shade300)
                                        : Border.all(
                                            width: 2,
                                            color:
                                                logic.selectedtTeacherAvalibleSuggstedBooksIndex ==
                                                        index
                                                    ? secondaryColor
                                                    : Colors.grey.shade300),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (logic
                                              .teacherAvalibleSuggstedBooks[
                                                  index]
                                              .subjectName !=
                                          null)
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: CustomText(
                                            logic
                                                    .teacherAvalibleSuggstedBooks[
                                                        index]
                                                    .subjectName ??
                                                "",
                                            color: Colors.white,
                                          ),
                                        ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: CustomText(
                                              "Start at : ".tr +
                                                  _helperMethods
                                                      .convertSuggestBookDate(
                                                    logic
                                                        .teacherAvalibleSuggstedBooks[
                                                            index]
                                                        .start
                                                        .toString(),
                                                  ),
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
                                            _helperMethods
                                                .convertSuggestBookDate(logic
                                                    .teacherAvalibleSuggstedBooks[
                                                        index]
                                                    .end
                                                    .toString()),
                                        color: mainColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButtonWidget(
                                  title: 'close'.tr,
                                  // color: secondaryColor,
                                  loading: logic.updaingOfferRequest,
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: CustomButtonWidget(
                                  title: 'Choose'.tr,
                                  color: secondaryColor,
                                  loading: logic.updaingOfferRequest,
                                  onTap: () {
                                    // handle experiment here
                                    logic.handelExpermentalesson(
                                      context: context,
                                      propaslPostModel: propaslPostModel,
                                    );
                                    // Get.back();
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  )),
            ));
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
              'Offers'.tr,
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: GetBuilder<ProfileLogic>(
            id: "stdunt_offers_requests",
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
                        child: GetBuilder<ProfileLogic>(builder: (logic) {
                          return logic.isLoading
                              ? const SizedBox(
                                  child: Center(
                                      child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ))))
                              : logic.postDetailspage == null
                                  ? Center(
                                      child: CustomText(
                                        "No post details!".tr,
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
                                              CustomText(
                                                'Title'.tr,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              CustomText(
                                                logic.postDetailspage!.title,
                                                color: greyTextColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              CustomText(
                                                'Expected budget'.tr,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: mainColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: CustomText(
                                                  "\$${logic.postDetailspage!.startPrice ?? ''} - \$${logic.postDetailspage!.endPrice ?? ''}",
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              CustomText(
                                                'Details'.tr,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              logic.postDetailspage!
                                                          .description ==
                                                      null
                                                  ? Container()
                                                  : CustomText(
                                                      logic.postDetailspage!
                                                          .description,
                                                      color: greyTextColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Divider(),
                                              CustomText(
                                                "Offers".tr,
                                                fontSize: 20,
                                              ),
                                              logic.postDetailspage!
                                                      .propaslPostList.isEmpty
                                                  ? Center(
                                                      child: CustomText(
                                                          "No offers yet!".tr),
                                                    )
                                                  : Column(
                                                      children: List.generate(
                                                          logic
                                                              .postDetailspage!
                                                              .propaslPostList
                                                              .length,
                                                          (index) => Card(
                                                                elevation: 2,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(8),
                                                                  width: double
                                                                      .infinity,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    // border: Border.all(
                                                                    //     color: Colors
                                                                    //         .grey.shade300),
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          // if (item.user?.type != 'student') {
                                                                          //   Get.to(ViewProfilePage(
                                                                          //       slug: item.user?.slug));
                                                                          // }
                                                                        },
                                                                        // user header
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(30.sp),
                                                                              child: CustomImage(
                                                                                url: logic.postDetailspage!.propaslPostList[index].teacheImage,
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
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  CustomText(
                                                                                    logic.postDetailspage!.propaslPostList[index].teacherName,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            12,
                                                                      ),
                                                                      Wrap(
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        spacing:
                                                                            5,
                                                                        children: [
                                                                          Chip(
                                                                              padding: const EdgeInsets.all(8),
                                                                              backgroundColor: mainColor,
                                                                              label: CustomText(
                                                                                "Price : ".tr + logic.postDetailspage!.propaslPostList[index].price,
                                                                                color: Colors.white,
                                                                              )),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      CustomText(
                                                                        logic
                                                                            .postDetailspage!
                                                                            .propaslPostList[index]
                                                                            .description,
                                                                        color:
                                                                            greyTextColor,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            12,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: CustomButtonWidget(
                                                                                title: 'Reject'.tr,
                                                                                loading: logic.updaingOfferRequest,
                                                                                color: mainColor,
                                                                                // color: secondaryColor,
                                                                                onTap: () {
                                                                                  _helperMethods.showAlertDilog(
                                                                                    message: "Are you sure to reject this offer?",
                                                                                    title: "Alert!".tr,
                                                                                    context: context,
                                                                                    function: () {
                                                                                      logic.updateStudentReqestProposalsStatus(
                                                                                        requestId: logic.postDetailspage!.propaslPostList[index].id,
                                                                                        status: "rejected",
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                }),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Expanded(
                                                                            child: CustomButtonWidget(
                                                                                title: 'Accept'.tr,
                                                                                color: secondaryColor,
                                                                                loading: logic.updaingOfferRequest,
                                                                                onTap: () async {
                                                                                  // log(logic.postDetailspage!.propaslPostList[index].teacherSlug);
                                                                                  // return ;
                                                                                  await logic.updateStudentReqestProposalsStatus(
                                                                                    requestId: logic.postDetailspage!.propaslPostList[index].id,
                                                                                    status: "approved",
                                                                                  );

                                                                                  log(logic.postDetailspage!.id.toString());

                                                                                  if (logic.propaslTeacherSubjectId != null) {
                                                                                    // replaced it with the slug that come from the api
                                                                                    await logic.getTeacherAvalibleSuggstedBooks(
                                                                                      teacherSlug: logic.postDetailspage!.propaslPostList[index].teacherSlug,
                                                                                      teacherSubjectId: "",
                                                                                    );

                                                                                    if (logic.teacherAvalibleSuggstedBooks.isEmpty) {
                                                                                      showMessage("There are no other books!".tr, 2);
                                                                                    } else {
                                                                                      showTeacherAvalibaleOption(context: context, propaslPostModel: logic.postDetailspage!.propaslPostList[index]);
                                                                                    }
                                                                                  }
                                                                                  // AddNewClassRoomPage
                                                                                  //   Get.to(
                                                                                  // AddBlogPage(
                                                                                  //   edit: false,
                                                                                  // ),
                                                                                }),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              )),
                                                    ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        )),
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
