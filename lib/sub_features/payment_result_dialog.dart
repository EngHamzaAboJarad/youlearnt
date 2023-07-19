import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/constants/images.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';

class PaymentResultDialog extends StatelessWidget {
  final bool success;
  const PaymentResultDialog({required this.success , Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.4,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(25),
        topLeft: Radius.circular(25),
      )),
      child: Column(
        children: [
          SizedBox(height:Get.height * 0.05 ,),
          CustomText('Thanks for purchasing!'.tr , fontWeight: FontWeight.bold,fontSize: 18,),
          SizedBox(height:Get.height * 0.05 ,),
          Image.asset(
            iconSuccess,
            scale: 2,
          ),
        ],
      ),
    );
  }
}
