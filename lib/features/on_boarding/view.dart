import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:you_learnt/constants/colors.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';

import '../../constants/images.dart';
import 'logic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingPage extends StatelessWidget {
  final logic = Get.put(OnBoardingLogic());

  OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          const SizedBox(
            height: 50,
          ),
          Image.asset(
            iconLogo,
            width: 280.w,
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: CustomText(
              'Perfect space for anyone to learn or teach anything, anytime, anywhere, in any language.'.tr,
              fontSize: 18,
              //color: greyTextColor,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          InkWell(
            onTap: () => logic.goToAuth(),
            borderRadius: BorderRadius.circular(30),
            child: const CircleAvatar(
              radius: 30,
              foregroundColor: Colors.white,
              backgroundColor: primaryColor,
              child: Icon(Icons.arrow_forward_ios),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
