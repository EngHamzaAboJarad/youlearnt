import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:you_learnt/binding.dart';
import 'package:you_learnt/data/hive/hive_controller.dart';
import 'package:you_learnt/data/remote/api_requests.dart';
import 'package:you_learnt/entities/CommonModel.dart';
import 'package:you_learnt/entities/UserModel.dart';
import 'package:you_learnt/features/_auth/choose_country/view.dart';
import 'package:you_learnt/features/_auth/reset_password/view.dart';
import 'package:you_learnt/features/_auth/valdation_code/view.dart';
import 'package:you_learnt/features/_main/calendar/logic.dart';
import 'package:you_learnt/features/_main/logic.dart';
import 'package:you_learnt/utils/error_handler/error_handler.dart';

import '../../localization/en.dart';
import '../../localization/translations.dart';
import '../../utils/functions.dart';
import '../_main/view.dart';
import 'auth/view.dart';
import 'choose_languages/view.dart';
import 'choose_subjects/view.dart';
import 'forget_password/view.dart';

class AuthLogic extends GetxController {
  @override
  onInit() async {
    getCountries();
    getLanguages();
    getSubjects();
    super.onInit();
  }

  final ApiRequests _apiRequests = Get.find();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailLoginNameController =
      TextEditingController();
  final TextEditingController emailRegisterNameController =
      TextEditingController();
  final TextEditingController emailForgetPasswordNameController =
      TextEditingController();
  final TextEditingController passwordLoginNameController =
      TextEditingController();
  final TextEditingController passwordRegisterNameController =
      TextEditingController();

  final TextEditingController passwordResetController = TextEditingController();
  final TextEditingController confirmationPasswordResetController =
      TextEditingController();

  final TextEditingController emailResetController = TextEditingController();
  final TextEditingController subjectNameController = TextEditingController();

  // code
  TextEditingController codePinController = TextEditingController();
  late StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  bool loginIsSelected = false;
  bool isTutor = false;
  bool isLogoutLoading = false;
  bool isLoginLoading = false;
  bool isRegisterLoading = false;
  bool isForgetPasswordLoading = false;
  bool isCreateSubjectLoading = false;
  bool isCountriesLoading = false;
  bool isLanguageLoading = false;
  bool isSubjectsLoading = false;
  bool isAddRecommendLoading = false;
  bool isCitiesLoading = false;
  bool isSocialLoading = false;
  bool isTimezoneLoading = false;
  bool isOriginLoading = false;
  bool isToggleLanguageLoading = false;

  List<CommonModel> countriesList = [];
  List<CommonModel> citiesList = [];
  List<CommonModel> languagesList = [];
  List<CommonModel> subjectsWithoutAddList = [];
  List<CommonModel> subjectsList = [];
  List<String> timezoneList = [];
  List<String> levelList = ['Basic', 'Conversational', 'Fluent', 'Native'];
  List<String> originList = [];

  CommonModel? recommendedCountry;
  CommonModel? recommendedLanguage;
  CommonModel? selectedCountry;
  CommonModel? selectedCities;
  String? selectedTimezone;
  String? selectedLevel;
  CommonModel? selectedOrigin;
  CommonModel? selectedSubject;
  CommonModel? selectedLanguage;
  UserModel? userModel;

