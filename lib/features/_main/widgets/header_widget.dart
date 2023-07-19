import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/constants/colors.dart';
import 'package:you_learnt/features/_blog_commmunity/community/view.dart';
import 'package:you_learnt/features/_main/find_student/logic.dart';
import 'package:you_learnt/features/_main/find_tutor/logic.dart';
import 'package:you_learnt/features/_main/find_tutor/view.dart';
import 'package:you_learnt/features/_main/widgets/tutors_filter_widget.dart';

import '../../../constants/images.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/custom_widget/custom_text_field.dart';
import '../../_blog_commmunity/blog/view.dart';
import '../logic.dart';
import '../notifications/view.dart';

class HeaderWidget extends StatelessWidget {
  final String titleSmall;
  final String titleBig;
  final String hintSearchText;
  final bool showSearch;

  const HeaderWidget(
      {required this.titleBig,
      this.hintSearchText = 'Search for courses, tutors, and keywords',
      this.showSearch = true,
      required this.titleSmall,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLogic>(
        init: Get.find<MainLogic>(),
        builder: (logic) {
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (titleSmall != '')
                  CustomText(
                    titleSmall,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        titleBig,
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                        onTap: () => logic.openDrawerPage(NotificationsPage()),
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 26,
                        )),
                    GetBuilder<MainLogic>(
                        init: Get.find<MainLogic>(),
                        builder: (logic) {
                          return GestureDetector(
                              onTap: () => logic.toggleDrawer(),
                              child: Container(
                                color: secondaryColor,
                                padding:
                                    const EdgeInsetsDirectional.fromSTEB(20, 15, 15, 15),
                                child: Image.asset(
                                  iconMenu,
                                  scale: 1.8,
                                ),
                              ));
                        }),
                  ],
                ),
                if (showSearch)
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextField(
                        hintText: hintSearchText.tr,
                        color: Colors.white,
                        fontSize: 13,
                        controller: logic.searchController,
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.name,
                        onChanged: (val) {
                          if (val.isEmpty) {
                            handleSearch(val);
                          }
                        },
                        onFieldSubmitted: (val) => handleSearch(val),
                        prefixIcon: const Icon(Icons.search),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      if (titleBig == 'Find Tutor'.tr)
                        GestureDetector(
                            onTap: () => Get.bottomSheet(const TutorsFilters(),
                                isScrollControlled: true),
                            child: Image.asset(
                              iconFilter,
                              scale: 2,
                            )),
                      if (titleBig == 'Find Tutor'.tr)
                        const SizedBox(
                          width: 10,
                        ),
                    ],
                  ),
                if (showSearch)
                  const SizedBox(
                    height: 10,
                  ),
              ],
            ),
          );
        });
  }

  handleSearch(val) {
    if (titleBig == 'Tutors'.tr) {
      Get.find<MainLogic>().openDrawerPage(FindTutorPage());
    } else if (titleBig == 'Blog'.tr) {
      Get.find<MainLogic>().openDrawerPage(BlogPage(name: val));
    } else if (titleBig == 'Community'.tr) {
      Get.find<MainLogic>().openDrawerPage(CommunityPage(name: val));
    } else {
      Get.find<FindTutorLogic>().getTutors();
      Get.find<MainLogic>().openDrawerPage(FindTutorPage());
    }
  }
}
