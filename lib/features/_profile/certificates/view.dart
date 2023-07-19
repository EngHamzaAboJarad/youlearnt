
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/entities/CertificationModel.dart';
import 'package:you_learnt/features/_profile/certificates/widgets/item_certification.dart';
import 'package:you_learnt/features/_profile/certificates/widgets/item_certification_form.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'logic.dart';

class CertificatesPage extends StatelessWidget {
  final bool isStudent;
  final logic = Get.put(CertificatesLogic());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CertificatesPage({Key? key, required this.isStudent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isStudent) logic.getCertifications();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
      body: Container(
        color: secondaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'Profile'.tr,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  CustomText(
                    'Certificates'.tr,
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                child: GetBuilder<CertificatesLogic>(builder: (logic) {
                  return logic.isLoading
                      ? const SizedBox(
                          height: 20,
                          child: SizedBox(
                              child: Center(
                                  child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ))))
                      : Column(
                          children: [
                            Expanded(
                              child: isStudent
                                  ? ListView.builder(
                                      itemCount: 3,
                                      itemBuilder: (context, index) => Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey.shade400,
                                                    width: 0.5),
                                                borderRadius: BorderRadius.circular(10)),
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(bottom: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        CustomText(
                                                          'Subject'.tr,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const CustomText('teaches English'),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    )),
                                                    if (!isStudent)
                                                      GestureDetector(
                                                          onTap: () =>
                                                              logic.toggleMenu(index),
                                                          child: const Icon(
                                                            Icons.more_vert_outlined,
                                                            color: Colors.grey,
                                                          ))
                                                  ],
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        CustomText(
                                                          'Issued by'.tr,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const CustomText('teaches English'),
                                                      ],
                                                    )),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        CustomText(
                                                          'Issued Date'.tr,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        const CustomText('22-12-2020'),
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(15),
                                                  child: Image.asset(imageCer),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(5),
                                                      border: Border.all(
                                                          color: secondaryColor,
                                                          width: 1)),
                                                  padding:
                                                      const EdgeInsets.symmetric(vertical: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        iconDownload,
                                                        scale: 2,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      CustomText(
                                                        'download'.tr,
                                                        color: secondaryColor,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                  : buildTutorCertification(logic, context),
                            ),
                            if (!isStudent)
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 10, right: 10, bottom: 30.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: CustomButtonWidget(
                                      title: 'Cancel'.tr,
                                      color: Colors.white,
                                      textColor: primaryColor,
                                      widthBorder: 0.5,
                                      onTap: () {
                                        logic.newCertificationsList = [CertificationModel()];
                                        Get.back();
                                      },
                                    )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: CustomButtonWidget(
                                      title: 'Save'.tr,
                                      loading: logic.isAddLoading,
                                      onTap: () {
                                        if (_formKey.currentState?.validate() == true) {
                                          logic.addCertification();
                                        }
                                      },
                                    )),
                                  ],
                                ),
                              ),
                          ],
                        );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildTutorCertification(
      CertificatesLogic logic, BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (logic.certificationsList.isNotEmpty)
              const SizedBox(
                height: 10,
              ),
            if (logic.certificationsList.isNotEmpty)
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: logic.certificationsList.length,
                  itemBuilder: (context, index) =>
                      ItemCertification(cer: logic.certificationsList[index])),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              'Add a certification'.tr,
              fontSize: 20,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: logic.newCertificationsList.length,
                itemBuilder: (context, index) => ItemCertificationForm(
                      index: index,
                    )),
            InkWell(
              onTap: () => logic.addNewCertification(),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secondaryLightColor.withOpacity(0.3)),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: CustomText(
                  logic.newCertificationsList.length > 1
                      ? '+ Add another certification'.tr
                      : '+ Add certification'.tr,
                  color: secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
