import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:you_learnt/data/hive/hive_controller.dart';
import 'package:you_learnt/entities/CommonModel.dart';
import 'package:you_learnt/entities/language_model.dart';
import 'package:you_learnt/features/_blog_commmunity/tags/view.dart';

import '../../../data/remote/api_requests.dart';
import '../../../utils/error_handler/error_handler.dart';
import '../../../utils/functions.dart';
import '../../_main/logic.dart';
import '../add_blog/view.dart';
import '../blog_details/view.dart';

class ProfileBlogLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final MainLogic mainLogic = Get.find();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final HtmlEditorController descriptionController = HtmlEditorController();

  List<TextEditingController> tagsControllerList = [
    TextEditingController(text: '')
  ];
  List<FocusNode> tagsFocusList = [FocusNode()];

  List<CommonModel> blogsList = [];
  List<CommonModel> blogsWebsiteList = [];
  List<CommonModel> tagsWebsiteList = [];
  bool isAddLoading = false;
  bool isLoading = false;
  bool isDetailsLoading = false;
  bool isCommentLoading = false;
  String? imagePath;
  CommonModel? blogModel;
  CommonModel? selectedTag;
  int? blogId;
  int rating = 5;
  CommonModel? selectedCategory;

  @override
  void onInit() {
    getWebsiteBlogs();

    super.onInit();
  }

  closeAllOpentoggeldMenues() {
    blogsList.map((e) => e.isSelected = false).toList();
    update();
  }

  void addBlog(bool edit) async {
    isAddLoading = true;
    update(['addBlog']);
    try {
      //      'Additional details is requird': 'Additional details is requird',
      // 'Category is requird': 'Category is requird',
      // 'blog image is requird': 'blog image is requird'
      var htmlDescrption = await descriptionController.getText();
      // if (htmlDescrption.isEmpty) {
      //   isAddLoading = false;
      //   showMessage('Additional details is requird'.tr, 2);
      //   update(['addBlog']);
      //   return;
      // } else if (tagsControllerList.isEmpty) {
      //   isAddLoading = false;
      //   showMessage('Category is requird'.tr, 2);
      //   update(['addBlog']);
      //   return;
      // }

      var res = await _apiRequests.addBlog(edit,
          blogId: blogId,
          subTitle: subTitleController.text,
          categoryId: selectedCategory?.id,
          title: titleController.text,
          description: htmlDescrption,
          languageId: mainLogic.selectedLanguage?.id,
          tags: tagsControllerList.map((e) => e.text).toList(),
          blogImage: imagePath);
      titleController.text = '';
      subTitleController.text = '';
      imagePath = null;
      selectedCategory = null;
      mainLogic.selectedLanguage = null;
      descriptionController.setText('');
      tagsControllerList = [TextEditingController()];
      tagsFocusList = [FocusNode()];
      HiveController.generalBox.put('blog', null);
      await getBlogs();
      Get.back();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isAddLoading = false;
    update(['addBlog']);
  }

  Future<void> getBlogs() async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.getBlogs();
      log(res.data.toString());
      blogsList = (res.data['object']['data'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  Future<void> getBlogsDetails(int? id) async {
    blogModel = null;
    isDetailsLoading = true;
    try {
      var res = await _apiRequests.getBlogDetails(id: id);
      //log(res.data.toString());
      blogModel = CommonModel.fromJson(res.data['object']['blog']);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isDetailsLoading = false;
    update();
  }

  Future<void> addBlogsComment(int? id) async {
    isCommentLoading = true;
    update();
    try {
      // 'happy', 'satisfy', 'normal', 'sad', 'angry'
      var res =
          await _apiRequests.addBlogComment(id, commentController.text, "");
      //  id,
      // commentController.text,
      // [
      //   'angry',
      //   'sad',
      //   'normal',
      //   'satisfy',
      //   'happy',
      // ][rating - 1]
      await getBlogsDetails(id);
      commentController.text = '';
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isCommentLoading = false;
    update();
  }

  Future<void> addBlogsEmoji(int id) async {
    // isCommentLoading = true;
    // update();

    try {
      // 'happy', 'satisfy', 'normal', 'sad', 'angry'
      var res = await _apiRequests.addRemoveBlogEmoji(
          id,
          [
            'angry',
            'sad',
            'normal',
            'satisfy',
            'happy',
          ][rating - 1]);
      // await getBlogsDetails(id);
      log(res.data.toString());
    } catch (e) {
      // log(e.toString());
      ErrorHandler.handleError(e);
    }
    isCommentLoading = false;
    // log(res.headers.toString());
    // log(res.data.toString());
    // rating = 3;
    update();
  }

  Future<void> getWebsiteBlogs({String? search}) async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.getWebsiteBlogs(search: search);
      blogsWebsiteList = (res.data['object']['data'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
      tagsWebsiteList = [];
      var names = [];
      for (var element in blogsWebsiteList) {
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

  addImage() async {
    try {
      XFile? image;
      final ImagePicker _picker = ImagePicker();
      image = await _picker.pickImage(source: ImageSource.gallery);
      imagePath = image!.path;
      update(['addBlog']);
    } catch (e) {
      log('image error => ${e.toString()}');
    }
  }

  goToDetails(CommonModel item) {
    Get.to(BlogDetailsPage(item));
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
    update(['addBlog']);
  }

  removeTag(index) {
    tagsControllerList.removeAt(index);
    tagsFocusList.removeAt(index);
    update(['addBlog']);
  }

  draftBlog() async {
    var des = await descriptionController.getText();
    HiveController.generalBox.put('blog', {
      'title': titleController.text,
      'sub_title': subTitleController.text,
      'des': des,
      'tags': tagsControllerList.map((e) => e.text).toList(),
      'image': imagePath
    });
    Get.back();
  }

  toggleMenu(CommonModel commonModel) {
    commonModel.isSelected = !commonModel.isSelected;
    update();
  }

  void handleDraft(bool edit) {
    if (edit) return;
    try {
      var map = HiveController.generalBox.get('blog') as Map?;
      if (map != null) {
        titleController.text = map['title'] ?? '';
        subTitleController.text = map['sub_title'] ?? '';
        Future.delayed(const Duration(seconds: 1)).then(
            (value) => descriptionController.insertHtml(map['des'] ?? ''));
        tagsControllerList = (map['tags'] as List<String>)
            .map((e) => TextEditingController(text: e))
            .toList();
        tagsFocusList =
            (map['tags'] as List<String>).map((e) => FocusNode()).toList();
        imagePath = map['image'];
      }
    } catch (e) {}
  }

  editBlog(CommonModel commonModel) async {
    blogId = commonModel.id;
    titleController.text = commonModel.title ?? '';
    subTitleController.text = commonModel.subTitle ?? '';
    selectedCategory = mainLogic.categoriesList
        .firstWhereOrNull((element) => element.id == commonModel.categoryId);
    mainLogic.selectedLanguage = mainLogic.languagesList
        .firstWhereOrNull((element) => element.id == commonModel.languageId);
    tagsControllerList = commonModel.tags
            ?.map((e) => TextEditingController(text: e.name))
            .toList() ??
        [TextEditingController()];
    tagsFocusList =
        commonModel.tags?.map((e) => FocusNode()).toList() ?? [FocusNode()];
    Get.to(AddBlogPage(
      edit: true,
    ));
    Future.delayed(const Duration(seconds: 1)).then((value) =>
        descriptionController.insertHtml(commonModel.description ?? ''));
    if (commonModel.imageUrl == null) {
      imagePath = null;
    } else {
      var a = await urlToFile(commonModel.imageUrl!);
      imagePath = a.path;
      update(['addBlog']);
    }
  }

  Future<void> deleteBlog(int? communityId) async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.deleteBlog(communityId);
      await getBlogs();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  changeSelectedTag(CommonModel? index) {
    Get.to(
        TagsPage(
            selectedTagList: selectedTagList(index),
            tagName: index?.name,
            isBlog: true),
        preventDuplicates: false);
  }

  List<CommonModel> selectedTagList(selectedTag) {
    if (selectedTag == null) return [];
    List<CommonModel> list = [];
    for (var element in blogsWebsiteList) {
      if (element.tags?.toString().contains(selectedTag!.name!) == true) {
        list.add(element);
      }
    }
    return list;
  }

  onChangeCategory(CommonModel? val) {
    selectedCategory = val;
    update(['addBlog']);
  }

  onChangeLanguage(LanguageModel? val) {
    mainLogic.selectedLanguage = val;
    update(['addBlog']);
  }
}
