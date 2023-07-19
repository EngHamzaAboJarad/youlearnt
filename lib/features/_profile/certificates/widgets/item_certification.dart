import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/data/hive/hive_controller.dart';
import 'package:you_learnt/entities/CertificationModel.dart';
import 'package:you_learnt/features/_profile/certificates/logic.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/images.dart';
import '../../../../utils/custom_widget/custom_button_widget.dart';
import '../../../../utils/custom_widget/custom_image.dart';
import '../../../../utils/custom_widget/custom_text.dart';

class ItemCertification extends StatelessWidget {
  final CertificationModel cer;

  const ItemCertification({Key? key, required this.cer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CertificatesLogic>(builder: (logic) {
      var isStudent = HiveController.getIsStudent();
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
                          'Subject'.tr,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(logic.getSubjectName(cer.id)),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                    if (!isStudent)
                      GestureDetector(
                          onTap: () => logic.toggleMenu(cer),
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
                          'Issued by'.tr,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomText(cer.issuedBy.text),
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
                        CustomText(cer.issuedDate),
                      ],
                    )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CustomImage(
                    url: cer.imageUrl,
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
                          color: cer.status == 'Hidden' ? Colors.red : greenColor,
                          width: 1)),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: CustomText(
                    cer.status == 'Hidden'
                        ? 'Education Not Verified'
                        : 'Education Verified'.tr,
                    fontSize: 16,
                    color: cer.status == 'Hidden' ? Colors.red : greenColor,
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
                  width: cer.openMenu ? 110.w : 0,
                  height: cer.openMenu ? null : 0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
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
                        onTap: () => logic.deleteCertification(cer.id),
                        child: Container(
                          width: double.infinity,
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
