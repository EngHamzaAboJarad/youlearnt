import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/data/hive/hive_controller.dart';
import 'package:you_learnt/features/_auth/auth/view.dart';
import 'package:you_learnt/features/_auth/choose_subjects/view.dart';
import 'package:you_learnt/features/_profile/certificates/view.dart';
import 'package:you_learnt/features/_profile/change_password/view.dart';
import 'package:you_learnt/features/_profile/classrooms/student/classrooms%20list/view.dart';
import 'package:you_learnt/features/_profile/education/view.dart';
import 'package:you_learnt/features/_profile/experience/view.dart';
import 'package:you_learnt/features/_profile/personal_information/view.dart';
import 'package:you_learnt/features/_profile/profile_description/view.dart';
import 'package:you_learnt/features/_profile/refer_friend/view.dart';
import 'package:you_learnt/features/_profile/statistics/view.dart';
import 'package:you_learnt/features/_profile/view_profile/view.dart';
import 'package:you_learnt/features/_profile/withdraw/view.dart';
import 'package:you_learnt/utils/custom_widget/custom_button_widget.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../_blog_commmunity/profile_community/view.dart';
import '../../_main/logic.dart';
import '../availability/view.dart';
import '../classrooms/teacher/classrooms list/view.dart';
import '../requests/view.dart';
import '../teacher_profile_subjects/view.dart';
import '../tutor_request/view.dart';
import '../logic.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final logic = Get.put(ProfileLogic());
  // MainLogic mainLogic = Get.find();
  @override
  void initState() {
    // refreshData();
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   // executes after build
    //   await Get.find<MainLogic>().getProfile();
    //   Get.find<ProfileLogic>().initUserModel();
    // });
  }

  // refreshData() async {
  //   await Get.find<MainLogic>().getProfile();
  //   Get.find<ProfileLogic>().initUserModel();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: secondaryColor,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 60.h,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25))),
              child: HiveController.getToken() == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            'You should login or create new account to see your profile'
                                .tr,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: CustomButtonWidget(
                                title: 'Log In'.tr,
                                textSize: 16,
                                onTap: () => Get.to(AuthPage())
                                    ?.then((value) => setState(() {}))),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await Get.find<MainLogic>().getProfile();
                        Get.find<ProfileLogic>().initUserModel();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: GetBuilder<ProfileLogic>(builder: (logic) {
                          return Column(
                            children: [
                              GetBuilder<MainLogic>(builder: (logic) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 55.h,
                                    ),
                                    CustomText(
                                      logic.userModel?.fullName,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    if (logic.userModel?.type == 'teacher')
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            iconEdit,
                                            scale: 2,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          CustomText(
                                            'Complete your profile'.tr,
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ],
                                      ),
                                    if (logic.userModel?.type == 'teacher')
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    if (logic.userModel?.type == 'teacher')
                                      SizedBox(
                                          width: 200.w,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: LinearProgressIndicator(
                                              value: (logic.userModel
                                                          ?.completeProfile ??
                                                      0) /
                                                  100,
                                              minHeight: 6.h,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(
                                                Colors.green,
                                              ),
                                              backgroundColor:
                                                  secondaryLightColor
                                                      .withOpacity(0.5),
                                            ),
                                          )),
                                    if (logic.userModel?.type == 'teacher')
                                      SizedBox(
                                          width: 200.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomText(
                                                'Profile Progress'.tr,
                                                fontSize: 12,
                                              ),
                                              CustomText(
                                                '${logic.userModel?.completeProfile ?? 0}%'
                                                    .tr,
                                                fontSize: 12,
                                              ),
                                            ],
                                          )),
                                  ],
                                );
                              }),
                              const SizedBox(
                                height: 10,
                              ),
                              GetBuilder<MainLogic>(builder: (mainInnerLogic) {
                                return buildContainer([
                                  TextTab(
                                      text: 'Personal information'.tr,
                                      onTap: () {
                                        logic.initUserModel();
                                        Get.to(PersonalInformationPage());
                                      }),
                                 HiveController.getIsStudent()
                                      ? TextTab(
                                          text: 'Tutor request'.tr,
                                          onTap: () =>
                                              Get.to(TutorRequestPage()))
                                      : TextTab(
                                          text: 'Profile description'.tr,
                                          onTap: () =>
                                              Get.to(ProfileDescriptionPage())),
                                  if (!HiveController.getIsStudent())
                                    TextTab(
                                        text: 'Subjects'.tr,
                                        onTap: () =>
                                            Get.to(TeacherProfileSubjects())),
                                 HiveController.getIsStudent()
                                      ? TextTab(
                                          text: 'Requests'.tr,
                                          onTap: () =>
                                              Get.to(const RequestsPage()))
                                      : TextTab(
                                          text: 'Availability'.tr,
                                          onTap: () =>
                                              Get.to(AvailabilityPage())),
                                  TextTab(
                                      text: 'Certificates'.tr,
                                      onTap: () => Get.to(CertificatesPage(
                                            isStudent: logic.isStudent,
                                          ))),
                                  HiveController.getIsStudent()
                                      ? TextTab(
                                          text: 'Recommendations'.tr,
                                          onTap: () =>
                                              Get.to(ChooseSubjectsPage(
                                                isFromProfile: true,
                                              )))
                                      : TextTab(
                                          text: 'Education'.tr,
                                          onTap: () => Get.to(EducationPage())),
                                  mainInnerLogic.userModel?.type != 'teacher'
                                      ? TextTab(
                                          text: 'Classrooms'.tr,
                                          onTap: () =>
                                              Get.to(const StudentClassrooms()))
                                      : TextTab(
                                          text: 'Classrooms'.tr,
                                          onTap: () => Get.to(
                                              const TeacherClassrooms())),
                                  if (mainInnerLogic.userModel?.type ==
                                      'teacher')
                                    TextTab(
                                        text: 'Work history'.tr,
                                        onTap: () => Get.to(ExperiencePage())),
                                ]);
                              }),
                              buildContainer([
                                if (!HiveController.getIsStudent())
                                  TextTab(
                                      text: 'Blog'.tr,
                                      onTap: () => logic.goToBlog()),
                                TextTab(
                                    text: 'Q&A'.tr,
                                    onTap: () =>
                                        Get.to(ProfileCommunityPage())),
                              ]),
                              buildContainer([
                                if (!HiveController.getIsStudent())
                                  TextTab(
                                      text: 'Statistics'.tr,
                                      onTap: () => Get.to(StatisticsPage())),
                                logic.isStudent
                                    ? TextTab(
                                        text: 'Payments'.tr,
                                        onTap: () => Get.to(WithdrawPage(
                                            isStudent: logic.isStudent)))
                                    : TextTab(
                                        text: 'Withdraw'.tr,
                                        onTap: () => Get.to(WithdrawPage(
                                            isStudent: logic.isStudent))),
                                TextTab(
                                    text: 'Change password'.tr,
                                    onTap: () => Get.to(ChangePasswordPage())),
                              ]),
                              buildContainer([
                                TextTab(
                                    text: HiveController.getIsStudent()
                                        ? 'Become a Tutor'
                                        : 'Become a Student'.tr,
                                    isStudent: logic.isStudent,
                                    onTap: () => logic.changeProfile()),
                                if (!HiveController.getIsStudent())
                                  TextTab(
                                      text: 'View profile'.tr,
                                      onTap: () => Get.to(ViewProfilePage(
                                            slug: logic.userModel?.slug,
                                          ))),
                                TextTab(
                                    text: 'Refer a friend'.tr,
                                    onTap: () => Get.to(ReferFriendPage())),
                              ]),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
            ),
          ),
          if (HiveController.getToken() != null)
            Positioned(
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetBuilder<MainLogic>(
                      init: Get.find<MainLogic>(),
                      builder: (logic) {
                        return GestureDetector(
                          onTap: () => logic.addImage(),
                          child: Container(
                              width: 110.h,
                              height: 110.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.h),
                                  color: logic.userModel?.status == 'active' ||
                                          !logic.isProfileLoading
                                      ? greenColor
                                      : Colors.white),
                              padding: EdgeInsets.all(
                                  logic.userModel?.status == 'active' ? 3 : 0),
                              child: logic.isProfileLoading
                                  ? const SizedBox(
                                      child: Center(
                                        child: SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            color: secondaryColor,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.h),
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: CustomImage(
                                              fit: BoxFit.cover,
                                              width: 110.h,
                                              height: 110.h,
                                              url: logic.userModel?.imageUrl,
                                            ),
                                          ),
                                        ],
                                      ))),
                        );
                      }),
                ],
              ),
            ),
          if (HiveController.getToken() != null)
            PositionedDirectional(
              top: 80.h,
              start: 80.w,
              end: 0,
              child: GetBuilder<MainLogic>(
                  init: Get.find<MainLogic>(),
                  builder: (logic) {
                    return GestureDetector(
                      onTap: () => logic.addImage(),
                      child: const CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: 15,
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.white,
                          )),
                    );
                  }),
            ),
        ],
      ),
    );
  }

  Container buildContainer(List<TextTab> list) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400, width: 0.5)),
      child: Column(
        children: mapIndexed<InkWell, TextTab>(
            list,
            (index, item) => InkWell(
                  onTap: item.onTap,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                                child: CustomText(
                              item.text,
                              fontSize: 14,
                              color: item.isStudent == null
                                  ? Colors.black
                                  : item.isStudent == true
                                      ? primaryColor
                                      : secondaryColor,
                              fontWeight: item.isStudent == null
                                  ? null
                                  : FontWeight.bold,
                            )),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey.shade400,
                              size: 15.sp,
                            ),
                          ],
                        ),
                      ),
                      if (index != list.length - 1)
                        Container(
                          width: double.infinity,
                          height: 0.5,
                          color: Colors.grey.shade400,
                        )
                    ],
                  ),
                )).toList(),
      ),
    );
  }
}

class TextTab {
  final String text;
  final bool? isStudent;
  final GestureTapCallback? onTap;

  TextTab({required this.text, this.isStudent, this.onTap});
}

Iterable<E> mapIndexed<E, T>(
    Iterable<T> items, E Function(int index, T item) f) sync* {
  var index = 0;

  for (final item in items) {
    yield f(index, item);
    index = index + 1;
  }
}
