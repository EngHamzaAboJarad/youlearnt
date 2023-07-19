import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:you_learnt/entities/CommonModel.dart';
import '../../../binding.dart';
import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../_main/view.dart';
import '../logic.dart';

class ChooseCountryPage extends StatelessWidget {
  final bool isFromProfile;

  const ChooseCountryPage({Key? key, required this.isFromProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Column(
        children: [
          Image.asset(
            iconLogo,
            width: 280.w,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: CustomText(
                    'What’s Your Country/Region?'.tr,
                    color: greyTextBoldColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Center(
                  child: CustomText(
                    'This helps ensure that timetables display correctly in your local time.'
                        .tr,
                    color: Colors.grey,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomText(
                  'Choose Country'.tr,
                  fontSize: 16,
                ),
                const SizedBox(
                  height: 5,
                ),
                GetBuilder<AuthLogic>(builder: (logic) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CommonModel>(
                          isExpanded: true,
                          hint: CustomText(
                            logic.recommendedCountry?.name ?? 'Country'.tr,
                            fontSize: 16,
                            color: logic.recommendedCountry != null
                                ? Colors.black
                                : Colors.grey.shade700,
                          ),
                          //   value: list[0],
                          items: logic.countriesList
                              .map((e) => DropdownMenuItem<CommonModel>(
                                    child: CustomText(e.name),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (val) => logic.onChangeRecommendedCountry(val)),
                    ),
                  );
                }),
              ],
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
                        borderRadius: BorderRadius.circular(2), color: Colors.white),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2), color: Colors.white),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 24,
                    height: 4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2), color: Colors.white),
                  ),
                  const Spacer(),
                  GetBuilder<AuthLogic>(
                      id: 'Recommendations',
                      builder: (logic) {
                        return logic.isAddRecommendLoading
                            ? const CircularProgressIndicator()
                            : GestureDetector(
                                onTap: () {
                                  logic.addStudentRecommendations();

                                },
                                child: CustomText(
                                  'Get Started'.tr,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              );
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
