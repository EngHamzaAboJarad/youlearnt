import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:you_learnt/features/_profile/view_profile/logic.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/images.dart';
import '../../../../entities/SubjectModel.dart';
import '../../../../utils/custom_widget/custom_image.dart';
import '../../../../utils/custom_widget/custom_text.dart';
import '../../../../utils/functions.dart';
import '../../../image/view.dart';

class TutorProfileTabs extends StatelessWidget {
  const TutorProfileTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ViewProfileLogic>(
        id: 'tabs',
        builder: (logic) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => logic.changeState(type: 1),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CustomText(
                            'About me'.tr,
                            fontSize: 18,
                            fontWeight: logic.selectedState == 1 ? FontWeight.bold : null,
                          ),
                          SizedBox(
                            height: logic.selectedState == 1 ? 12 : 14,
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              height: logic.selectedState == 1 ? 3 : 1,
                              color: logic.selectedState == 1
                                  ? secondaryColor
                                  : secondaryLightColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => logic.changeState(type: 2),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CustomText(
                            'Pictures'.tr,
                            fontSize: 18,
                            fontWeight: logic.selectedState == 2 ? FontWeight.bold : null,
                          ),
                          SizedBox(
                            height: logic.selectedState == 2 ? 12 : 14,
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              height: logic.selectedState == 2 ? 3 : 1,
                              color: logic.selectedState == 2
                                  ? secondaryColor
                                  : secondaryLightColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => logic.changeState(type: 3),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          CustomText(
                            'Videos'.tr,
                            fontSize: 18,
                            fontWeight: logic.selectedState == 3 ? FontWeight.bold : null,
                          ),
                          SizedBox(
                            height: logic.selectedState == 3 ? 12 : 14,
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              height: logic.selectedState == 3 ? 3 : 1,
                              color: logic.selectedState == 3
                                  ? secondaryColor
                                  : secondaryLightColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              if (logic.selectedState == 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        logic.teacherModel?.profile?.introduceYourSelf,
                        fontSize: 13,
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        logic.teacherModel?.profile?.introduceYourSelfOtherLanguage,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
              if (logic.selectedState == 2)
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: logic.teacherModel?.images.length ?? 0,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, crossAxisSpacing: 2, mainAxisSpacing: 2),
                    itemBuilder: (context, index) => Container(
                        color: Colors.grey.shade300,
                        child: GestureDetector(
                            onTap: () => Get.to(
                                ImagePage(imageUrl: logic.teacherModel?.images[index])),
                            child: CustomImage(url: logic.teacherModel?.images[index])))),
              if (logic.selectedState == 3)
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    itemCount: logic.teacherModel?.subjects?.length ?? 0,
                    itemBuilder: (context, index) {
                      SubjectModel? subject = logic.teacherModel?.subjects?[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    subject?.subjectName,
                                    fontSize: 16,
                                  ),
                                ),
                                CustomText('\$${subject?.hourlyRate ?? ''}/hr',
                                    fontSize: 16, color: greenColor),
                                Icon(
                                  Icons.keyboard_arrow_up_outlined,
                                  color: Colors.grey.shade400,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (subject?.descriptionController.text.isNotEmpty == true)
                              CustomText(
                                subject?.descriptionController.text,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            const SizedBox(
                              height: 5,
                            ),
                            GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: subject?.youtubeLinkControllerList.length ?? 0,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2),
                                itemBuilder: (context, index) => Container(
                                      color: Colors.grey.shade300,
                                      child: GestureDetector(
                                        onTap: () => launchUrlString(subject
                                                ?.youtubeLinkControllerList[index].text ??
                                            ''),
                                        child: subject?.youtubeLinkControllerList[index]
                                                    .text
                                                    .contains('youtu') ==
                                                true
                                            ? CustomImage(
                                                url: getYoutubeThumbnail(subject
                                                    ?.youtubeLinkControllerList[index]
                                                    .text))
                                            : Image.asset(
                                                iconPlay,
                                                scale: 2,
                                              ),
                                      ),
                                    ))
                          ],
                        ),
                      );
                    }),
            ],
          );
        });
  }
}
