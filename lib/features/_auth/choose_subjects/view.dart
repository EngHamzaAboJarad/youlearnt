import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/entities/CommonModel.dart';
import 'package:you_learnt/features/_auth/logic.dart';
import 'package:you_learnt/sub_features/add_subject_dialog.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';
import 'package:you_learnt/utils/custom_widget/custom_text_field.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/custom_widget/custom_image.dart';

class ChooseSubjectsPage extends StatelessWidget {
  final bool isFromProfile;

  ChooseSubjectsPage({Key? key, required this.isFromProfile}) : super(key: key);

  String? s;

  @override
  Widget build(BuildContext context) {
    Get.find<AuthLogic>().getStudentRecommendations();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: GetBuilder<AuthLogic>(
          id: 'subjects',
          init: Get.find<AuthLogic>(),
          builder: (logic) {
            return logic.isSubjectsLoading
                ? const LinearProgressIndicator()
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Image.asset(
                                  iconLogo,
                                  width: 280.w,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomText(
                                  'What Subjects Do You Want To Learn?'.tr,
                                  color: greyTextBoldColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomText(
                                  'You can add other subjects to your profile later.'.tr,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                CustomTextField(
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: 'Search courses'.tr,
                                  onChanged: (val) {
                                    s = val;
                                    logic.update(['subjects']);
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Builder(builder: (context) {
                                  List<CommonModel> subjectsList = [];
                                  if (s?.isNotEmpty == true) {
                                    logic.subjectsList.forEach((element) {
                                      if (element.name
                                              ?.toLowerCase()
                                              .contains(s!.toLowerCase()) ==
                                          true) {
                                        subjectsList.add(element);
                                      }
                                    });
                                    subjectsList.add(CommonModel.fromJson({}));
                                  } else {
                                    subjectsList.addAll(logic.subjectsList);
                                  }
                                  return GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3),
                                      itemCount: subjectsList.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var item = subjectsList[index];
                                        return buildGestureDetector(
                                            index, logic, item, subjectsList);
                                      });
                                })
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 80,
                        color: secondaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.white),
                              ),
                              const Spacer(),
                              logic.isSubjectsLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 1,
                                    )
                                  : GestureDetector(
                                      onTap: () => logic.goToChooseLanguages(isFromProfile),
                                      child: CustomText(
                                        'Next'.tr,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
          }),
    );
  }

  GestureDetector buildGestureDetector(
      int index, AuthLogic logic, CommonModel item, subjectsList) {
    return GestureDetector(
      onTap: () => index == subjectsList.length - 1
          ? Get.bottomSheet(AddSubjectDialog())
          : logic.toggleSubject(index),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: item.isSelected ? null : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(30),
                      border: item.isSelected
                          ? Border.all(color: secondaryColor, width: 1.5)
                          : null),
                  child: index == subjectsList.length - 1
                      ? const Icon(Icons.add)
                      : CustomImage(url: item.image)),
              if (item.isSelected)
                PositionedDirectional(
                    end: 0,
                    child: Image.asset(
                      iconCheck,
                      scale: 3.2,
                    ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            index == subjectsList.length - 1 ? 'ADD NEW'.tr : item.name,
            color: Colors.grey.shade700,
          )
        ],
      ),
    );
  }
}
