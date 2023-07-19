import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:you_learnt/features/_auth/logic.dart';
import 'package:you_learnt/utils/custom_widget/custom_image.dart';
import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../utils/custom_widget/custom_text.dart';

class ChooseLanguagesPage extends StatelessWidget {
  final bool isForRecommended;
  final bool isFromProfile;
  final AuthLogic logic = Get.find();

  ChooseLanguagesPage(
      {Key? key, required this.isForRecommended, required this.isFromProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: GetBuilder<AuthLogic>(
          id: 'languages',
          init: Get.find<AuthLogic>(),
          builder: (logic) {
            return Column(
              children: [
                Image.asset(
                  iconLogo,
                  width: 280.w,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          CustomText(
                            'What’s Your Native Language?'.tr,
                            color: greyTextBoldColor,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            'This will help to find tutors who speak the same language as you.'
                                .tr,
                            color: Colors.grey,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ListView.builder(
                              itemCount: logic.languagesList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => InkWell(
                                    onTap: () => logic.toggleLanguage(index),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: logic.languagesList[index].isSelected
                                            ? secondaryColor.withOpacity(0.1)
                                            : Colors.white,
                                        border: Border.all(
                                            color: logic.languagesList[index].isSelected
                                                ? secondaryColor
                                                : greyTextBoldColor,
                                            width: 0.5),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            logic.languagesList[index].isSelected
                                                ? iconCheck
                                                : iconUncheck,
                                            scale: 3,
                                            width: 20,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          CustomImage(
                                            url: logic.languagesList[index].flag,
                                            size: 15,
                                            width: 50,
                                            height: 40,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          CustomText(
                                            logic.languagesList[index].native,
                                            fontSize: 16,
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
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
                        const Spacer(),
                        logic.isToggleLanguageLoading
                            ? const CircularProgressIndicator()
                            : GestureDetector(
                                onTap: () =>
                                    logic.saveLanguage(isForRecommended, isFromProfile),
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
}
