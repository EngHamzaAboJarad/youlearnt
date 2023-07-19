import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/data/hive/hive_controller.dart';
import 'package:you_learnt/entities/TutorModel.dart';
import 'package:you_learnt/features/_main/find_tutor/logic.dart';
import 'package:you_learnt/features/_profile/view_profile/view.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';
import 'package:you_learnt/utils/functions.dart';

import '../constants/colors.dart';
import '../constants/images.dart';
import '../utils/custom_widget/custom_text.dart';

class ItemTutor extends StatelessWidget {
  final TutorModel? tutor;
  final bool isForFav;
  final bool horizintal;

  const ItemTutor({this.tutor, this.isForFav = false, this.horizintal = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return horizintal
        ? GestureDetector(
            onTap: () => Get.to(ViewProfilePage(
              slug: tutor?.slug,
            )),
            child: Container(
              width: 300.w,
              margin: const EdgeInsetsDirectional.only(start: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                      child: Stack(
                        children: [
                          Container(
                            color: secondaryColor.withOpacity(0.1),
                            child: tutor?.teachers?.publicLink != null
                                ? CustomImage(
                                    url: getYoutubeThumbnail(tutor?.teachers?.publicLink),
                                    width: double.infinity,
                                    fit: BoxFit.fitWidth,
                                  )
                                : null,
                          ),
                          if (tutor?.teachers?.publicLink != null)
                            Center(
                                child: Image.asset(
                              iconPlay,
                              scale: 2,
                            )),
                          if (HiveController.getIsStudent())
                            PositionedDirectional(
                                end: 10,
                                top: 10,
                                child: GetBuilder<FindTutorLogic>(
                                    init: Get.find<FindTutorLogic>(),
                                    id: tutor?.slug,
                                    builder: (logic) {
                                      return logic.isFavLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1,
                                              ))
                                          : GestureDetector(
                                              onTap: () => logic.addToFavorite(
                                                  slug: tutor?.slug, isForFav: isForFav),
                                              child: Icon(
                                                Icons.favorite,
                                                size: 32.sp,
                                                color: tutor?.favoritesExists == true
                                                    ? primaryColor
                                                    : Colors.grey.shade400,
                                              ),
                                            );
                                    }))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Container(
                                    width: 55.sp,
                                    height: 55.sp,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.sp),
                                        color: tutor?.status == 'active'
                                            ? greenColor
                                            : primaryColor),
                                    padding: const EdgeInsets.all(1.5),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30.sp),
                                        child: CustomImage(
                                          url: tutor?.imageUrl,
                                          fit: BoxFit.cover,
                                          width: 55.sp,
                                          height: 55.sp,
                                        ))),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: CustomText(
                                            tutor?.fullName,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        if (tutor?.teachers?.countryFlag != null)
                                          CustomImage(
                                            url: tutor?.teachers?.countryFlag,
                                            height: 20,
                                          ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        if (tutor?.emailVerifiedAt != null)
                                          Image.asset(
                                            iconTrusted,
                                            scale: 1.5,
                                          ),
                                      ],
                                    ),
                                    if (tutor?.subjects?.isNotEmpty == true)
                                      CustomText(
                                        '${tutor?.subjects?.first.hourlyRate ?? ''} \$',
                                        color: secondaryColor,
                                        fontSize: 16,
                                      ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          iconDegree,
                                          scale: 2,
                                          color: greenColor,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          tutor?.teachers?.level,
                                          color: orangeColor,
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CustomText(
                                          '${tutor?.teachers?.studentCount ?? 0}',
                                          fontSize: 14,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          'Users'.tr,
                                          color: greyTextColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        CustomText(
                                          tutor?.teachers?.rating,
                                          fontSize: 14,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CustomText(
                                          'Star'.tr,
                                          color: orangeColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                          if (tutor?.subjects?.isNotEmpty == true)
                            Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                    width: 60.w,
                                    child: CustomText(
                                      tutor?.subjects?.isNotEmpty == true
                                          ? 'Teach'.tr
                                          : '',
                                      fontSize: 14,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 22.h,
                                    child: ListView.builder(
                                        itemCount: tutor?.subjects?.length ?? 0,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) => Container(
                                              margin: const EdgeInsetsDirectional.only(
                                                  end: 8),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: secondaryColor.withOpacity(0.1)),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 4),
                                              child: CustomText(
                                                tutor?.subjects?[index].subjectName,
                                                color: secondaryColor,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                  width: 60.w,
                                  child: CustomText(
                                    tutor?.languages?.isNotEmpty == true
                                        ? 'Speaks'.tr
                                        : '',
                                    fontSize: 14,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 20.h,
                                  child: ListView.builder(
                                      itemCount: tutor?.languages?.length ?? 0,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) => Container(
                                            margin:
                                                const EdgeInsetsDirectional.only(end: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4),
                                                color: Colors.grey.shade200),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 2),
                                            child: CustomImage(
                                              url:
                                                  tutor?.languages?[index].language?.flag,
                                            ),
                                          )),
                                ),
                              ),
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: () => Get.to(ViewProfilePage(
              slug: tutor?.slug,
            )),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.5),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  SizedBox(
                    height: 110,
                    child: buildClipRRect(),
                  ),
                  buildColumn()
                ],
              ),
            ),
          );
  }

  Column buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.sp),
                      color: tutor?.status == 'active' ? greenColor : primaryColor),
                  padding: const EdgeInsets.all(1.5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.sp),
                      child: CustomImage(
                        url: tutor?.imageUrl,
                        fit: BoxFit.cover,
                        width: 45,
                        height: 45,
                      ))),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                        child: Image.asset(
                          iconDegree,
                          scale: 2,
                          color: greenColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: CustomText(
                          tutor?.teachers?.level,
                          fontSize: 10,
                          color: orangeColor,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                        child: CustomText(
                          '${tutor?.teachers?.studentCount ?? 0}',
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        'Users'.tr,
                        fontSize: 10,
                        color: greyTextColor,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                        child: CustomText(
                          tutor?.teachers?.rating,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        'Star'.tr,
                        fontSize: 10,
                        color: orangeColor,
                      ),
                    ],
                  ),
                ],
              )),
              if (tutor?.teachers?.countryFlag != null)
                CustomImage(
                  url: tutor?.teachers?.countryFlag,
                  height: 20,
                ),
              if (tutor?.emailVerifiedAt != null)
                Image.asset(
                  iconTrusted,
                  scale: 1.5,
                ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5.0),
          child: CustomText(
            tutor?.fullName,
            textAlign: TextAlign.start,
            maxLines: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (tutor?.subjects?.isNotEmpty == true)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: CustomText(
              '${tutor?.subjects?.first.hourlyRate ?? ''} \$/hr',
              color: tutor?.teachers?.publicLink != null ? Colors.white : secondaryColor,
              fontSize: 12,
            ),
          ),
        if (tutor?.subjects?.isNotEmpty == true)
          Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                  width: 45.w,
                  child: CustomText(
                    tutor?.subjects?.isNotEmpty == true ? 'Teach'.tr : '',
                    fontSize: 12,
                  )),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: SizedBox(
                  height: 25,
                  child: ListView.builder(
                      itemCount: tutor?.subjects?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Container(
                            margin: const EdgeInsetsDirectional.only(end: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: secondaryColor.withOpacity(0.1)),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            child: CustomText(
                              tutor?.subjects?[index].subjectName,
                              color: secondaryColor,
                              fontSize: 12,
                            ),
                          )),
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 10,
        ),
        if (tutor?.languages?.isNotEmpty == true)
          Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              SizedBox(
                  width: 45.w,
                  child: CustomText(
                    tutor?.languages?.isNotEmpty == true ? 'Speaks'.tr : '',
                    fontSize: 12,
                  )),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: SizedBox(
                  height: 25,
                  child: ListView.builder(
                      itemCount: tutor?.languages?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Container(
                            margin: const EdgeInsetsDirectional.only(end: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            child: CustomImage(
                              url: tutor?.languages?[index].language?.flag,
                              height: 15,
                              width: 25,
                            ),
                          )),
                ),
              ),
            ],
          )
      ],
    );
  }

  ClipRRect buildClipRRect() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      child: Stack(
        children: [
          Container(
            color: secondaryColor.withOpacity(0.1),
            child: tutor?.teachers?.publicLink != null
                ? CustomImage(
                    url: getYoutubeThumbnail(tutor?.teachers?.publicLink),
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  )
                : null,
          ),
          if (tutor?.teachers?.publicLink != null)
            Center(
                child: Image.asset(
              iconPlay,
              scale: 2,
            )),
          if (HiveController.getIsStudent())
            PositionedDirectional(
                end: 10,
                top: 10,
                height: 120,
                child: Column(
                  children: [
                    GetBuilder<FindTutorLogic>(
                        init: Get.find<FindTutorLogic>(),
                        id: tutor?.slug,
                        builder: (logic) {
                          return logic.isFavLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ))
                              : GestureDetector(
                                  onTap: () => logic.addToFavorite(
                                      slug: tutor?.slug, isForFav: isForFav),
                                  child: Icon(
                                    Icons.favorite,
                                    size: 25.sp,
                                    color: tutor?.favoritesExists == true
                                        ? primaryColor
                                        : Colors.grey.shade400,
                                  ),
                                );
                        }),
                  ],
                ))
        ],
      ),
    );
  }
}
