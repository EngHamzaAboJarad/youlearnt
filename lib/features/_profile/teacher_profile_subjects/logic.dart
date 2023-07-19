import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:you_learnt/entities/CommonModel.dart';
import 'package:you_learnt/features/_profile/logic.dart';

import '../../../data/remote/api_requests.dart';
import '../../../entities/SubjectModel.dart';
import '../../../utils/error_handler/error_handler.dart';
import '../../../utils/functions.dart';
import '../../_auth/logic.dart';
import '../../_main/logic.dart';
import 'package:image_picker/image_picker.dart';

class TeacherPrfileSubjectsLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final MainLogic mainLogic = Get.find();
  final AuthLogic authLogic = Get.find();
  final ProfileLogic profileLogic = Get.find();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController customLinkController = TextEditingController();
  final TextEditingController introduceYourSelfController =
      TextEditingController();
  final TextEditingController introduceYourSelfOtherLanguageController =
      TextEditingController();

  bool isLoading = false;
  List<SubjectModel> subjectsList = [SubjectModel()];

  final ImagePicker picker = ImagePicker();

  @override
  onInit() {
    initUserModel();
    super.onInit();
  }

  void updatePersonalInformation() async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.updateTeacherDescription(
          bio: bioController.text,
          publicLink: linkController.text,
          customLink: customLinkController.text,
          introduceYourSelf: introduceYourSelfController.text,
          introduceYourSelfOtherLanguage:
              introduceYourSelfOtherLanguageController.text,
          subject: subjectsList);
      Get.back();
      showMessage(res.data['message'].toString(), 1);
      await mainLogic.getProfile();
      initUserModel();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  onChangeSubject(CommonModel? val, int index) {
    subjectsList[index].selectedSubject = val;
    subjectsList[index].subjectId = val?.id;
    update();
  }

  void addNewSubject() {
    subjectsList.add(SubjectModel());
    update();
  }

  addImage(int index, int indexImage) async {
    try {
      XFile? image;
      final ImagePicker _picker = ImagePicker();
      image = await _picker.pickImage(source: ImageSource.gallery);
      subjectsList[index].images[indexImage] = image!.path;
      update();
    } catch (e) {
      log('image error => ${e.toString()}');
    }
  }

  void initUserModel() {
    bioController.text = mainLogic.userModel?.profile?.bio ?? '';
    linkController.text =
        mainLogic.userModel?.profile?.introduceVideoLink ?? '';
    customLinkController.text = mainLogic.userModel?.profile?.customLink ?? '';
    introduceYourSelfController.text =
        mainLogic.userModel?.profile?.introduceYourSelf ?? '';
    introduceYourSelfOtherLanguageController.text =
        mainLogic.userModel?.profile?.introduceYourSelfOtherLanguage ?? '';
    subjectsList = mainLogic.userModel?.teacherSubject ?? [SubjectModel()];
    for (var elements in subjectsList) {
      for (var element in authLogic.subjectsList) {
        if (element.id == elements.subjectId) {
          elements.selectedSubject = element;
        }
      }
    }
    var list = <SubjectModel>[];
    for (var element in subjectsList) {
      if (element.id != null) list.add(element);
    }
    subjectsList = list;
    Future.forEach<SubjectModel>(subjectsList, (elementSub) async {
      await Future.forEach<String?>(elementSub.images, (elementImage) async {
        var images = subjectsList
            .firstWhere((element) => element.id == elementSub.id)
            .images;
        var index = images.indexOf(elementImage);
        subjectsList
                    .firstWhere((element) => element.id == elementSub.id)
                    .images[
                subjectsList
                    .firstWhere((element) => element.id == elementSub.id)
                    .images
                    .indexOf(elementImage)] =
            (await urlToFile(images[index] ?? '')).path;
      });
    });
  }

  removeSubject(int index) {
    subjectsList.removeAt(index);
    update();
  }

  addNewImage(int index) {
    subjectsList[index].images.add(null);
    update();
  }

  addNewLink(int index) {
    subjectsList[index].youtubeLinkControllerList.add(TextEditingController());
    update();
  }

  addNewUploadedVideo(int index) async {
    final path = await pickGalleryVideo();
    if (path == null) return;
    log(path);

    subjectsList[index]
        .uploadedVideos
        .add(VideoPlayerController.file(File(path)));
    subjectsList[index].uploadedVideosPaths.add(path);

    // Future<void> _video = _controller.initialize();
    // subjectsList[index].uploadedVideos.add(path);
    update();
  }

  deletedLocalVide({required int subjectIndex, required int videoIndex}) {
    subjectsList[subjectIndex].uploadedVideos.removeAt(videoIndex);
    subjectsList[subjectIndex].uploadedVideosPaths.removeAt(videoIndex);
    update();
  }

  pickGalleryVideo() async {
    // Pick a video.dd
    final XFile? galleryVideo =
        await picker.pickVideo(source: ImageSource.gallery);
    if (galleryVideo == null) return;
    log(galleryVideo.path);
    return galleryVideo.path;

    // log(galleryVideo);
  }

  Future<void> deleteSubjectItem({
    required int subjectId,
    required String url,
    required String type,
    required int subjectIndex,
    required int subjectItemIndex,
  }) async {
    try {
      isLoading = true;
      // update();
      var res = await _apiRequests.deleteTeahcerSubjectItem(
          subjectId: subjectId, url: url, type: type);

      showMessage(res.data['message'].toString(), 1);
      if (type == "image") {
        subjectsList[subjectIndex].images.removeAt(subjectItemIndex);
        subjectsList[subjectIndex].imagesUrl.removeAt(subjectItemIndex);
      } else if (type == "youtube") {
        subjectsList[subjectIndex]
            .youtubeLinkControllerList
            .removeAt(subjectItemIndex);
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    update();
  }
}
