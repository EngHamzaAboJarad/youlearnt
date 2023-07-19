import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/images.dart';
import '../../../../entities/EducationModel.dart';
import '../../../../utils/custom_widget/custom_text.dart';
import '../../../../utils/custom_widget/custom_text_field.dart';
import '../../../../utils/validation/validation.dart';
import '../logic.dart';

class ItemEducationForm extends StatelessWidget {
  final int index;
  final EducationModel education;

  const ItemEducationForm(
      {Key? key, required this.index, required this.education})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EducationLogic>(builder: (logic) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CustomText(
                  'University'.tr,
                  fontSize: 16,
                ),
              ),
              if (logic.newEducationsList.length > 1)
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
          //   hintText: 'E.g., University of Cambridge'.tr,
          //   controller: education.university,
          //   validator: Validation.fieldValidate,
          // ),

          Container(
            decoration: BoxDecoration(
                // color: widget.color,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300)),
            child: Autocomplete<String>(
                displayStringForOption: (value) =>
                    education.university.text = value,
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text.length < 3) {
                    return const Iterable<String>.empty();
                  }
                  await logic.getBackgroundHelperEducation(
                      type: "education", searchKey: textEditingValue.text);
                  return logic.backgroundHelperList;
                },
                onSelected: (String selection) {
                  debugPrint('You just selected $selection');
                  education.university.text = selection;
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'E.g., University of Cambridge'.tr,
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
            'Degree'.tr,
            fontSize: 16,
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
                    education.degreeType.text.isEmpty == true
                        ? 'choose'.tr
                        : education.degreeType.text,
                    fontSize: 16,
                    color: education.degreeType.text.isEmpty
                        ? Colors.grey.shade700
                        : Colors.black,
                  ),
                  items: logic.list
                      .map((e) => DropdownMenuItem<String>(
                            child: CustomText(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (val) => logic.onChangeType(val, index)),
            ),
          ),
          if (logic.showOtherTextField)
            const SizedBox(
              height: 10,
            ),
          if (logic.showOtherTextField)
            CustomText(
              'Your other degree'.tr,
              fontSize: 16,
            ),
          if (logic.showOtherTextField)
            const SizedBox(
              height: 5,
            ),
          if (logic.showOtherTextField)
            CustomTextField(
              hintText: 'Please specify'.tr,
              controller: education.degreeType,
              validator: Validation.fieldValidate,
            ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            'Major'.tr,
            fontSize: 16,
          ),
          const SizedBox(
            height: 5,
          ),
          CustomTextField(
            hintText: 'E.g., Computer Science'.tr,
            controller: education.specialization,
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
            'Study years'.tr,
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
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () => logic.addImage(index),
            child: Stack(
              children: [
                DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    strokeWidth: 1,
                    dashPattern: const [6],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    color: Colors.grey.shade400,
                    child: education.educationImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(education.educationImage!),
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            ),
                          )
                        : Row(
                            children: [
                              Image.asset(
                                iconImage,
                                color: Colors.grey,
                                scale: 2,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              CustomText(
                                'Upload your education'.tr,
                                color: Colors.grey,
                              )
                            ],
                          )),
                if (education.educationImage != null)
                  PositionedDirectional(
                    end: 0,
                    child: GestureDetector(
                        onTap: () => logic.removeImage(index),
                        child: const Icon(
                          Icons.highlight_remove_outlined,
                          size: 30,
                        )),
                  )
              ],
            ),
          ),
          if ((logic.newEducationsList.length - 1) != index)
            const SizedBox(height: 10),
          if ((logic.newEducationsList.length - 1) != index)
            const Divider(color: Colors.black),
          const SizedBox(height: 20),
        ],
      );
    });
  }
}
