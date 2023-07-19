import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/_profile/certificates/logic.dart';

import '../../../../constants/images.dart';
import '../../../../entities/CommonModel.dart';
import '../../../../utils/custom_widget/custom_text.dart';

class ItemCertificationForm extends StatelessWidget {
  final int index;

  const ItemCertificationForm({Key? key, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CertificatesLogic>(builder: (logic) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Subject'.tr,
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
              child: DropdownButton<CommonModel>(
                  isExpanded: true,
                  hint: CustomText(
                    logic.newCertificationsList[index].selectedSubject?.name ??
                        'choose'.tr,
                    fontSize: 16,
                    color: logic.newCertificationsList[index].selectedSubject !=
                            null
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
                  onChanged: (val) => logic.onChangeSubject(val, index)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            'Issued by'.tr,
            fontSize: 16,
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
                // color: widget.color,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300)),
            child: Autocomplete<String>(
                displayStringForOption: (value) =>
                    logic.newCertificationsList[index].issuedBy.text = value,
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text.length < 3) {
                    return const Iterable<String>.empty();
                  }
                  await logic.getBackgroundHelperCertifications(
                      type: "certification", searchKey: textEditingValue.text);
                  return logic.backgroundHelperList;
                },
                onSelected: (String selection) {
                  debugPrint('You just selected $selection');
                  logic.newCertificationsList[index].issuedBy.text = selection;
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                    // decoratteion: const InputDecoration(border: OutlineInputBorder()),
                    controller: textEditingController,
                    focusNode: focusNode,

                    onSubmitted: (String value) {},
                  );
                }),
          ),
          // CustomTextField(
          //   keyboardType: TextInputType.name,
          //   validator: Validation.fieldValidate,
          //   controller: logic.newCertificationsList[index].issuedBy,
          // ),
          const SizedBox(
            height: 10,
          ),
          CustomText(
            'Issued Date'.tr,
            fontSize: 16,
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () => logic.pickDate(context, index),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: CustomText(
                logic.newCertificationsList[index].issuedDate,
                color: logic.newCertificationsList[index].issuedDate == null
                    ? Colors.grey
                    : Colors.black,
                fontSize: 16,
              ),
            ),
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
                        horizontal: 10, vertical: 20),
                    color: Colors.grey.shade400,
                    child:
                        logic.newCertificationsList[index].certificationImage !=
                                null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(logic.newCertificationsList[index]
                                      .certificationImage!),
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
                                    'Upload your certificate'.tr,
                                    color: Colors.grey,
                                  )
                                ],
                              )),
                if (logic.newCertificationsList[index].certificationImage !=
                    null)
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
          if ((logic.newCertificationsList.length - 1) != index)
            const SizedBox(height: 10),
          if ((logic.newCertificationsList.length - 1) != index)
            const Divider(color: Colors.black),
          const SizedBox(height: 20),
        ],
      );
    });
  }
}
