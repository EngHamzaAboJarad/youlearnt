import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:you_learnt/core/helper_methods.dart';
import 'package:you_learnt/utils/validation/validation.dart';

import '../../../../../constants/colors.dart';
import '../../../../../entities/SubjectModel.dart';
import '../../../../../utils/custom_widget/custom_button_widget.dart';
import '../../../../../utils/custom_widget/custom_text.dart';
import '../../../../../utils/custom_widget/custom_text_field.dart';
import '../../../../_auth/logic.dart';
import '../../logic.dart';

class AddNewClassRoomPage extends StatefulWidget {
  final bool edit;

  const AddNewClassRoomPage({Key? key, required this.edit}) : super(key: key);

  @override
  State<AddNewClassRoomPage> createState() => _AddNewClassRoomPageState();
}

class _AddNewClassRoomPageState extends State<AddNewClassRoomPage> {
  // final logic = Get.find<WithdrawDepositLogic>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode focusNode = FocusNode();

  AuthLogic authLogic = Get.find();

  //  await Get.find<MainLogic>().getProfile()
  final HelperMethods _helperMethods = HelperMethods();

  @override
  void initState() {
    // TODO: implement initState
    if (!widget.edit) {
      Get.find<ClassroomsLogic>().clearAddNewClassRoom();
    }
    super.initState();
  }

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
                    'Add Classroom'.tr,
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
                child: GetBuilder<ClassroomsLogic>(
                    init: Get.find<ClassroomsLogic>(),
                    id: 'addNewClassRoom',
                    builder: (logic) {
                      return SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                "Title".tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                hintText: '',
                                controller: logic.titleController,
                                validator: Validation.fieldValidate,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                "Description".tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                hintText: '',
                                controller: logic.descrptionController,
                                validator: Validation.fieldValidate,
                                keyboardType: TextInputType.text,
                                maxLines: 5,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (!widget.edit)
                                Column(
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Colors.grey.shade300)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<SubjectModel>(
                                            isExpanded: true,
                                            hint: CustomText(
                                              logic.selectedSubject
                                                      ?.subjectName ??
                                                  'choose'.tr,
                                              fontSize: 16,
                                              color:
                                                  logic.selectedSubject != null
                                                      ? Colors.black
                                                      : Colors.grey.shade700,
                                            ),
                                            //   value: list[0],
                                            items: logic.teacherModel?.subjects
                                                ?.map((e) => DropdownMenuItem<
                                                        SubjectModel>(
                                                      child: CustomText(
                                                          e.subjectName),
                                                      value: e,
                                                    ))
                                                .toList(),
                                            onChanged: (val) =>
                                                logic.onChangeSubject(val)),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              if (!widget.edit)
                                Column(
                                  children: [
                                    const Divider(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomText(
                                            'Classroom times'.tr,
                                            fontSize: 16,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            logic.openTimeDialog(
                                                type: "add-class-room",
                                                classroomId: null,
                                                bookId: null);
                                            log("clicked add time");
                                            // dateTimePickerWidget(
                                            //     context, logic);
                                          },
                                          child: Icon(
                                            Icons.add,
                                            color: mainColor,
                                            size: 30,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    logic.classRoomsTimes.isEmpty
                                        ? Center(
                                            child: CustomText(
                                              'Class room times not added yet!'
                                                  .tr,
                                              fontSize: 14,
                                            ),
                                          )
                                        : Column(
                                            children: List.generate(
                                                logic.classRoomsTimes.length,
                                                (index) => Card(
                                                      elevation: 2,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .all(8),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          // border: Border.all(
                                                          //     color: Colors
                                                          //         .grey.shade300),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      CustomText(
                                                                    "Start at :"
                                                                            .tr +
                                                                        logic.classRoomsTimes[index]
                                                                            [
                                                                            "start_at"],
                                                                    color:
                                                                        secondaryColor,
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    _helperMethods.showAlertDilog(
                                                                        message: "Are you sure to delete this time ?".tr,
                                                                        title: "Alert!",
                                                                        context: context,
                                                                        function: () {
                                                                          logic.deleteClassAddedTime(
                                                                              index);
                                                                        });
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            const Divider(),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            CustomText(
                                                              "End at :".tr +
                                                                  logic.classRoomsTimes[
                                                                          index]
                                                                      [
                                                                      "end_at"],
                                                              color: mainColor,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                          ),
                                    const Divider(),
                                  ],
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                'Max students'.tr,
                                fontSize: 16,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextField(
                                hintText: '',
                                controller: logic.maxStudentController,
                                validator: Validation.fieldValidate,
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (!widget.edit)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      'Price'.tr,
                                      fontSize: 16,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomTextField(
                                      hintText: '',
                                      controller: logic.priceController,
                                      validator: Validation.fieldValidate,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomButtonWidget(
                                title: widget.edit ? "Edit".tr : 'Add'.tr,
                                loading: logic.isLoading,
                                onTap: () {
                                  logic.addNewClassRoom(false);
                                  // if (_formKey.currentState?.validate() ==
                                  //     true) {
                                  //   logic.addNewClassRoom(edit);
                                  // }
                                },
                              ),
                              const SizedBox(
                                height: 45,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
