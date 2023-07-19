import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:you_learnt/core/helper_methods.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/images.dart';
import '../../../../entities/CommonModel.dart';
import '../../../../sub_features/add_subject_dialog.dart';
import '../../../../utils/custom_widget/custom_image.dart';
import '../../../../utils/custom_widget/custom_text.dart';
import '../../../../utils/custom_widget/custom_text_field.dart';
import '../../../../utils/functions.dart';
import '../../../../utils/validation/validation.dart';
import '../../../_main/logic.dart';
import '../../../page/view.dart';
import '../../teacher_profile_subjects/logic.dart';

class ItemSubject extends StatelessWidget {
  final int index;

  ItemSubject({Key? key, required this.index}) : super(key: key);

  final HelperMethods _helperMethods = HelperMethods();

  // late VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<TeacherPrfileSubjectsLogic>(builder: (logic) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400, width: 1),
            borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                  'Subject title'.tr,
                  fontSize: 16,
                ),
                const Spacer(),
                IconButton(
                    onPressed: () => logic.removeSubject(index),
                    icon: const Icon(Icons.highlight_remove))
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CommonModel>(
                          isExpanded: true,
                          hint: CustomText(
                            logic.subjectsList[index].selectedSubject?.name ??
                                'choose'.tr,
                            fontSize: 16,
                            color: logic.subjectsList[index].selectedSubject !=
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
                          onChanged: (val) =>
                              logic.onChangeSubject(val, index)),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Get.bottomSheet(AddSubjectDialog()).then((value) {
                        if (value != null) {
                          log(value.toString());
                          var subject = CommonModel.fromJson(value);
                          logic.subjectsList[index].selectedSubject = subject;
                          logic.update();
                        }
                      });
                    },
                    icon: const Icon(Icons.add_box_outlined))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              'Certification Hour'.tr,
              fontSize: 16,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTextField(
              keyboardType: TextInputType.number,
              onChanged: (s) {
                logic.subjectsList[index].certificationHourController.text =
                    replaceArabicNumber(s);
                logic.subjectsList[index].certificationHourController
                        .selection =
                    TextSelection.fromPosition(TextPosition(
                        offset: logic.subjectsList[index]
                            .certificationHourController.text.length));
              },
              maxLength: 3,
              validator: Validation.fieldValidate,
              controller: logic.subjectsList[index].certificationHourController,
              fontSize: 14,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              'Hourly rate'.tr,
              fontSize: 16,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTextField(
              hintText: '\$',
              keyboardType: TextInputType.number,
              onChanged: (s) {
                logic.subjectsList[index].hourRateController.text =
                    replaceArabicNumber(s);
                logic.subjectsList[index].hourRateController.selection =
                    TextSelection.fromPosition(TextPosition(
                        offset: logic.subjectsList[index].hourRateController
                            .text.length));
              },
              prefixIcon: const Icon(Icons.attach_money),
              maxLength: 3,
              validator: Validation.fieldValidate,
              controller: logic.subjectsList[index].hourRateController,
              fontSize: 14,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              'Description'.tr,
              fontSize: 16,
            ),
            const SizedBox(
              height: 5,
            ),
            CustomTextField(
              hintText: 'Description',
              keyboardType: TextInputType.number,
              validator: Validation.fieldValidate,
              controller: logic.subjectsList[index].descriptionController,
              fontSize: 14,
            ),
            /*
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.grey.shade300)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: CustomText(
                                        'choose'.tr,
                                        fontSize: 16,
                                        color: Colors.grey.shade700,
                                      ),
                                      //   value: list[0],
                                      items: list
                                          .map((e) => DropdownMenuItem<String>(
                                                child: CustomText(e),
                                                value: e,
                                              ))
                                          .toList(),
                                      onChanged: (val) {}),
                                ),
                              ),*/
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    'Subject Videos'.tr,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                    onPressed: () => Get.to(PagePage(
                          pageModel: Get.find<MainLogic>().recommendationsPage,
                          type: 1,
                        )),
                    icon: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.question_mark,
                          size: 18,
                        )))
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            CustomText(
              'Url Videos'.tr,
              fontSize: 14,
            ),
            const SizedBox(
              height: 5,
            ),
            ListView.builder(
                itemCount:
                    logic.subjectsList[index].youtubeLinkControllerList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index2) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: 'Insert your video URL here'.tr,
                              keyboardType: TextInputType.url,
                              validator: Validation.fieldValidate,
                              controller: logic.subjectsList[index]
                                  .youtubeLinkControllerList[index2],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              log(logic.subjectsList[index]
                                  .youtubeLinkControllerList[index2].text
                                  .toString());
                              // return;
                              _helperMethods.showAlertDilog(
                                  message:
                                      "Are you sure to delete this video ?",
                                  title: "Alert!".tr,
                                  context: context,
                                  function: () {
                                    logic.deleteSubjectItem(
                                        subjectId:
                                            logic.subjectsList[index].id!,
                                        url: logic
                                            .subjectsList[index]
                                            .youtubeLinkControllerList[index2]
                                            .text
                                            .toString(),
                                        type: "youtube",
                                        subjectIndex: index,
                                        subjectItemIndex: index2);
                                  });
                            },
                            child: const Icon(
                              Icons.highlight_remove,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    )),
            CustomText(
              '(MUST be related to the subject you are teaching)'.tr,
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
            InkWell(
              onTap: () => logic.addNewLink(index),
              child: Row(
                children: [
                  const Spacer(),
                  const Icon(
                    Icons.add,
                    color: secondaryColor,
                    size: 15,
                  ),
                  CustomText(
                    'Add another video URL'.tr,
                    fontSize: 12,
                    color: secondaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              'Uploaded Videos'.tr,
              fontSize: 14,
            ),
            logic.subjectsList[index].uploadedVideos.isEmpty
                ? Center(
                    child: Container(
                        padding: const EdgeInsets.all(8),
                        child: CustomText("No uploaded videos.".tr)),
                  )
                : Wrap(
                    direction: Axis.horizontal,
                    children: List.generate(
                        logic.subjectsList[index].uploadedVideos.length,
                        (indexVideo) {
                      // if (logic.subjectsList[index].uploadedVideos.contains("http")) {
                      //   _controller = VideoPlayerController.network(
                      //       logic.subjectsList[index].uploadedVideos[indexVideo])
                      //     ..initialize().then((_) {});
                      // } else {
                      //   _controller = VideoPlayerController.file(File(
                      //       logic.subjectsList[index].uploadedVideos[indexVideo]));
                      // }
                      // VideoPlayerController _controller = VideoPlayerController.file(
                      //     File(logic.subjectsList[index].uploadedVideos[indexVideo]));
                      Future<void> _video = logic
                          .subjectsList[index].uploadedVideos[indexVideo]
                          .initialize();
                      return Stack(
                        children: [
                          InkWell(
                              onTap: () {
                                // stop another videos
                                logic.subjectsList[index].uploadedVideos
                                    .map((videoItem) {
                                  if (videoItem !=
                                      logic.subjectsList[index]
                                          .uploadedVideos[indexVideo]) {
                                    videoItem.pause();
                                    // videoItem.
                                  }
                                }).toList();

                                logic
                                        .subjectsList[index]
                                        .uploadedVideos[indexVideo]
                                        .value
                                        .isPlaying
                                    ? logic.subjectsList[index]
                                        .uploadedVideos[indexVideo]
                                        .pause()
                                    : logic.subjectsList[index]
                                        .uploadedVideos[indexVideo]
                                        .play();
                                // logic.update();
                              },
                              child: Container(
                                width: 120,
                                height: 150,
                                margin: const EdgeInsets.all(4),
                                // clipBehavior: ,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12)),
                                child: FutureBuilder(
                                  future: _video,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        // width: double.infinity,
                                        child: AspectRatio(
                                          aspectRatio: logic
                                              .subjectsList[index]
                                              .uploadedVideos[indexVideo]
                                              .value
                                              .aspectRatio,
                                          child: VideoPlayer(logic
                                              .subjectsList[index]
                                              .uploadedVideos[indexVideo]),
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                              )),
                          // Positioned(
                          //     left: 10,
                          //     top: 10,
                          //     bottom: 10,
                          //     right: 10,
                          //     child: Icon(
                          //       !logic.subjectsList[index].uploadedVideos[indexVideo]
                          //               .value.isPlaying
                          //           ? Icons.play_arrow
                          //           : Icons.pause,
                          //       color: Colors.black,
                          //     )),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: InkWell(
                              onTap: () {
                                log(logic.subjectsList[index]
                                    .uploadedVideos[indexVideo].dataSource
                                    .toString());
                                    // return ;
                                if (logic.subjectsList[index]
                                    .uploadedVideos[indexVideo].dataSource
                                    .toString()
                                    .contains("http")) {
                                } else {
                                  _helperMethods.showAlertDilog(
                                      message:
                                          "Are you sure to delete this video ?"
                                              .tr,
                                      title: "Alert!".tr,
                                      context: context,
                                      function: () {
                                        logic.deletedLocalVide(
                                            subjectIndex: index,
                                            videoIndex: indexVideo);
                                      });
                                }

                                // return;
                                // _helperMethods.showAlertDilog(
                                //     message: "Are you sure to delete this image ?",
                                //     title: "Alert!".tr,
                                //     context: context,
                                //     function: () {
                                //       logic.deleteSubjectItem(
                                //           subjectId: logic.subjectsList[index].id!,
                                //           url: logic.subjectsList[index]
                                //               .imagesUrl[indexVideo],
                                //           type: "image",
                                //           subjectIndex: index,
                                //           subjectItemIndex: indexVideo);
                                //     });
                              },
                              child: const Icon(
                                Icons.highlight_remove,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              '(MUST be related to the subject you are teaching)'.tr,
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
            InkWell(
              onTap: () => logic.addNewUploadedVideo(index),
              child: Row(
                children: [
                  const Spacer(),
                  const Icon(
                    Icons.add,
                    color: secondaryColor,
                    size: 15,
                  ),
                  CustomText(
                    'upload another video'.tr,
                    fontSize: 12,
                    color: secondaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomText(
                    'Subject Pictures'.tr,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                    onPressed: () => Get.to(PagePage(
                          pageModel: Get.find<MainLogic>().recommendationsPage,
                          type: 2,
                        )),
                    icon: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(2),
                        child: const Icon(
                          Icons.question_mark,
                          size: 18,
                        )))
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Wrap(
              direction: Axis.horizontal,
              children: List.generate(logic.subjectsList[index].images.length,
                  (indexImage) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25, right: 20),
                      child: InkWell(
                        onTap: () => logic.addImage(index, indexImage),
                        child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            strokeWidth: 1,
                            dashPattern: const [6],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            color: Colors.grey.shade400,
                            child: SizedBox(
                              // margin: const EdgeInsets.only(right: 10),
                              height: 100,
                              width: size.width * .2,
                              child: logic.subjectsList[index]
                                              .images[indexImage] !=
                                          null &&
                                      !(logic.subjectsList[index]
                                              .images[indexImage]
                                              ?.contains('http') ==
                                          true)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(logic.subjectsList[index]
                                            .images[indexImage]!),
                                        width: double.infinity,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )
                                  : logic.subjectsList[index]
                                                  .images[indexImage] !=
                                              null &&
                                          (logic.subjectsList[index]
                                                  .images[indexImage]
                                                  ?.contains('http') ==
                                              true)
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: CustomImage(
                                            url: logic.subjectsList[index]
                                                .images[indexImage],
                                            // size: 100,
                                            width: double.infinity,
                                            // height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Image.asset(
                                              iconImage,
                                              color: Colors.grey,
                                              scale: 2,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            CustomText(
                                              'Add Picture'.tr,
                                              color: Colors.grey,
                                            )
                                          ],
                                        ),
                            )),
                      ),
                    ),
                    // if (logic.subjectsList[index].images[indexImage] != null &&
                    //     (logic.subjectsList[index].images[indexImage]
                    //             ?.contains('http') ==
                    //         true))
                    Positioned(
                      right: 20,
                      top: 1,
                      child: InkWell(
                        onTap: () {
                          log(logic.subjectsList[index].imagesUrl[indexImage]
                              .toString());
                          // return;
                          _helperMethods.showAlertDilog(
                              message: "Are you sure to delete this image ?",
                              title: "Alert!".tr,
                              context: context,
                              function: () {
                                logic.deleteSubjectItem(
                                    subjectId: logic.subjectsList[index].id!,
                                    url: logic.subjectsList[index]
                                        .imagesUrl[indexImage],
                                    type: "image",
                                    subjectIndex: index,
                                    subjectItemIndex: indexImage);
                              });
                        },
                        child: const Icon(
                          Icons.highlight_remove,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            // ListView.builder(
            //   itemCount: logic.subjectsList[index].images.length,
            //   shrinkWrap: true,
            //   padding: EdgeInsets.zero,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemBuilder: (BuildContext context, int indexImage) {
            //     return Padding(
            //       padding: const EdgeInsets.only(bottom: 10),
            //       child: InkWell(
            //         onTap: () => logic.addImage(index, indexImage),
            //         child: DottedBorder(
            //             borderType: BorderType.RRect,
            //             radius: const Radius.circular(10),
            //             strokeWidth: 1,
            //             dashPattern: const [6],
            //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            //             color: Colors.grey.shade400,
            //             child: SizedBox(
            //               height: 100,
            //               child: logic.subjectsList[index].images[indexImage] != null &&
            //                       !(logic.subjectsList[index].images[indexImage]
            //                               ?.contains('http') ==
            //                           true)
            //                   ? ClipRRect(
            //                       borderRadius: BorderRadius.circular(10),
            //                       child: Image.file(
            //                         File(logic.subjectsList[index].images[indexImage]!),
            //                         width: double.infinity,
            //                         fit: BoxFit.fitWidth,
            //                       ),
            //                     )
            //                   : logic.subjectsList[index].images[indexImage] != null &&
            //                           (logic.subjectsList[index].images[indexImage]
            //                                   ?.contains('http') ==
            //                               true)
            //                       ? ClipRRect(
            //                           borderRadius: BorderRadius.circular(10),
            //                           child: CustomImage(
            //                             url: logic.subjectsList[index].images[indexImage],
            //                             width: double.infinity,
            //                             fit: BoxFit.fitWidth,
            //                           ),
            //                         )
            //                       : Row(
            //                           children: [
            //                             const SizedBox(
            //                               width: 10,
            //                             ),
            //                             Image.asset(
            //                               iconImage,
            //                               color: Colors.grey,
            //                               scale: 2,
            //                             ),
            //                             const SizedBox(
            //                               width: 10,
            //                             ),
            //                             CustomText(
            //                               'Add Picture'.tr,
            //                               color: Colors.grey,
            //                             )
            //                           ],
            //                         ),
            //             )),
            //       ),
            //     );
            //   },
            // ),
            const SizedBox(
              height: 5,
            ),
            CustomText(
              '(MUST be related to the subject you are teaching)'.tr,
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
            InkWell(
              onTap: () => logic.addNewImage(index),
              child: Row(
                children: [
                  const Spacer(),
                  const Icon(
                    Icons.add,
                    color: secondaryColor,
                    size: 15,
                  ),
                  CustomText(
                    'Add another picture'.tr,
                    fontSize: 12,
                    color: secondaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }
}
