import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../entities/CommonModel.dart';
import '../features/_auth/logic.dart';
import '../utils/custom_widget/custom_button_widget.dart';
import '../utils/custom_widget/custom_text.dart';
import '../utils/custom_widget/custom_text_field.dart';
import '../utils/validation/validation.dart';

class AddSubjectDialog extends StatelessWidget {
  final bool category;

  AddSubjectDialog({Key? key, this.category = false}) : super(key: key);
  final GlobalKey<FormState> _subjectFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (context) => Form(
              key: _subjectFormKey,
              child: SingleChildScrollView(
                child: GetBuilder<AuthLogic>(
                    id: 'subjects',
                    init: Get.find<AuthLogic>(),
                    builder: (logic) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.arrow_back_ios_outlined,
                                    color: greyTextColor,
                                    size: 15,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  CustomText(
                                    'Back'.tr,
                                    fontSize: 16,
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: CustomText(
                                category ? 'Add new category'.tr : 'Add new subject'.tr,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              category
                                  ? 'You can suggest new category and it will be public after admin review'
                                      .tr
                                  : 'You can suggest new subject and it will be public after admin review'
                                      .tr,
                              fontSize: 13,
                              textAlign: TextAlign.center,
                              color: greyTextColor,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              category ? 'Category Name'.tr : 'Subject Name'.tr,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              hintText: 'Name'.tr,
                              keyboardType: TextInputType.name,
                              validator: Validation.nameValidate,
                              controller: logic.subjectNameController,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if(category)...[
                              CustomText(
                                'Subject'.tr,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
                                        logic.selectedSubject?.name ?? 'Select'.tr,
                                        fontSize: 16,
                                        color: logic.selectedSubject != null
                                            ? Colors.black
                                            : Colors.grey.shade700,
                                      ),
                                      //   value: list[0],
                                      items: logic.subjectsWithoutAddList
                                          .map((e) => DropdownMenuItem<CommonModel>(
                                        child: CustomText(e.name),
                                        value: e,
                                      ))
                                          .toList(),
                                      onChanged: (val) => logic.onChangeSubject(val)),
                                ),
                              )
                            ],
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButtonWidget(
                                title: 'Add'.tr,
                                loading: logic.isCreateSubjectLoading,
                                onTap: () {
                                  if (_subjectFormKey.currentState?.validate() == true) {
                                    logic.createSubject(category);
                                  }
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ));
  }
}
