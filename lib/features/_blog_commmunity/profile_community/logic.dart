import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:you_learnt/entities/CommonModel.dart';
import 'package:you_learnt/features/_auth/logic.dart';

import '../../../data/hive/hive_controller.dart';
import '../../../data/remote/api_requests.dart';
import '../../../entities/language_model.dart';
import '../../../utils/error_handler/error_handler.dart';
import '../../../utils/functions.dart';
import '../../_main/logic.dart';
import '../add_community/view.dart';

import '../community_details/view.dart';
import '../tags/view.dart';

class ProfileCommunityLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final MainLogic mainLogic = Get.find();
  final AuthLogic authLogic = Get.find();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  List<TextEditingController> tagsControllerList = [
    TextEditingController(text: '')
  ];
  List<FocusNode> tagsFocusList = [FocusNode()];

  List<CommonModel> communityWebsiteList = [];
  List<CommonModel> tagsWebsiteList = [];
  List<CommonModel> communityList = [];
  bool isAddLoading = false;
  bool isLoading = false;
  bool isDetailsLoading = false;
  bool isAddCommentLoading = false;
  bool isCommentLoading = false;
  String? imagePath;
  int? communityId;
  CommonModel? selectedSubject;
  CommonModel? selectedCategory;
  CommonModel? communityModel;
  CommonModel? selectedTag;

  @override
  void onInit() {
    getWebsiteCommunity();
    super.onInit();
  }

  closeAllOpentoggeldMenues() {
    communityList.map((e) => e.isSelected = false).toList();
    update();
  }

  void addCommunity(bool edit) async {
    isAddLoading = true;
    update();
    try {
      var res = await _apiRequests.addCommunity(
        edit,
        title: titleController.text,
        tags: tagsControllerList.map((e) => e.text).toList(),
        description: descriptionController.text,
        categoryId: selectedCategory?.id,
        subjectId: selectedSubject?.id,
        communityId: communityId,
        languageId: mainLogic.selectedLanguage?.id,
      );
      selectedSubject = null;
      selectedCategory = null;
      mainLogic.selectedLanguage = null;
      titleController.text = '';
      imagePath = null;
      descriptionController.text = '';
      tagsControllerList = [TextEditingController()];
      tagsFocusList = [FocusNode()];
      HiveController.generalBox.put('community', null);
      await getCommunity();
      Get.back();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isAddLoading = false;
    update();
  }

  Future<void> getCommunity() async {
    isLoading = true;
    //update();
    try {
      var res = await _apiRequests.getCommunity();
      communityList = (res.data['object']['community']['data'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  Future<void> getCommunityDetails(int? id) async {
    communityModel = null;
    isDetailsLoading = true;
    try {
      var res = await _apiRequests.getCommunityDetails(id);
      log(res.data.toString());
      communityModel = CommonModel.fromJson(res.data['object']['comment']);
      communityModel?.related = (res.data['object']['related'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isDetailsLoading = false;
    update();
  }

  Future<void> getWebsiteCommunity({String? search}) async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.getWebsiteCommunity(search: search);
      communityWebsiteList = (res.data['object']['data'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
      tagsWebsiteList = [];
      var names = [];
      for (var element in communityWebsiteList) {
        element.tags?.forEach((element1) {
          if (!names.contains(element1.name)) {
            names.add(element1.name);
            tagsWebsiteList.add(element1);
          }
        });
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  Future<void> deleteCommunity(int? communityId) async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.deleteCommunity(communityId);
      await getCommunity();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  addTag() {
    bool isEmpty = false;
    for (var element in tagsControllerList) {
      if (element.text.isEmpty) isEmpty = true;
    }
    if (isEmpty) {
      return Fluttertoast.showToast(
          msg: 'Please fill all tags before adding'.tr);
    }
    tagsControllerList.add(TextEditingController());
    tagsFocusList.add(FocusNode());
    tagsFocusList[tagsFocusList.length - 1].requestFocus();
    update();
  }

  removeTag(index) {
    tagsControllerList.removeAt(index);
    tagsFocusList.removeAt(index);
    update();
  }

  draftBlog() async {
    var des = descriptionController.text;
    HiveController.generalBox.put('community', {
      'title': titleController.text,
      'des': des,
      'tags': tagsControllerList.map((e) => e.text).toList(),
      'image': imagePath,
      'category_id': selectedCategory?.id,
      'subject_id': selectedSubject?.id,
    });
    Get.back();
  }

  void handleDraft(bool edit) {
    if (edit) return;
    try {
      var map = HiveController.generalBox.get('community') as Map?;
      if (map != null) {
        titleController.text = map['title'] ?? '';
        Future.delayed(const Duration(seconds: 1))
            .then((value) => descriptionController.text = (map['des'] ?? ''));
        tagsControllerList = (map['tags'] as List<String>)
            .map((e) => TextEditingController(text: e))
            .toList();
        tagsFocusList =
            (map['tags'] as List<String>).map((e) => FocusNode()).toList();
        imagePath = map['image'];
        selectedCategory = mainLogic.categoriesList
            .firstWhere((element) => element.id == map['category_id']);
        selectedSubject = authLogic.subjectsWithoutAddList
            .firstWhere((element) => element.id == map['subject_id']);
      }
    } catch (e) {}
  }

  toggleMenu(CommonModel commonModel) {
    commonModel.isSelected = !commonModel.isSelected;
    update();
  }

  goToDetails(CommonModel item) {
    Get.to(CommunityDetailsPage(item));
  }

  onChangeSubject(CommonModel? val) {
    selectedSubject = val;
    update();
  }

  onChangeCategory(CommonModel? val) {
    selectedCategory = val;
    update();
  }

  editCommunity(CommonModel commonModel) {
    communityId = commonModel.id;
    titleController.text = commonModel.title ?? '';
    tagsControllerList = commonModel.tags
            ?.map((e) => TextEditingController(text: e.name))
            .toList() ??
        [TextEditingController()];
    tagsFocusList =
        commonModel.tags?.map((e) => FocusNode()).toList() ?? [FocusNode()];
    try {
      selectedCategory = mainLogic.categoriesList
          .firstWhere((element) => element.id == commonModel.categoryId);
      mainLogic.selectedLanguage = mainLogic.languagesList
          .firstWhere((element) => element.id == commonModel.languageId);
      selectedSubject = authLogic.subjectsWithoutAddList
          .firstWhere((element) => element.id == commonModel.subjectId);
    } catch (e) {}
    Get.to(AddCommunityPage(
      edit: true,
    ));
    Future.delayed(const Duration(seconds: 1)).then((value) =>
        descriptionController.text = (commonModel.description ?? ''));
  }

  changeSelectedTag(CommonModel? index) {
    Get.to(
        TagsPage(
            selectedTagList: selectedTagList(index),
            tagName: index?.name,
            isBlog: false,
            logic: this),
        preventDuplicates: false);
  }

  List<CommonModel> selectedTagList(selectedTag) {
    if (selectedTag == null) return [];
    List<CommonModel> list = [];
    for (var element in communityWebsiteList) {
      if (element.tags?.toString().contains(selectedTag!.name!) == true) {
        list.add(element);
      }
    }
    return list;
  }

  Future<void> addCommunityComment(int? id) async {
    isAddCommentLoading = true;
    update();
    try {
      var res = await _apiRequests.addCommunityComment(
        id,
        commentController.text,
      );
      log(res.data.toString());
      await getCommunityDetails(id);
      commentController.text = '';
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isAddCommentLoading = false;
    update();
  }

  Future<void> addLikeOnComment(int? id, int? commentId) async {
    isCommentLoading = true;
    update([commentId.toString()]);
    try {
      var like = true;
      // communityModel?.comments?.firstWhereOrNull((element) => element.id == commentId);
      var res = await _apiRequests.addLikeOnComment(commentId, true);
      await getCommunityDetails(id);
      commentController.text = '';
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isCommentLoading = false;
    update([commentId.toString()]);
  }

  onChangeLanguage(LanguageModel? val) {
    mainLogic.selectedLanguage = val;
    update();
  }
}
