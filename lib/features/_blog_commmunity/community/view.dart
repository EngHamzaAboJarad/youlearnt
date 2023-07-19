import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:you_learnt/entities/CommonModel.dart';
import 'package:you_learnt/features/_blog_commmunity/profile_community/view.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';
import '../../_main/widgets/header_widget.dart';
import '../profile_community/logic.dart';
import '../widgets/item_community.dart';

class CommunityPage extends StatelessWidget {
  final String? name;

  const CommunityPage({this.name, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<ProfileCommunityLogic>().getWebsiteCommunity(search: name);
    return GetBuilder<ProfileCommunityLogic>(
        init: Get.find<ProfileCommunityLogic>(),
        builder: (logic) {
          return Container(
            color: secondaryColor,
            child: Column(
              children: [
                HeaderWidget(
                    titleBig: 'Community'.tr,
                    hintSearchText: 'Search Community',
                    titleSmall: ''.tr),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25))),
                    child: logic.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: () async {
                              await Get.find<ProfileCommunityLogic>()
                                  .getWebsiteCommunity(search: name);
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (logic.tagsWebsiteList.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: CustomText(
                                        'Trending Topics'.tr,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  if (logic.tagsWebsiteList.isNotEmpty)
                                    SizedBox(
                                      height: 25.h,
                                      child: ListView.builder(
                                          itemCount:
                                              logic.tagsWebsiteList.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              GestureDetector(
                                                onTap: () =>
                                                    logic.changeSelectedTag(
                                                        logic.tagsWebsiteList[
                                                            index]),
                                                child: Container(
                                                  margin:
                                                      const EdgeInsetsDirectional
                                                          .only(start: 10),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: secondaryColor
                                                          .withOpacity(0.1)),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: CustomText(
                                                    logic.tagsWebsiteList[index]
                                                        .name,
                                                    color: secondaryColor,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CustomText(
                                      'Featured Qs'.tr,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          logic.communityWebsiteList.length,
                                      itemBuilder: (context, index) {
                                        var item =
                                            logic.communityWebsiteList[index];
                                        return ItemCommunity(
                                            logic: logic, item: item);
                                      }),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