  Future<void> getLanguages() async {
    isLanguageLoading = true;
    update(['languages']);
    try {
      var res = await _apiRequests.getLanguages();
      languagesList = (res.data['object'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLanguageLoading = false;
    update(['languages']);
  }

  Future<void> getSubjects() async {
    isSubjectsLoading = true;
    update(['subjects']);
    try {
      var res = await _apiRequests.getSubjects();
      subjectsWithoutAddList = (res.data['object'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
      subjectsList = (res.data['object'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
      subjectsList.add(CommonModel.fromJson({}));
      if (HiveController.getIsStudent() == true &&
          HiveController.getToken() != null) {
        await getStudentRecommendations();
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isSubjectsLoading = false;
    update(['subjects']);
  }

  Future<void> getStudentRecommendations() async {
    isSubjectsLoading = true;
    update(['subjects']);
    try {
      var res = await _apiRequests.getStudentRecommendations();
      log(json.encode(res.data));
      var selectedList = (res.data['object']['subjects'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
      for (var element in subjectsList) {
        element.isSelected = false;
      }
      for (var element in selectedList) {
        for (var elementSubject in subjectsList) {
          if (elementSubject.id == element.id) elementSubject.isSelected = true;
        }
      }
      recommendedLanguage =
          CommonModel.fromJson(res.data['object']['languages'][0]);
      for (var element in languagesList) {
        element.isSelected = false;
      }
      for (var element in languagesList) {
        if (recommendedLanguage?.id == element.id) element.isSelected = true;
      }
      recommendedCountry =
          CommonModel.fromJson(res.data['object']['countries'][0]);
      for (var element in countriesList) {
        if (recommendedCountry?.id == element.id) recommendedCountry = element;
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isSubjectsLoading = false;
    update(['subjects']);
  }

  Future<void> addStudentRecommendations() async {
    isAddRecommendLoading = true;
    update(['Recommendations']);
    try {
      var res = await _apiRequests.addStudentRecommendations(
          subjectsIdsList:
              subjectsList.map((e) => e.isSelected ? e.id : null).toList(),
          countriesIdsList: [
            recommendedCountry?.id
          ],
          languageIdsList: [
            languagesList
                .firstWhereOrNull((element) => element.isSelected == true)
                ?.id
          ]);
      Get.offAll(MainPage(), binding: Binding());
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isAddRecommendLoading = false;
    update(['Recommendations']);
  }

  Future<void> getCities({required int? countryId}) async {
    isCitiesLoading = true;
    update();
    try {
      var res = await _apiRequests.getCities(countryId: countryId);
      citiesList = (res.data['object'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isCitiesLoading = false;
    update();
  }

  Future<void> getTimezone({required int? countryId}) async {
    isTimezoneLoading = true;
    update(['timezone']);
    try {
      var res = await _apiRequests.getTimezone(countryId);
      timezoneList =
          (res.data['object'] as List).map((e) => e.toString()).toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isTimezoneLoading = false;
    update(['timezone']);
  }

  Future<void> register() async {
    isRegisterLoading = true;
    update();
    try {
      var res = await _apiRequests.register(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailRegisterNameController.text,
          password: passwordRegisterNameController.text,
          type: isTutor ? 'teacher' : 'student',
          cityId: selectedCities?.id,
          countyId: selectedCountry?.id);
      await handleUser(res);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isRegisterLoading = false;
    update();
  }

  Future<void> login() async {
    isLoginLoading = true;
    update();
    try {
      var res = await _apiRequests.login(
          email: emailLoginNameController.text,
          password: passwordLoginNameController.text,
          provider: 'platform');

      await handleUser(res);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoginLoading = false;
    update();
  }

  Future<void> handleUser(res) async {
    userModel = UserModel.fromJson(res.data['object']);

    await HiveController.setIsStudent(userModel?.type == 'student');
    await HiveController.setToken(userModel?.token);
    await HiveController.setUserId(userModel?.id.toString());
    await HiveController.setUserName(userModel?.fullName);

    await _apiRequests.onInit();
    Get.find<MainLogic>().getFAQs();
    await Get.find<MainLogic>().getProfile();
    Get.find<MainLogic>().setUserNotificationId();
    if (HiveController.getIsStudent()) {
      Get.find<CalendarLogic>().getStudentBooks();
    } else {
      Get.find<CalendarLogic>().getTeacherBooks();
    }
    if (userModel?.type == 'student') {
      Get.offAll(
          loginIsSelected
              ? MainPage()
              : ChooseSubjectsPage(isFromProfile: false),
          binding: Binding());
    } else {
      Get.offAll(
          loginIsSelected
              ? MainPage()
              : ChooseLanguagesPage(
                  isForRecommended: true, isFromProfile: false),
          binding: Binding());
    }
  }

  Future<void> forgetPassword({required String email}) async {
    isForgetPasswordLoading = true;
    update(['forgetPassword']);
    try {
      var res = await _apiRequests.forgetPassword(email: email);
      showMessage(res.data['message'].toString(), 1);
      // emailForgetPasswordNameController.text = '';

      goToValdationCode();
      // emailResetController.text = email;
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isForgetPasswordLoading = false;
    update(['forgetPassword']);
  }

  bool isCheckingValdtionCode = false;

  Future<void> checkValdationCode({required String email}) async {
    try {
      isCheckingValdtionCode = true;
      update(['checkCode']);
      if (codePinController.text.length < 6) {
        errorController.add(ErrorAnimationType.shake);
        isCheckingValdtionCode = false;
        update(['checkCode']);
        return;
      }
      var res = await _apiRequests.checkValdationCode(
          email: email, code: codePinController.text);
      showMessage(res.data['message'].toString(), 1);

      goToResetNewPassword(code: codePinController.text, email: email);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isCheckingValdtionCode = false;
    update(['checkCode']);
  }

  bool isresetingNewPassword = false;
  Future<void> resetNewPassword(
      {required String email,
      required String password,
      required String? confirmationPassword,
      required String code}) async {
    try {
      isresetingNewPassword = true;
      update(['resetPassword']);

      var res = await _apiRequests.resetNewPassword(
          email: email,
          code: code,
          password: password,
          confirmationPassword: confirmationPassword);
      showMessage(res.data['message'].toString(), 1);
      goToAuth();
      // goToResetNewPassword(code: codePinController.text, email: email);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isresetingNewPassword = false;
    update(['resetPassword']);
  }

  Future<void> logout() async {
    isLogoutLoading = true;
    update(['logout']);
    try {
      var res = await _apiRequests.logout();
      Get.back();
      showMessage(res.data['message'].toString(), 1);
      HiveController.setToken(null);
      await _apiRequests.onInit();
      Get.find<MainLogic>().userModel = null;
      Get.find<CalendarLogic>().bookList = [];
      Get.find<MainLogic>().toggleDrawer();
      Get.find<MainLogic>().update();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLogoutLoading = false;
    update(['logout']);
  }

  Future<void> createSubject(bool category) async {
    isCreateSubjectLoading = true;
    update(['subjects']);
    try {
      var res = (category)
          ? await _apiRequests.createCategory(
              name: subjectNameController.text, subjectId: selectedSubject?.id)
          : await _apiRequests.createSubject(name: subjectNameController.text);
      log(res.data.toString());
      Get.back(result: res.data['object']);
      showMessage(res.data['message'].toString(), 1);
      subjectNameController.text = '';
      await getSubjects();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isCreateSubjectLoading = false;
    update(['subjects']);
  }

  Future<void> googleSignIn() async {
    isSocialLoading = true;
    update();
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      var google = await _googleSignIn.signIn();
      if (google != null) {
        log(google.email);
        log(google.displayName ?? '');
        String? firstName;
        String? lastName;

        if (google.displayName?.contains(' ') == true) {
          firstName = google.displayName!
              .substring(0, google.displayName!.indexOf(' '));
          lastName = google.displayName?.substring(
              google.displayName!.indexOf(' '), google.displayName!.length);
        }

        await registerSocial(
            firstName: firstName,
            lastName: lastName,
            email: google.email,
            provider: 'google');
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isSocialLoading = false;
    update();
  }

  Future<void> facebookSignIn() async {
    isSocialLoading = true;
    update();
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();

        String? firstName;
        String? lastName;

        if (userData['name']?.contains(' ') == true) {
          firstName =
              userData['name'].substring(0, userData['name'].indexOf(' '));
          lastName = userData['name']?.substring(
              userData['name'].indexOf(' '), userData['name'].length);
        }

        await registerSocial(
            firstName: firstName,
            lastName: lastName,
            email: userData['email'],
            provider: 'facebook');
      } else {
        log(result.status.toString());
        log(result.message ?? '');
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isSocialLoading = false;
    update();
  }

  Future<void> registerSocial({
    String? firstName,
    String? lastName,
    String? email,
    String? provider,
  }) async {
    isSocialLoading = true;
    update();
    try {
      var res = await _apiRequests.loginSocial(
          firstName: firstName,
          lastName: lastName,
          email: email,
          type: isTutor ? 'teacher' : 'student',
          provider: provider);
      await handleUser(res);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isSocialLoading = false;
    update();
  }

  void getCountries() async {
    isCountriesLoading = true;
    update();
    try {
      var res = await _apiRequests.getCountries();
      countriesList = (res.data['object'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isCountriesLoading = false;
    update();
  }

  changeLoginState({required bool mLoginIsSelected}) {
    loginIsSelected = mLoginIsSelected;
    update();
  }

  changeAccountState({required bool mIsTutor}) {
    isTutor = !mIsTutor;
    update();
  }

  saveLanguage(bool isForRecommended, bool isFromProfile) async {
    isToggleLanguageLoading = true;
    update(['languages']);
    for (var element in languagesList) {
      if (element.isSelected) {
        if (!isForRecommended) {
          HiveController.setLanguageCode(element.code);
          HiveController.setIsArabic(element.code?.contains('ar') == true);
          await translateMap();
          await Get.updateLocale(
              Locale(HiveController.getLanguageCode() ?? 'en'));
        }
      }
    }
    isToggleLanguageLoading = false;
    update(['languages']);

    if (!isForRecommended) {
      Navigator.pop(Get.context!);
          onInit();
      Get.find<MainLogic>().onInit();

      Get.offAll(MainPage()); 
   
    } else {
      Get.to(ChooseCountryPage(isFromProfile: isFromProfile));
    }
  }

  Future<void> translateMap() async {
    try {
      var res = await Get.find<ApiRequests>().translateMap(map: en);
      log(res.data.toString());
      List list = (res.data['object'] as List).map((e) => e).toList();
      Map<String, String> local = {};
      for (var element in list) {
        if (element.keys.first != '' || element.values != null) {
          local[element.keys.first] = element.values.first;
        }
      }
      Get.find<Translation>().map = {
        'en': en,
        HiveController.getLanguageCode() ?? 'en': local
      };
      log('heer');
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  goToChooseSubject(bool isFromProfile) {
    Get.to(ChooseSubjectsPage(
      isFromProfile: isFromProfile,
    ));
  }

  goToChooseLanguages(isFromProfile) {
    Get.to(ChooseLanguagesPage(
      isFromProfile: isFromProfile,
      isForRecommended: true,
    ));
  }

  goToForgetPassword() {
    Get.to(ForgetPasswordPage());
  }

  goToValdationCode() {
    Get.to(ValidationCodePage(email: emailForgetPasswordNameController.text));
    emailForgetPasswordNameController.text = "";
  }

  goToResetNewPassword({
    required String email,
    required String code,
  }) {
    Get.to(ResetPasswordPage(
      email: email,
      code: code,
    ));
  }

  onChangeCity(CommonModel? val) {
    selectedCities = val;
    update();
  }

  onChangeTimezone(String? val) {
    selectedTimezone = val;
    update();
  }

  onChangeLevel(String? val) {
    selectedLevel = val;
    update(['level']);
  }

  onChangeOrigin(CommonModel? val) {
    selectedOrigin = val;
    update();
  }

  onChangeSubject(CommonModel? val) {
    selectedSubject = val;
    update(['subjects']);
  }

  onChangeLanguage(CommonModel? val) {
    recommendedLanguage = val;
    update();
  }

  onChangeLanguage2(CommonModel? val) {
    selectedLanguage = val;
    update(['language']);
  }

  onChangeRecommendedCountry(CommonModel? val) {
    recommendedCountry = val;
    update();
  }

  onChangeCountry(CommonModel? val) {
    selectedCountry = val;
    selectedCities = null;
    selectedTimezone = null;
    selectedOrigin = null;
    citiesList = [];
    getCities(countryId: selectedCountry?.id);
    getTimezone(countryId: selectedCountry?.id);
  }

  toggleSubject(int index) {
    subjectsList[index].isSelected = !subjectsList[index].isSelected;
    update(['subjects']);
  }

  toggleLanguage(int index) {
    for (var element in languagesList) {
      element.isSelected = false;
    }
    languagesList[index].isSelected = true;
    update(['languages']);
  }

  goToAuth() {
    Get.offAll(AuthPage());
  }
}
