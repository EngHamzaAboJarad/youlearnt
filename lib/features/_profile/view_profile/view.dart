import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/entities/EducationModel.dart';
import 'package:you_learnt/features/_profile/view_profile/widgets/tutor_profile_tabs.dart';
import 'package:you_learnt/features/report/view.dart';
import 'package:you_learnt/utils/custom_widget/custom_button_widget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../data/hive/hive_controller.dart';
import '../../../entities/CertificationModel.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';
import '../../_main/find_tutor/logic.dart';
import '../../chat/chat_screen.dart';
import '../classrooms/student/exploerTeacherAvaliableClassrooms/avalibleTeacherGroups/view.dart';
import 'logic.dart';

class ViewProfilePage extends StatefulWidget {
  final String? slug;

  const ViewProfilePage({Key? key, this.slug}) : super(key: key);

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  final logic = Get.put(ViewProfileLogic());

  @override
  void initState() {
    //logic.getProfileBySlug('mohammedalqadri96963502-afe3-4506-9547-e8730b58b946');
    logic.getProfileBySlug(widget.slug);
    logic.selectedSubject = null;
    logic.selectedTime = null;
    logic.selectedPlan = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () => Get.to(ReportPage(
                    id: logic.teacherModel?.user?.id,
                  )),
              icon: const Icon(
                Icons.report,
                color: Colors.white,
              ))
        ],
      ),
      body: GetBuilder<ViewProfileLogic>(builder: (logic) {
        return logic.isLoading
            ? const SizedBox(
                child: Center(
                    child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ))))
            : Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    height: 215.h,
                    child: logic.teacherModel?.profile?.publicLink != null
                        ? YoutubePlayerIFrame(
                            controller: YoutubePlayerController(
                              initialVideoId: convertUrlToId(
                                      logic.teacherModel?.profile?.publicLink ??
                                          '') ??
                                  '',
                              params: const YoutubePlayerParams(
                                startAt: Duration(seconds: 0),
                                showControls: true,
                                showFullscreenButton: true,
                              ),
                            ),
                          )
                        : Container(
                            color: primaryColor,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 50.h),
                              child: Image.asset(
                                iconPlay,
                                scale: 2,
                              ),
                            )),
                  ),
                  PositionedDirectional(
                    start: 0,
                    end: 0,
                    bottom: 0,
                    top: 190.h,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25)),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25))),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Container(
                                        width: 90.sp,
                                        height: 90.sp,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.sp),
                                            color: greenColor),
                                        padding: const EdgeInsets.all(3),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.sp),
                                            child: CustomImage(
                                              url: logic
                                                  .teacherModel?.user?.imageUrl,
                                              fit: BoxFit.cover,
                                              width: 90.sp,
                                              height: 90.sp,
                                            ))),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: CustomText(
                                                logic.teacherModel?.user
                                                    ?.fullName,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            CustomImage(
                                              url: logic.teacherModel?.profile
                                                  ?.countryFlag,
                                              height: 20,
                                              width: 30,
                                            ),
                                            if (logic.teacherModel?.user
                                                    ?.verified ==
                                                true)
                                              const SizedBox(
                                                width: 5,
                                              ),
                                            if (logic.teacherModel?.user
                                                    ?.verified ==
                                                true)
                                              Image.asset(
                                                iconTrusted,
                                                scale: 1.5,
                                              ),
                                            if (logic.teacherModel?.user
                                                    ?.verified ==
                                                true)
                                              const SizedBox(
                                                width: 5,
                                              ),
                                            if (logic.teacherModel?.user
                                                    ?.verified ==
                                                true)
                                              CustomText(
                                                'Verified'.tr,
                                                fontSize: 9,
                                                color: greenColor,
                                              )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              iconDegree,
                                              scale: 2,
                                              color: orangeColor,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            CustomText(
                                              logic
                                                  .teacherModel?.profile?.level,
                                              color: orangeColor,
                                            )
                                          ],
                                        ),
                                        CustomText(
                                          logic.teacherModel?.profile?.bio,
                                          fontSize: 12,
                                          color: greyTextBoldColor,
                                        )
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: secondaryLightColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            CustomText(logic
                                                .teacherModel?.profile?.rating),
                                            CustomText(
                                              'Rating'.tr,
                                              color: Colors.grey.shade500,
                                            ),
                                          ],
                                        )),
                                    if (logic.teacherModel?.profile
                                            ?.experienceYears !=
                                        null)
                                      Container(
                                        width: 0.5,
                                        color: Colors.grey.shade400,
                                        height: 50.h,
                                      ),
                                    if (logic.teacherModel?.profile
                                            ?.experienceYears !=
                                        null)
                                      Expanded(
                                          flex: 3,
                                          child: Column(
                                            children: [
                                              CustomText(
                                                  '${logic.teacherModel?.profile?.experienceYears} ' +
                                                      'years'.tr),
                                              CustomText(
                                                'Experience'.tr,
                                                color: Colors.grey.shade500,
                                              ),
                                            ],
                                          )),
                                    Container(
                                      width: 0.5,
                                      color: Colors.grey.shade400,
                                      height: 50.h,
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            CustomText(
                                                '${logic.teacherModel?.profile?.studentCount ?? ''}'),
                                            CustomText(
                                              'Students'.tr,
                                              color: Colors.grey.shade500,
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              const TutorProfileTabs(),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                      width: 70.w,
                                      child: CustomText(
                                        'Teach'.tr,
                                        fontSize: 18,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 35.h,
                                      child: ListView.builder(
                                          itemCount: logic.teacherModel
                                                  ?.subjects?.length ??
                                              0,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) => logic
                                                      .teacherModel
                                                      ?.subjects?[index]
                                                      .subjectName
                                                      ?.isNotEmpty ==
                                                  true
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  margin:
                                                      const EdgeInsetsDirectional
                                                          .only(end: 8),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: secondaryColor
                                                          .withOpacity(0.1)),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: CustomText(
                                                    logic
                                                        .teacherModel
                                                        ?.subjects?[index]
                                                        .subjectName,
                                                    textAlign: TextAlign.center,
                                                    color: secondaryColor,
                                                  ),
                                                )
                                              : const SizedBox()),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () => logic.toggleCertificates(),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: CustomText(
                                                  'Certificates'.tr)),
                                          Icon(
                                            !logic.showCertificates
                                                ? Icons
                                                    .keyboard_arrow_up_outlined
                                                : Icons
                                                    .keyboard_arrow_down_outlined,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                    AnimatedSize(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: SizedBox(
                                        height:
                                            logic.showCertificates ? null : 0,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: logic.teacherModel
                                                    ?.certifications?.length ??
                                                0,
                                            itemBuilder: (context, index) {
                                              CertificationModel?
                                                  certification = logic
                                                      .teacherModel
                                                      ?.certifications?[index];
                                              return Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: CustomText(
                                                              certification
                                                                  ?.subjectName)),
                                                      if (certification
                                                              ?.status ==
                                                          'Vsibile')
                                                        Image.asset(
                                                          iconTrusted2,
                                                          scale: 1.5,
                                                        ),
                                                      if (certification
                                                              ?.status ==
                                                          'Vsibile')
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                      if (certification
                                                              ?.status ==
                                                          'Vsibile')
                                                        CustomText(
                                                          'Verified by admin'
                                                              .tr,
                                                          fontSize: 9,
                                                          color: blueColor2,
                                                        )
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          child: CustomText(
                                                        certification
                                                            ?.issuedBy.text,
                                                        color: Colors.grey,
                                                      )),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      CustomText(
                                                        certification
                                                            ?.issuedDate,
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              );
                                            }),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () => logic.toggleEducation(),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child:
                                                  CustomText('Education'.tr)),
                                          Icon(
                                            !logic.showEducation
                                                ? Icons
                                                    .keyboard_arrow_up_outlined
                                                : Icons
                                                    .keyboard_arrow_down_outlined,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                    AnimatedSize(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: SizedBox(
                                          height:
                                              logic.showEducation ? null : 0,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: logic.teacherModel
                                                      ?.educations?.length ??
                                                  0,
                                              itemBuilder: (context, index) {
                                                EducationModel? education =
                                                    logic.teacherModel
                                                        ?.educations?[index];
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: CustomText(
                                                            '${education?.degree.text ?? ''}  ${education?.specialization.text ?? ''}',
                                                          ),
                                                        ),
                                                        if (education?.status ==
                                                            'Vsibile')
                                                          Image.asset(
                                                            iconTrusted2,
                                                            scale: 1.5,
                                                          ),
                                                        if (education?.status ==
                                                            'Vsibile')
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                        if (education?.status ==
                                                            'Vsibile')
                                                          CustomText(
                                                            'Verified by admin'
                                                                .tr,
                                                            fontSize: 9,
                                                            color: blueColor2,
                                                          )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: CustomText(
                                                          '${education?.university.text ?? ''}}',
                                                          color: Colors.grey,
                                                        )),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        CustomText(
                                                          '(${education?.startAt?.substring(0, 4)}-${education?.endAt?.substring(0, 4)})',
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                );
                                              })),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomText(
                                      'Reviews'.tr,
                                      fontSize: 16,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          children: [
                                            CustomText(
                                              logic.ratingModel?.rating,
                                              fontSize: 18,
                                            ),
                                            RatingBar.builder(
                                                itemCount: 5,
                                                initialRating: double.tryParse(
                                                        logic.ratingModel
                                                                ?.rating ??
                                                            '0') ??
                                                    0,
                                                allowHalfRating: true,
                                                itemSize: 15.sp,
                                                glowColor: yalowColor,
                                                ignoreGestures: true,
                                                itemBuilder: (context, index) =>
                                                    Image.asset(
                                                      iconStar,
                                                      scale: 2,
                                                      color: yalowColor,
                                                    ),
                                                onRatingUpdate:
                                                    (onRatingUpdate) {}),
                                            CustomText(
                                              '${logic.ratingModel?.allRating?.allStar ?? 0} ' +
                                                  'REVIEW'.tr,
                                              fontSize: 12,
                                              color: Colors.grey,
                                            )
                                          ],
                                        )),
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const CustomText(
                                                      '1',
                                                      fontSize: 16,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Image.asset(
                                                      iconStar,
                                                      scale: 2,
                                                      color: yalowColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: ((logic
                                                                        .ratingModel
                                                                        ?.allRating
                                                                        ?.onestar ??
                                                                    0) /
                                                                (logic
                                                                        .ratingModel
                                                                        ?.allRating
                                                                        ?.allStar ??
                                                                    1))
                                                            .toDouble(),
                                                        minHeight: 8.h,
                                                        valueColor:
                                                            const AlwaysStoppedAnimation<
                                                                Color>(
                                                          yalowColor,
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const CustomText(
                                                      '2',
                                                      fontSize: 16,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Image.asset(
                                                      iconStar,
                                                      scale: 2,
                                                      color: yalowColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: ((logic
                                                                        .ratingModel
                                                                        ?.allRating
                                                                        ?.twostar ??
                                                                    0) /
                                                                (logic
                                                                        .ratingModel
                                                                        ?.allRating
                                                                        ?.allStar ??
                                                                    1))
                                                            .toDouble(),
                                                        minHeight: 8.h,
                                                        valueColor:
                                                            const AlwaysStoppedAnimation<
                                                                Color>(
                                                          yalowColor,
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const CustomText(
                                                      '3',
                                                      fontSize: 16,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Image.asset(
                                                      iconStar,
                                                      scale: 2,
                                                      color: yalowColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: ((logic
                                                                        .ratingModel
                                                                        ?.allRating
                                                                        ?.threestar ??
                                                                    0) /
                                                                (logic
                                                                        .ratingModel
                                                                        ?.allRating
                                                                        ?.allStar ??
                                                                    1))
                                                            .toDouble(),
                                                        minHeight: 8.h,
                                                        valueColor:
                                                            const AlwaysStoppedAnimation<
                                                                Color>(
                                                          yalowColor,
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const CustomText(
                                                      '4',
                                                      fontSize: 16,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Image.asset(
                                                      iconStar,
                                                      scale: 2,
                                                      color: yalowColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: ((logic
                                                                        .ratingModel
                                                                        ?.allRating
                                                                        ?.fourstar ??
                                                                    0) /
                                                                (logic
                                                                        .ratingModel
                                                                        ?.allRating
                                                                        ?.allStar ??
                                                                    1))
                                                            .toDouble(),
                                                        minHeight: 8.h,
                                                        valueColor:
                                                            const AlwaysStoppedAnimation<
                                                                Color>(
                                                          yalowColor,
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const CustomText(
                                                      '5',
                                                      fontSize: 16,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Image.asset(
                                                      iconStar,
                                                      scale: 2,
                                                      color: yalowColor,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          LinearProgressIndicator(
                                                        value: ((logic
                                                                        .ratingModel
                                                                        ?.allRating
                                                                        ?.fivestar ??
                                                                    0) /
                                                                (logic
                                                                        .ratingModel
                                                                        ?.allRating
                                                                        ?.allStar ??
                                                                    1))
                                                            .toDouble(),
                                                        minHeight: 8.h,
                                                        valueColor:
                                                            const AlwaysStoppedAnimation<
                                                                Color>(
                                                          yalowColor,
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: logic
                                                .ratingModel?.reviews?.length ??
                                            0,
                                        itemBuilder:
                                            (context, index) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CustomImage(
                                                            url: logic
                                                                .ratingModel
                                                                ?.reviews?[
                                                                    index]
                                                                .imageUrl,
                                                            width: 60.sp,
                                                            height: 60.sp,
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
                                                                  children: [
                                                                    CustomText(
                                                                      logic
                                                                          .ratingModel
                                                                          ?.reviews?[
                                                                              index]
                                                                          .fullName,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    RatingBar.builder(
                                                                        itemCount: 5,
                                                                        initialRating: double.tryParse(logic.ratingModel?.reviews?[index].rating ?? '0') ?? 0,
                                                                        allowHalfRating: true,
                                                                        itemSize: 15.sp,
                                                                        glowColor: yalowColor,
                                                                        ignoreGestures: true,
                                                                        itemBuilder: (context, index) => Image.asset(
                                                                              iconStar,
                                                                              scale: 2,
                                                                              color: yalowColor,
                                                                            ),
                                                                        onRatingUpdate: (onRatingUpdate) {}),
                                                                    const Spacer(),
                                                                    Container(
                                                                      margin: const EdgeInsetsDirectional
                                                                              .only(
                                                                          end:
                                                                              8),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              15),
                                                                          color:
                                                                              secondaryColor.withOpacity(0.1)),
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              5),
                                                                      child:
                                                                          CustomText(
                                                                        logic
                                                                            .ratingModel
                                                                            ?.reviews?[index]
                                                                            .subjectName,
                                                                        color:
                                                                            secondaryColor,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                CustomText(
                                                                  logic
                                                                      .ratingModel
                                                                      ?.reviews?[
                                                                          index]
                                                                      .dateFormat,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12,
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      CustomText(
                                                        logic
                                                            .ratingModel
                                                            ?.reviews?[index]
                                                            .review,
                                                        fontSize: 13,
                                                      )
                                                    ],
                                                  ),
                                                )),
                                    if (logic
                                            .ratingModel?.reviews?.isNotEmpty ==
                                        true)
                                      CustomButtonWidget(
                                        title: 'View all'.tr,
                                        onTap: () {},
                                        color: secondaryLightColor
                                            .withOpacity(0.2),
                                        textColor: secondaryColor,
                                        textSize: 14,
                                      ),
                                    /*   const Divider(),
                                    CustomText(
                                      'Subjects to teach'.tr,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),*/
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 80.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (HiveController.getIsStudent())
                    PositionedDirectional(
                        start: 10,
                        end: 10,
                        bottom: 20,
                        height: 40.h,
                        child: Row(
                          children: [
                            GetBuilder<FindTutorLogic>(
                                init: Get.find<FindTutorLogic>(),
                                id: logic.teacherModel?.user?.slug,
                                builder: (logic1) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await logic1.addToFavorite(
                                          slug: logic.teacherModel?.user?.slug,
                                          isForProfile: true);
                                      logic1.isFavLoading = true;
                                      await logic.getProfileBySlug(widget.slug,
                                          withoutLoading: true);
                                      logic1.isFavLoading = false;
                                    },
                                    child: Container(
                                      height: 55.h,
                                      width: 55.w,
                                      alignment: Alignment.center,
                                      color: Colors.grey.shade200,
                                      child: logic1.isFavLoading
                                          ? const CircularProgressIndicator(
                                              strokeWidth: 1,
                                            )
                                          : Icon(
                                              Icons.favorite,
                                              color: logic.teacherModel?.user
                                                          ?.favoritesExists ==
                                                      true
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                    ),
                                  );
                                }),
                            GestureDetector(
                              onTap: () => Get.to(ChatScreen(
                                  peerId: (logic.teacherModel?.user?.id ?? '0')
                                      .toString(),
                                  title:
                                      logic.teacherModel?.user?.fullName ?? '',
                                  peerImage:
                                      logic.teacherModel?.user?.imageUrl ??
                                          '')),
                              child: Container(
                                height: 55.h,
                                margin: const EdgeInsetsDirectional.only(
                                    start: 10, end: 10),
                                width: 55.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade200,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.message,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(AvalibleTeacherClassrooms(
                                  teacherModel: logic.teacherModel,
                                ));
                              },
                              child: Container(
                                height: 35.h,
                                margin: const EdgeInsetsDirectional.only(
                                    start: 2, end: 10),
                                width: 50.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: mainColor,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.groups,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                                child: CustomButtonWidget(
                              title: 'Book a session'.tr,
                              textSize: 15,
                              //     height: double.infinity,
                              onTap: () => logic.goToBook(),
                              radius: 5,
                            ))
                          ],
                        )),
                  /*  PositionedDirectional(
                      top: 40,
                      start: 10,
                      child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          )))*/
                ],
              );
      }),
    );
  }
}
