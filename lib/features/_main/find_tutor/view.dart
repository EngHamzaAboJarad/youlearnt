import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:you_learnt/features/_main/logic.dart';
import 'package:you_learnt/features/_main/widgets/header_widget.dart';
import 'package:you_learnt/features/_main/widgets/tutors_filter_widget.dart';

import '../../../constants/colors.dart';
import '../../../sub_features/item_tutor.dart';
import '../../../utils/custom_widget/custom_text.dart';
import 'logic.dart';

class FindTutorPage extends StatelessWidget {
  final logic = Get.find<FindTutorLogic>();

  FindTutorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (logic.tutorList.isEmpty) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.bottomSheet(const TutorsFilters(), isScrollControlled: true);
      });
    }
    return GetBuilder<FindTutorLogic>(
        init: Get.find<FindTutorLogic>(),
        builder: (logic) {
          return Container(
            color: secondaryColor,
            child: Column(
              children: [
                HeaderWidget(titleBig: 'Find Tutor'.tr, titleSmall: ''.tr),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                    child: logic.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            strokeWidth: 1,
                          ))
                        : RefreshIndicator(
                            onRefresh: () async {
                              logic.selectedSubject = null;
                              logic.selectedCountry = null;
                              Get.find<MainLogic>().searchController.text = '';
                              logic.tutorList = [];
                              logic.update();
                            },
                            child: SingleChildScrollView(
                              controller: logic.scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  // const TutorsFilters(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 20),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CustomText(
                                            'Result'.tr,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              childAspectRatio: 0.58),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(10),
                                      itemCount: logic.tutorList.length,
                                      itemBuilder: (context, index) {
                                        return ItemTutor(
                                          tutor: logic.tutorList[index],
                                          horizintal: false,
                                        );
                                      }),
                                  if (logic.isUnderLoading)
                                    Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
