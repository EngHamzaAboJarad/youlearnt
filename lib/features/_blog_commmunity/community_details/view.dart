import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:you_learnt/entities/CommonModel.dart';
import 'package:you_learnt/features/_profile/view_profile/view.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';

import '../../../constants/colors.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/custom_widget/custom_text_field.dart';
import '../../_main/logic.dart';
import '../../_main/widgets/header_widget.dart';
import '../../report/view.dart';
import '../profile_community/logic.dart';

class CommunityDetailsPage extends StatelessWidget {
  final CommonModel item;

  const CommunityDetailsPage(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<ProfileCommunityLogic>().getCommunityDetails(item.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () => Get.to(ReportPage(
                    id: item.userId,
                  )),
              icon: const Icon(
                Icons.report,
                color: Colors.white,
              ))
        ],
      ),
      body: Container(
        color: secondaryColor,
        child: Column(
          children: [
            HeaderWidget(titleBig: 'Community'.tr, titleSmall: ''.tr),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                child: GetBuilder<ProfileCommunityLogic>(
                    init: Get.find<ProfileCommunityLogic>(),
                    builder: (logic) {
                      return logic.isDetailsLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (item.user?.type != 'student') {
                                            Get.to(
                                                ViewProfilePage(slug: item.user?.slug));
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(30.sp),
                                              child: CustomImage(
                                                url: item.user?.imageUrl,
                                                height: 35.sp,
                                                width: 35.sp,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  item.user?.fullName,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                CustomText(
                                                  item.date,
                                                  fontSize: 12,
                                                  color: greyTextColor,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      CustomText(
                                        item.title,
                                        color: secondaryColor,
                                        fontSize: 16,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (item.tags?.isNotEmpty == true)
                                        SizedBox(
                                          height: 30.h,
                                          child: ListView.builder(
                                              itemCount: item.tags?.length ?? 0,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) =>
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.back();
                                                      logic.changeSelectedTag(
                                                          item.tags?[index]);
                                                    },
                                                    child: Container(
                                                      margin: const EdgeInsetsDirectional
                                                          .only(end: 10),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(15),
                                                          color: secondaryColor
                                                              .withOpacity(0.1)),
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                      child: CustomText(
                                                        item.tags?[index].name,
                                                        color: secondaryColor,
                                                      ),
                                                    ),
                                                  )),
                                        ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      HtmlWidget(
                                        item.description ?? '',
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomText(
                                        'Comments'.tr,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              logic.communityModel?.comments?.length ?? 0,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) =>
                                              buildComment(logic, index)),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(60.w),
                                            child: CustomImage(
                                              url: Get.find<MainLogic>()
                                                  .userModel
                                                  ?.imageUrl,
                                              width: 55.w,
                                              height: 55.w,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: CustomTextField(
                                              hintText: 'Write comment'.tr,
                                              fontSize: 14,
                                              controller: logic.commentController,
                                              height: 100.h,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomButtonWidget(
                                          title: 'Add Comment'.tr,
                                          loading: logic.isAddCommentLoading,
                                          textSize: 12,
                                          onTap: () =>
                                              logic.addCommunityComment(item.id)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      if (logic.communityModel?.related?.isNotEmpty ==
                                          true)
                                        CustomText(
                                          'Related Articles'.tr,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      if (logic.communityModel?.related?.isNotEmpty ==
                                          true)
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      if (logic.communityModel?.related?.isNotEmpty ==
                                          true)
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                logic.communityModel?.related?.length ??
                                                    0,
                                            itemBuilder: (context, index) {
                                              var itemRelated =
                                                  logic.communityModel?.related?[index];
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.grey.shade300),
                                                ),
                                                padding: const EdgeInsets.all(15),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 35.h,
                                                      child: ListView.builder(
                                                          itemCount:
                                                              itemRelated?.tags?.length ??
                                                                  0,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder: (context, index) =>
                                                              Container(
                                                                margin:
                                                                    const EdgeInsetsDirectional
                                                                        .only(end: 10),
                                                                alignment:
                                                                    Alignment.center,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(15),
                                                                    color: secondaryColor
                                                                        .withOpacity(
                                                                            0.1)),
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal: 10,
                                                                    vertical: 5),
                                                                child: CustomText(
                                                                  itemRelated
                                                                      ?.tags?[index].name,
                                                                  color: secondaryColor,
                                                                ),
                                                              )),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    CustomText(
                                                      itemRelated?.title,
                                                      color: secondaryColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    CustomText(
                                                      itemRelated?.description,
                                                      color: greyTextColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  30.sp),
                                                          child: CustomImage(
                                                            url: itemRelated
                                                                ?.user?.imageUrl,
                                                            height: 35.sp,
                                                            width: 35.sp,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            CustomText(
                                                              itemRelated?.user?.fullName,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            CustomText(
                                                              itemRelated?.date,
                                                              fontSize: 12,
                                                              color: greyTextColor,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            }),
                                      const SizedBox(
                                        height: 20,
                                      ),
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

  GetBuilder<ProfileCommunityLogic> buildComment(ProfileCommunityLogic logic, int index) {
    return GetBuilder<ProfileCommunityLogic>(
        id: logic.communityModel?.comments?[index].id.toString(),
        builder: (logic) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60.w),
                  child: CustomImage(
                    url: logic.communityModel?.comments?[index].user?.imageUrl,
                    width: 55.w,
                    height: 55.w,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(logic.communityModel?.comments?[index].user?.fullName),
                      CustomText(
                        logic.communityModel?.comments?[index].comment,
                        color: Colors.grey.shade500,
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: !logic.isCommentLoading
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      logic.communityModel?.comments?[index].date,
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                    logic.isCommentLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 1,
                            )))
                        : Row(
                            children: [
                              CustomText(logic.communityModel?.comments?[index].countLiked
                                  .toString()),
                              IconButton(
                                  onPressed: () => logic.addLikeOnComment(
                                      logic.communityModel?.id,
                                      logic.communityModel?.comments?[index].id),
                                  icon: const Icon(Icons.favorite_rounded)),
                            ],
                          )
                  ],
                )
              ],
            ),
          );
        });
  }
}
