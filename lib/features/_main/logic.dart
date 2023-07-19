import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:you_learnt/entities/PageModel.dart';
import 'package:you_learnt/features/_auth/logic.dart';
import 'package:you_learnt/features/_main/calendar/view.dart';
import 'package:you_learnt/features/chat/chat_nav_screen.dart';
import 'package:you_learnt/features/settings/view.dart';
import 'package:you_learnt/utils/functions.dart';

import '../../data/hive/hive_controller.dart';
import '../../data/remote/api_requests.dart';
import '../../entities/CommonModel.dart';
import '../../entities/UserModel.dart';
import '../../entities/language_model.dart';
import '../../sub_features/logout_dialog.dart';
import '../../utils/custom_widget/custom_indicator.dart';
import '../../utils/error_handler/error_handler.dart';
import '../_blog_commmunity/blog/view.dart';
import '../_profile/profile/view.dart';
import 'home/view.dart';

class MainLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final AuthLogic authLogic = Get.find();
  final zoomDrawerController = ZoomDrawerController();
  final searchController = TextEditingController();

  @override
  void onInit() async {
    await Future.delayed(const Duration(seconds: 1));
    getCategories();
    getFAQs();
    getRecommendationsPage();
    if (HiveController.getToken() != null) {
      setUserNotificationId();
    }
    getAvalibleLanguages();
    super.onInit();
  }

  bool isFAQsLoading = false;
  bool isCategoriesLoading = false;
  bool isProfileLoading = false;
  bool isNotificationLoading = false;
  Widget currentScreen = const HomePage();
  int? navigatorValue = 0;
  List sliderItems = [1];
  int currentSlider = 0;
  UserModel? userModel;
  PageModel? recommendationsPage;
  List<CommonModel> faqsList = [];
  List<CommonModel> categoriesList = [];
  List<CommonModel> notificationList = [];
  List<LanguageModel> languagesList = [];
  LanguageModel? selectedLanguage  ;
  String? imagePath;
  int? selectedQuestion;

  selectQuestion(int index) {
    if (index == selectedQuestion) {
      selectedQuestion = null;
    } else {
      selectedQuestion = index;
    }
    update();
  }

  void setUserNotificationId() async {
    try {
      final status = await OneSignal.shared.getDeviceState();
      final String? osUserID = status?.userId;
      var res = await _apiRequests.setUserNotificationId(osUserID);
      categoriesList = (res.data['object'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
    } catch (e) {
      //  ErrorHandler.handleError(e);
    }
  }

  void getCategories() async {
    isCategoriesLoading = true;
    update();
    try {
      var res = await _apiRequests.getCategories();
      categoriesList = (res.data['object'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isCategoriesLoading = false;
    update();
  }

  void getAvalibleLanguages() async {
    try {
      var res = await _apiRequests.getAvalibleLanguages();
      languagesList = (res.data['object'] as List)
          .map((e) => LanguageModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    update();
  }

  void getRecommendationsPage() async {
    try {
      var res = await _apiRequests.getPages('rec');
      recommendationsPage = PageModel.fromJson(res.data['object'][0]);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  void getFAQs() async {
    isFAQsLoading = true;
    update();
    try {
      var res = await _apiRequests.getFAQs(
          type: HiveController.getToken() == null
              ? 'general'
              : HiveController.getIsStudent()
                  ? 'student'
                  : 'teacher');
      faqsList = (res.data['object'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isFAQsLoading = false;
    update();
  }

  Future<void> getProfile() async {
    getNotification();
    isProfileLoading = true;
    update();
    try {
      var res = await _apiRequests.getTeacherProfile();
      // log(json.encode(res.data));
      userModel = UserModel.fromJson(res.data['object']);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isProfileLoading = false;
    update();
  }

  Future<void> getNotification() async {
    isNotificationLoading = true;
    update();
    try {
      var res = await _apiRequests.getNotification();
      // log(res.data.toString());
      Map<String, List> releaseDateMap =
          (res.data['object'] as List).groupBy((m) => m['created_at']);
      notificationList = [];
      int index = 0;
      releaseDateMap.forEach((key, value) {
        notificationList[index].createdAt = key;
        notificationList[index]
            .notifications
            .addAll(value.map((e) => CommonModel.fromJson(e)).toList());
        index++;
      });
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isNotificationLoading = false;
    update();
  }

  bool isGetUserChatLoading = false;
  List<UserModel> usersList = [];
  List<String?> lastList = [];

  void getUsersBySlugs(List<String?> list) async {
    if (lastList.length == list.length) return;
    lastList = list;
    isGetUserChatLoading = true;
    try {
      var res = await _apiRequests.getUsersBySlugs(list);
      usersList = (res.data['object'] as List)
          .map((e) => UserModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isGetUserChatLoading = false;
    update();
  }

  Future<void> uploadUserPhoto() async {
    isProfileLoading = true;
    update();
    try {
      var res = await _apiRequests.uploadUserPhoto(image: imagePath);
      await getProfile();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isProfileLoading = false;
    update();
  }

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < sliderItems.length; i++) {
      list.add(i == currentSlider
          ? const CustomIndicator(true)
          : const CustomIndicator(false));
    }
    return list;
  }

  addImage() async {
    try {
      XFile? image;
      final ImagePicker _picker = ImagePicker();
      image = await _picker.pickImage(source: ImageSource.gallery);
      imagePath = image!.path;
      uploadUserPhoto();
    } catch (e) {
      log('image error => ${e.toString()}');
    }
  }

  void changeSelectedValue(int selectedValue, bool withUpdate) {
    navigatorValue = selectedValue;
    switch (selectedValue) {
      case 0:
        {
          currentScreen = const HomePage();
          break;
        }
      case 1:
        {
          currentScreen = const CalendarPage();
          break;
        }
      case 2:
        {
          currentScreen = const ProfilePage();
          break;
        }
      case 3:
        {
          currentScreen = const ChatNavScreen();
          break;
        }
      case 4:
        {
          searchController.text = '';
          currentScreen = const BlogPage();
          break;
        }
    }
    zoomDrawerController.close?.call();
    if (withUpdate) update();
  }

  onPageChanged(index) {
    currentSlider = index;
    update();
  }

  toggleDrawer() {
    zoomDrawerController.toggle?.call();
    //  Future.delayed(Duration(milliseconds: 100)).then((value) => update());
  }

  openDrawerPage(Widget widget) {
    currentScreen = widget;
    navigatorValue = null;
    zoomDrawerController.close?.call();
    if (widget.toString() != 'FindTutorPage') {
      Get.find<MainLogic>().searchController.text = '';
    }
    update();
  }

  openLogoutDialog() {
    Get.bottomSheet(const LogoutDialog());
  }

  goToSetting() {
    zoomDrawerController.close?.call();
    Get.to(SettingsPage());
  }
}
