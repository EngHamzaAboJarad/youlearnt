import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:you_learnt/core/helper_methods.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../add_blog/view.dart';
import 'logic.dart';

class ProfileBlogPage extends StatefulWidget {
  const ProfileBlogPage({Key? key}) : super(key: key);

  @override
  State<ProfileBlogPage> createState() => _ProfileBlogPageState();
}

class _ProfileBlogPageState extends State<ProfileBlogPage> {
  final HelperMethods _helperMethods = HelperMethods();
  @override
  void initState() {
    Get.find<ProfileBlogLogic>().getBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<ProfileBlogLogic>().closeAllOpentoggeldMenues();
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
                      'Blog'.tr,
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
                  child: GetBuilder<ProfileBlogLogic>(builder: (logic) {
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
                                child: logic.blogsList.isEmpty
                                    ? Center(
                                        child: CustomText("No blogs.".tr),
                                      )
                                    : ListView.builder(
                                        itemCount: logic.blogsList.length,
                                        itemBuilder: (context, index) => Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () => logic.goToDetails(
                                                  logic.blogsList[index]),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade400,
                                                        width: 0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: SizedBox(
                                                            height: 200.h,
                                                            child: CustomImage(
                                                              url: logic
                                                                  .blogsList[
                                                                      index]
                                                                  .imageUrl,
                                                              width: double
                                                                  .infinity,
                                                              fit: BoxFit.cover,
                                                            ),
                                                            //  color: primaryColor.withOpacity(0.2),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: CustomText(
                                                                logic
                                                                    .blogsList[
                                                                        index]
                                                                    .title,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                                onTap: () => logic
                                                                    .toggleMenu(
                                                                        logic.blogsList[
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
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        CustomText(
                                                          DateFormat()
                                                              .add_yMMMMEEEEd()
                                                              .add_Hm()
                                                              .format(DateTime
                                                                  .parse(logic
                                                                      .blogsList[
                                                                          index]
                                                                      .createdAt!)),
                                                          color: Colors
                                                              .grey.shade500,
                                                          fontSize: 12,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Wrap(
                                                          children: logic
                                                                  .blogsList[
                                                                      index]
                                                                  .tags
                                                                  ?.map((e) =>
                                                                      GestureDetector(
                                                                        onTap: () =>
                                                                            logic.changeSelectedTag(e),
                                                                        child:
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
                                                                        ),
                                                                      ))
                                                                  .toList() ??
                                                              [],
                                                        ),
                                                        if (false)
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        if (false)
                                                          Row(
                                                            children: [
                                                              Image.asset(
                                                                iconComment,
                                                                scale: 2,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              const CustomText(
                                                                '32',
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              const SizedBox(
                                                                  width: 30),
                                                              Image.asset(
                                                                iconStar,
                                                                scale: 2,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              const CustomText(
                                                                '1232',
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              const Spacer(),
                                                              const Icon(
                                                                Icons.circle,
                                                                color:
                                                                    yalowColor,
                                                                size: 10,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              const CustomText(
                                                                '4 min read',
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ],
                                                          )
                                                      ],
                                                    ), /*
                                              PositionedDirectional(
                                                end: 0,
                                                top: 0,
                                                child: AnimatedSize(
                                                  duration: const Duration(milliseconds: 200),
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsetsDirectional.only(end: 20, top: 5),
                                                    width: logic.showMenu ? 110.w : 0,
                                                    height: logic.showMenu ? null : 0,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(color: Colors.grey, width: 0.5)),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: CustomText(
                                                            'Edit'.tr,
                                                            color: Colors.grey.shade500,
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 0.5,
                                                          color: Colors.grey,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: CustomText(
                                                            'Delete'.tr,
                                                            color: Colors.grey.shade500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )*/
                                                  ],
                                                ),
                                              ),
                                            ),
                                            PositionedDirectional(
                                              end: 10,
                                              top: 200,
                                              child: AnimatedSize(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                child: Container(
                                                  margin:
                                                      const EdgeInsetsDirectional
                                                              .only(
                                                          end: 20, top: 5),
                                                  width: logic.blogsList[index]
                                                          .isSelected
                                                      ? 110.w
                                                      : 0,
                                                  height: logic.blogsList[index]
                                                          .isSelected
                                                      ? null
                                                      : 0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 0.5)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () =>
                                                            logic.editBlog(
                                                                logic.blogsList[
                                                                    index]),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: CustomText(
                                                            'Edit'.tr,
                                                            color: Colors
                                                                .grey.shade500,
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
                                                                      "Are you sure to delete this blog ?"
                                                                          .tr,
                                                                  title:
                                                                      "Alert!"
                                                                          .tr,
                                                                  context:
                                                                      context,
                                                                  function: () {
                                                                    logic.deleteBlog(logic
                                                                        .blogsList[
                                                                            index]
                                                                        .id);
                                                                  });
                                                        },
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: CustomText(
                                                            'Delete'.tr,
                                                            color: Colors
                                                                .grey.shade500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 30.h),
                                child: CustomButtonWidget(
                                  title: 'Add  new  article'.tr,
                                  onTap: () => Get.to(AddBlogPage(
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
