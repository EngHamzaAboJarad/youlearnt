import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/entities/EducationModel.dart';
import 'package:you_learnt/features/_profile/education/logic.dart';

import '../../../../constants/colors.dart';
import '../../../../utils/custom_widget/custom_button_widget.dart';
import '../../../../utils/custom_widget/custom_image.dart';
import '../../../../utils/custom_widget/custom_text.dart';

class ItemEducation extends StatelessWidget {
  final EducationModel education;

  const ItemEducation({Key? key, required this.education}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EducationLogic>(builder: (logic) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400, width: 0.5),
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Specialization'.tr,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(education.specialization.text),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Degree'.tr,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(education.degree.text),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                    GestureDetector(
                        onTap: () => logic.toggleMenu(education),
                        child: const Icon(
                          Icons.more_vert_outlined,
                          color: Colors.grey,
                        ))
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'University'.tr,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(education.university.text),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'Issued Date'.tr,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(education.endAt),
                      ],
                    )),
                    const Icon(
                      Icons.more_vert_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CustomImage(
                    url: education.imageUrl,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: education.status == 'Hidden' ? Colors.red : greenColor,
                          width: 1)),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: CustomText(
                    education.status == 'Hidden'
                        ? 'Education Not Verified'
                        : 'Education Verified'.tr,
                    fontSize: 16,
                    color: education.status == 'Hidden' ? Colors.red : greenColor,
                  ),
                ),
              ],
            ),
            PositionedDirectional(
              end: 0,
              top: 0,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: Container(
                  margin: const EdgeInsetsDirectional.only(end: 20, top: 5),
                  width: education.openMenu ? 110.w : 0,
                  height: education.openMenu ? null : 0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 0.5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CustomText(
                        'Edit'.tr,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Container(
                      height: 0.5,
                      color: Colors.grey,
                    ),*/
                      InkWell(
                        onTap: () => logic.deleteEducation(education.id),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CustomText(
                            'Delete'.tr,
                            color: Colors.grey.shade500,
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
      );
    });
  }
}
