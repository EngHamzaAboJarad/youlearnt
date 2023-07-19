import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:you_learnt/core/helper_methods.dart';
import 'package:you_learnt/utils/functions.dart';

import '../../../constants/colors.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../add_community/view.dart';
import 'logic.dart';

class ProfileCommunityPage extends StatelessWidget {
  ProfileCommunityPage({Key? key}) : super(key: key);

  final HelperMethods _helperMethods = HelperMethods();

  @override
  Widget build(BuildContext context) {
    Get.find<ProfileCommunityLogic>().getCommunity();
    return GestureDetector(
      onTap: () {
        Get.find<ProfileCommunityLogic>().closeAllOpentoggeldMenues();
      },
      child: Scaffold(
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
                      'Community (Q&A)'.tr,
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
                  child: GetBuilder<ProfileCommunityLogic>(builder: (logic) {
                    return logic.isLoading
                        ? const SizedBox(
                            child: Center(
                                child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ))))
                        : Column(
                            children: [
                              Expanded(
                                child: logic.communityList.isEmpty
                                    ? Center(
                                        child: CustomText(
                                            "No community posts.".tr),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: logic.communityList.length,
                                        itemBuilder: (context, index) => Stack(
                                              children: [
                                                InkWell(
                                                  onTap: () =>
                                                      logic.goToDetails(
                                                          logic.communityList[
                                                              index]),
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        CustomText(
                                                                      logic
                                                                          .communityList[
                                                                              index]
                                                                          .title,
                                                                      color:
                                                                          secondaryColor,
                                                                    ),
                                                                  ),
                                                                  GestureDetector(
                                                                      onTap: () =>
                                                                          logic.toggleMenu(logic.communityList[
                                                                              index]),
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .more_vert_outlined,
                                                                        color: Colors
                                                                            .grey,
                                                                      ))
                                                                ],
                                                              ),
                                                              if (logic
                                                                      .communityList[
                                                                          index]
                                                                      .createdAt !=
                                                                  null)
                                                                CustomText(
                                                                  DateFormat().format(DateTime.parse(logic
                                                                      .communityList[
                                                                          index]
                                                                      .createdAt!)),
                                                                  fontSize: 12,
                                                                  color:
                                                                      greyTextColor,
                                                                ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              CustomText(
                                                                parseHtmlString(logic
                                                                    .communityList[
                                                                        index]
                                                                    .description),
                                                                color:
                                                                    greyTextColor,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .only(
                                                                  start: 10),
                                                          child: Wrap(
                                                            children: logic
                                                                    .communityList[
                                                                        index]
                                                                    .tags
                                                                    ?.map((e) =>
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsetsDirectional.only(end: 10),
                                                                          child:
                                                                              CustomText(
                                                                            '#${e.name}'.replaceAll('##',
                                                                                '#'),
                                                                            color:
                                                                                primaryColor,
                                                                          ),
                                                                        ))
                                                                    .toList() ??
                                                                [],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                PositionedDirectional(
                                                  end: 0,
                                                  top: 0,
                                                  child: AnimatedSize(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsetsDirectional
                                                                  .only(
                                                              end: 20, top: 5),
                                                      width: logic
                                                              .communityList[
                                                                  index]
                                                              .isSelected
                                                          ? 110.w
                                                          : 0,
                                                      height: logic
                                                              .communityList[
                                                                  index]
                                                              .isSelected
                                                          ? null
                                                          : 0,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 0.5)),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () => logic
                                                                .editCommunity(
                                                                    logic.communityList[
                                                                        index]),
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: CustomText(
                                                                'Edit'.tr,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 0.5,
                                                            color: Colors.grey,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              _helperMethods
                                                                  .showAlertDilog(
                                                                      message:
                                                                          "Are you sure to delete this post?"
                                                                              .tr,
                                                                      title:
                                                                          "Alert!"
                                                                              .tr,
                                                                      context:
                                                                          context,
                                                                      function:
                                                                          () {
                                                                        logic.deleteCommunity(logic
                                                                            .communityList[index]
                                                                            .id);
                                                                      });
                                                            },
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: CustomText(
                                                                'Delete'.tr,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 30.h),
                                child: CustomButtonWidget(
                                  title: 'Add Q&A'.tr,
                                  onTap: () => Get.to(AddCommunityPage(
                                    edit: false,
                                  )),
                                ),
                              ),
                            ],
                          );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
