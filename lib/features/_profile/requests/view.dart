import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/_profile/logic.dart';
import 'package:you_learnt/features/_profile/requests/student/teacherRequts/view.dart';

import '../../../constants/colors.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    'Requests'.tr,
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
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25))),
                child: GetBuilder<ProfileLogic>(
                    init: Get.find<ProfileLogic>(),
                    id: 'posts',
                    builder: (logic) {
                      return logic.isLoading
                          ? const SizedBox(
                              height: 20,
                              child: SizedBox(
                                  child: Center(
                                      child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ))))
                          : logic.postList.isEmpty
                              ? Center(
                                  child: CustomText(
                                      'You do not have any requests for tutors'
                                          .tr))
                              : ListView.builder(
                                  itemCount: logic.postList.length,
                                  itemBuilder: (context, index) => Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey.shade300),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    'Title'.tr,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  CustomText(
                                                    logic.postList[index].title,
                                                    color: greyTextColor,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  CustomText(
                                                    'Expected budget'.tr,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  CustomText(
                                                    "\$${logic.postList[index].startPrice ?? ''} - \$${logic.postList[index].endPrice ?? ''}",
                                                    color: greyTextColor,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  CustomText(
                                                    'Details'.tr,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  CustomText(
                                                    logic.postList[index]
                                                        .description,
                                                    color: greyTextColor,
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  CustomButtonWidget(
                                                      title: 'Show Offers'.tr,
                                                      // color: secondaryColor,
                                                      onTap: () {
                                                        // AddNewClassRoomPage
                                                        Get.to( 
                                                           ShowTeacherRequtesToStudentPage(postModel: logic.postList[index] ,));
                                                        //   Get.to(
                                                        // AddBlogPage(
                                                        //   edit: false,
                                                        // ),
                                                      }),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
