import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/_main/find_tutor/logic.dart';

import '../../../entities/CommonModel.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../_auth/logic.dart';

class TutorsFilters extends StatelessWidget {
  const TutorsFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25))),
      builder: (BuildContext context) => GetBuilder<FindTutorLogic>(
          init: Get.find<FindTutorLogic>(), 
          builder: (logic) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Subject'.tr,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade300)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<CommonModel>(
                                    isExpanded: true,
                                    hint: CustomText(
                                      logic.selectedSubject?.name ?? 'choose'.tr,
                                      fontSize: 12,
                                      color: logic.selectedSubject != null
                                          ? Colors.black
                                          : Colors.grey.shade700,
                                    ),
                                    //   value: list[0],
                                    items: logic.authLogic.subjectsWithoutAddList
                                        .map((e) => DropdownMenuItem<CommonModel>(
                                              child: CustomText(e.name),
                                              value: e,
                                            ))
                                        .toList(),
                                    onChanged: (val) => logic.onChangeSubject(val)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Tutor native language'.tr,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade300)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<CommonModel>(
                                    isExpanded: true,
                                    hint: CustomText(
                                      logic.selectedLanguage?.native ?? 'choose'.tr,
                                      fontSize: 12,
                                      color: logic.selectedLanguage != null
                                          ? Colors.black
                                          : Colors.grey.shade700,
                                    ),
                                    //   value: list[0],
                                    items: logic.authLogic.languagesList
                                        .map((e) => DropdownMenuItem<CommonModel>(
                                              child: CustomText(e.native),
                                              value: e,
                                            ))
                                        .toList(),
                                    onChanged: (val) => logic.onChangeLanguage(val)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Speak'.tr,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade300)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<CommonModel>(
                                    isExpanded: true,
                                    hint: CustomText(
                                      logic.selectedSpeak?.native ?? 'choose'.tr,
                                      fontSize: 12,
                                      color: logic.selectedSpeak != null
                                          ? Colors.black
                                          : Colors.grey.shade700,
                                    ),
                                    //   value: list[0],
                                    items: logic.authLogic.languagesList
                                        .map((e) => DropdownMenuItem<CommonModel>(
                                              child: CustomText(e.native),
                                              value: e,
                                            ))
                                        .toList(),
                                    onChanged: (val) => logic.onChangeSpeak(val)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Country'.tr,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade300)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<CommonModel>(
                                    isExpanded: true,
                                    hint: CustomText(
                                      logic.selectedCountry?.name ?? 'choose'.tr,
                                      fontSize: 12,
                                      color: logic.selectedCountry != null
                                          ? Colors.black
                                          : Colors.grey.shade700,
                                    ),
                                    //   value: list[0],
                                    items: logic.authLogic.countriesList
                                        .map((e) => DropdownMenuItem<CommonModel>(
                                              child: CustomText(e.name),
                                              value: e,
                                            ))
                                        .toList(),
                                    onChanged: (val) => logic.onChangeCountry(val)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Price from'.tr,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade300)),
                              child: TextField(
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(color: Colors.grey.shade300),
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(Icons.attach_money)),
                                keyboardType: TextInputType.number,

                                controller: logic.fromController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Max price'.tr,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade300)),
                              child: TextField(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.attach_money),
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey.shade300),
                                ),
                                keyboardType: TextInputType.number,
                                controller: logic.toController,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Stated time'.tr,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () => showTimePicker(
                                      context: Get.context!,
                                      initialTime: const TimeOfDay(hour: 8, minute: 0))
                                  .then((value) => logic.onChangeStartedTime(value)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade300)),
                                child: CustomText(
                                  logic.startedTime ?? '00:00',
                                  color: logic.startedTime == null
                                      ? Colors.grey.shade200
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'End time'.tr,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () => showTimePicker(
                                      context: Get.context!,
                                      initialTime: const TimeOfDay(hour: 16, minute: 0))
                                  .then((value) => logic.onChangeEndTime(value)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade300)),
                                child: CustomText(
                                  logic.endTime ?? '00:00',
                                  color: logic.endTime == null
                                      ? Colors.grey.shade200
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Time zone'.tr,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade300)),
                              child: DropdownButtonHideUnderline(
                                child: GetBuilder<AuthLogic>(
                                    init: Get.find<AuthLogic>(),
                                    id: 'timezone',
                                    builder: (authLogic) {
                                      return DropdownButton<String>(
                                          isExpanded: true,
                                          hint: authLogic.isTimezoneLoading
                                              ? const CircularProgressIndicator(
                                                  strokeWidth: 1,
                                                )
                                              : CustomText(
                                                  logic.selectedTimezone ?? 'choose'.tr,
                                                  fontSize: 12,
                                                  color: logic.selectedTimezone != null
                                                      ? Colors.black
                                                      : Colors.grey.shade700,
                                                ),
                                          //   value: list[0],
                                          items: logic.authLogic.timezoneList
                                              .map((e) => DropdownMenuItem<String>(
                                                    child: CustomText(e),
                                                    value: e,
                                                  ))
                                              .toList(),
                                          onChanged: (val) =>
                                              logic.onChangeTimezone(val));
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Sort by'.tr,
                              fontSize: 14,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey.shade300)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: CustomText(
                                      logic.orderingSelected?.tr,
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    //   value: list[0],
                                    items: logic.orderingList
                                        .map((e) => DropdownMenuItem<String>(
                                      child: CustomText(e.tr),
                                      value: e,
                                    ))
                                        .toList(),
                                    onChanged: (val) => logic.onChangeOrdering(val)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButtonWidget(
                            title: 'Filter'.tr,
                            onTap: () {
                              logic.getTutors();
                              Get.back();
                            }),
                      ),
                      IconButton(onPressed: ()=>logic.restFilters(), icon: const Icon(Icons.highlight_remove))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            );
          }),
    );
  }
}
