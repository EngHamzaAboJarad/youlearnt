import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:you_learnt/features/_blog_commmunity/profile_blog/logic.dart';
import 'package:you_learnt/features/_blog_commmunity/widgets/item_blog.dart';
import 'package:you_learnt/features/_main/logic.dart';
import 'package:you_learnt/utils/custom_widget/custom_button_widget.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';
import 'package:you_learnt/utils/custom_widget/custom_text_field.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../entities/CommonModel.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../_main/widgets/header_widget.dart';
import 'package:reading_time/reading_time.dart';

import '../../_profile/view_profile/view.dart';
import '../../report/view.dart';

class BlogDetailsPage extends StatelessWidget {
  final CommonModel item;

  BlogDetailsPage(this.item, {Key? key}) : super(key: key);

  ScrollController scrollController = ScrollController();
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Get.find<ProfileBlogLogic>().getBlogsDetails(item.id);
    Get.find<ProfileBlogLogic>().rating = 5;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () => Get.to(ReportPage(id: item.userId)),
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
            HeaderWidget(titleBig: 'Blog'.tr, titleSmall: ''.tr),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25))),
                child: GetBuilder<ProfileBlogLogic>(
                    init: Get.find<ProfileBlogLogic>(),
                    builder: (logic) {
                      return logic.isDetailsLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (item.user?.type != 'student') {
                                            Get.to(ViewProfilePage(
                                                slug: item.user?.slug));
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(30.sp),
                                              child: CustomImage(
                                                url: item.user?.imageUrl,
                                                height: 35.sp,
                                                fit: BoxFit.cover,
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
                                      // const SizedBox(
                                      //   height: 1,
                                      // ),
                                      item.subTitle == null
                                          ? Container()
                                          : CustomText(
                                              item.subTitle,
                                              color: greyTextColor,
                                              fontSize: 14,
                                            ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Share.share(item.referralLink ??
                                                  logic.blogModel
                                                      ?.referralLink ??
                                                  '');
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: const Icon(
                                                  Icons.share,
                                                  color: Colors.grey,
                                                  size: 20,
                                                )),
                                          ),
                                          const Spacer(),
                                          Image.asset(
                                            iconComment,
                                            scale: 2,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          CustomText(
                                            '${logic.blogModel?.comments?.length ?? 0}',
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.circle,
                                            color: yalowColor,
                                            size: 10,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          CustomText(
                                            readingTime(logic.blogModel
                                                        ?.description ??
                                                    '0')
                                                .msg,
                                            color: Colors.grey.shade600,
                                            fontSize: 11,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CustomImage(
                                          url: item.imageUrl,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      HtmlWidget(
                                        item.description ?? '',
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Wrap(
                                        children: item.tags
                                                ?.map((e) => GestureDetector(
                                                      onTap: () => logic
                                                          .changeSelectedTag(e),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .only(end: 10),
                                                        child: CustomText(
                                                          '#${e.name}'
                                                              .replaceAll(
                                                                  '##', '#'),
                                                          color: primaryColor,
                                                        ),
                                                      ),
                                                    ))
                                                .toList() ??
                                            [],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: RatingBar.builder(
                                          initialRating: 3,
                                          itemCount: 5,
                                          tapOnlyMode: true,
                                          itemBuilder: (context, index) {
                                            switch (index) {
                                              // default:
                                              // return Container();

                                              case 0:
                                                return Container(
                                                  // margin: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: const Icon(
                                                    Icons
                                                        .sentiment_very_dissatisfied,
                                                    color: Colors.red,
                                                  ),
                                                );
                                              case 1:
                                                return const Icon(
                                                  Icons.sentiment_dissatisfied,
                                                  color: Colors.redAccent,
                                                );
                                              case 2:
                                                return const Icon(
                                                  Icons.sentiment_neutral,
                                                  color: Colors.amber,
                                                );
                                              case 3:
                                                return const Icon(
                                                  Icons.sentiment_satisfied,
                                                  color: Colors.lightGreen,
                                                );
                                              case 4:
                                                return const Icon(
                                                  Icons
                                                      .sentiment_very_satisfied,
                                                  color: Colors.green,
                                                );
                                            }
                                            return Container();
                                          },
                                          onRatingUpdate: (rating) async{
                                            logic.rating = rating.toInt();
                                            logic.addBlogsEmoji(item.id!);
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      // w
                                      GestureDetector(
                                        onTap: () {
                                          scrollController.animateTo(
                                              scrollController
                                                  .position.maxScrollExtent,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.linear);
                                          focusNode.requestFocus();
                                        },
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              iconComment,
                                              color: secondaryColor,
                                              scale: 2,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: CustomText(
                                              'Add Comment'.tr,
                                              fontSize: 12,
                                            )), /*
                                            CustomText(
                                              'View All Comments'.tr,
                                              fontSize: 12,
                                              color: secondaryColor,
                                            )*/
                                          ],
                                        ),
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
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: logic.blogModel?.comments
                                                  ?.length ??
                                              0,
                                          itemBuilder: (context, index) =>
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60.w),
                                                      child: CustomImage(
                                                        url: logic
                                                            .blogModel
                                                            ?.comments?[index]
                                                            .user
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
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    CustomText(logic
                                                                        .blogModel
                                                                        ?.comments?[
                                                                            index]
                                                                        .user
                                                                        ?.fullName),
                                                                    // RatingBarIndicator(
                                                                    //   itemBuilder:
                                                                    //       (context, index) =>
                                                                    //           const Icon(
                                                                    //     Icons
                                                                    //         .star,
                                                                    //     color: Colors
                                                                    //         .orange,
                                                                    //   ),
                                                                    //   rating: logic
                                                                    //           .blogModel
                                                                    //           ?.comments?[index]
                                                                    //           .rating ??
                                                                    //       0.0,
                                                                    //   itemSize:
                                                                    //       20,
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ),
                                                              CustomText(
                                                                logic
                                                                    .blogModel
                                                                    ?.comments?[
                                                                        index]
                                                                    .date,
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                              )
                                                            ],
                                                          ),
                                                          CustomText(
                                                            logic
                                                                .blogModel
                                                                ?.comments?[
                                                                    index]
                                                                .comment,
                                                            color: Colors
                                                                .grey.shade500,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(60.w),
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
                                            child: Column(
                                              children: [
                                                // Row(
                                                //   crossAxisAlignment:
                                                //       CrossAxisAlignment.start,
                                                //   children: [
                                                //     CustomText(
                                                //       'Your rate:'.tr,
                                                //       color:
                                                //           Colors.grey.shade700,
                                                //     ),
                                                //     const SizedBox(
                                                //       width: 10,
                                                //     ),
                                                //     RatingBar.builder(
                                                //       itemBuilder:
                                                //           (context, index) =>
                                                //               const Icon(
                                                //         Icons.star,
                                                //         color: Colors.orange,
                                                //       ),
                                                //       initialRating: logic
                                                //           .rating
                                                //           .toDouble(),
                                                //       allowHalfRating: false,
                                                //       itemSize: 16,
                                                //       onRatingUpdate:
                                                //           (double value) {
                                                //         logic.rating =
                                                //             value.toInt();
                                                //         print(value);
                                                //       },
                                                //     ),
                                                //   ],
                                                // ),
                                                // const SizedBox(height: 5),
                                                CustomTextField(
                                                  hintText: 'Write comment'.tr,
                                                  fontSize: 14,
                                                  focusNode: focusNode,
                                                  controller:
                                                      logic.commentController,
                                                  height: 100.h,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomButtonWidget(
                                          title: 'Add Comment'.tr,
                                          loading: logic.isCommentLoading,
                                          textSize: 12,
                                          onTap: () =>
                                              logic.addBlogsComment(item.id)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      if (logic
                                              .blogModel?.related?.isNotEmpty ==
                                          true)
                                        CustomText(
                                          'Related Articles'.tr,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (logic
                                              .blogModel?.related?.isNotEmpty ==
                                          true)
                                        SizedBox(
                                          height: 200.h,
                                          child: ListView.builder(
                                              itemCount: logic.blogModel
                                                      ?.related?.length ??
                                                  0,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) =>
                                                  ItemBlog(
                                                    item,
                                                    isHorizontal: true,
                                                  )),
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
}
