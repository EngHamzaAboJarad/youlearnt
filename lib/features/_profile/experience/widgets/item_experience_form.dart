import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/entities/ExperienceModel.dart';

import '../../../../utils/custom_widget/custom_text.dart';
import '../../../../utils/custom_widget/custom_text_field.dart';
import '../../../../utils/validation/validation.dart';
import '../logic.dart';

class ItemExperienceForm extends StatelessWidget {
  final int index;
  final ExperienceModel education;

  const ItemExperienceForm(
      {Key? key, required this.index, required this.education})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExperienceLogic>(builder: (logic) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CustomText(
                  'Position'.tr,
                  fontSize: 16,
                ),
              ),
              if (logic.newExperienceList.length > 1)
                GestureDetector(
                    onTap: () => logic.removeEducation(index),
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Icon(Icons.close),
                    ))
            ],
          ),
          const SizedBox(
            height: 5,
          ),

          // CustomTextField(
          //   hintText: 'E.g., Software developer'.tr,
          //   controller: education.position,
          //   validator: Validation.fieldValidate,
          // ),
          Container(
            decoration: BoxDecoration(
                // color: widget.color,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300)),
            child: Autocomplete<String>(
                displayStringForOption: (value) =>
                    education.position.text = value,
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text.length < 3) {
                    return const Iterable<String>.empty();
                  }
                  await logic.getBackgroundHelperExperince(
                      type: "experience", searchKey: textEditingValue.text);
                  return logic.backgroundHelperList;
                },
                onSelected: (String selection) {
                  debugPrint('You just selected $selection');
                  education.position.text = selection;
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'E.g., Software developer'.tr,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10)),
                    // decoratteion: const InputDecoration(border: OutlineInputBorder()),
                    controller: textEditingController,
                    focusNode: focusNode,

                    onSubmitted: (String value) {},
                  );
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            'Company'.tr,
            fontSize: 16,
          ),
          const SizedBox(
            height: 5,
          ),
          CustomTextField(
            //       hintText: 'E.g., Computer Science'.tr,
            controller: education.company,
            validator: Validation.fieldValidate,
          ),
          const SizedBox(
            height: 10,
          ),

          /*CustomText(
                                  'Degree'.tr,
                                  fontSize: 16,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomTextField(
                                  hintText: 'Degree'.tr,
                                  controller: education.degree,
                                  validator: Validation.fieldValidate,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),*/

          CustomText(
            'Work date'.tr,
            fontSize: 16,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => logic.pickDate(context, true, index),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: CustomText(
                      education.startAt ?? 'Started Date'.tr,
                      color: education.startAt == null
                          ? Colors.grey
                          : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () => logic.pickDate(context, false, index),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: CustomText(
                      education.endAt ?? 'Ended Date'.tr,
                      color:
                          education.endAt == null ? Colors.grey : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if ((logic.newExperienceList.length - 1) != index)
            const SizedBox(height: 10),
          if ((logic.newExperienceList.length - 1) != index)
            const Divider(color: Colors.black),
          const SizedBox(height: 20),
        ],
      );
    });
  }
}
