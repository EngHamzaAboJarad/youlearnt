import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:you_learnt/data/hive/hive_controller.dart';
import 'package:you_learnt/entities/UserModel.dart';
import 'package:you_learnt/entities/WithdrawModel.dart';
import 'package:you_learnt/features/_auth/logic.dart';
import 'package:you_learnt/features/_main/logic.dart';
import 'package:you_learnt/features/_profile/requests/sub_featuers/buy_package_option.dart';
import 'package:you_learnt/features/_profile/view_profile/logic.dart';
import 'package:you_learnt/features/_profile/withdraw/logic.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';
import 'package:you_learnt/utils/functions.dart';

import '../../data/remote/api_requests.dart';
import '../../entities/CommonModel.dart';
import '../../entities/PostModel.dart';
import '../../entities/ReferModel.dart';
import '../../entities/StatisticsModel.dart';
import '../../entities/teacher_avalible_suggstedd_book.dart';
import '../../sub_features/charge_wallet_option.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/error_handler/error_handler.dart';
import '../_blog_commmunity/profile_blog/view.dart';
import '../_main/calendar/logic.dart';
import '../payment/view.dart';

class ProfileLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final MainLogic mainLogic = Get.find();
  final AuthLogic authLogic = Get.find();

  final WithdrawDepositLogic withdrawDepositLogic =
      Get.put(WithdrawDepositLogic());

  // final ViewProfileLogic viewProfileLogic = Get.find();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  //post
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startPriceController = TextEditingController();
  final TextEditingController endPriceController = TextEditingController();

  UserModel? userModel;
  ReferModel? referModel;
  CommonModel? selectedSubject;
  StatisticsModel? statisticsModel;
  WithdrawModel? withdrawModel;
  List<PostModel> postList = [];
  PostModel? postDetailspage;
  String? genderValue;

  @override
  onInit() {
    initUserModel();
    getWithdraw();
    getRefLink();
    if (HiveController.getIsStudent() == false) {
      getStatistics();
    }
    if (HiveController.getIsStudent() == true) {
      getPosts();
    }
    super.onInit();
  }

  bool isLoading = false;
  bool isPersonalLoading = false;
  bool isStudent = false;

  onTapBirthday() {
    showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now().subtract(const Duration(days: 6000)),
            firstDate: DateTime.now().subtract(const Duration(days: 60000)),
            lastDate: DateTime.now())
        .then((value) {
      if (value != null) {
        birthdayController.text = DateFormat('y-MM-d').format(value);
        update();
      }
    });
  }

  changeProfile() async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.switchUserType();
      HiveController.setIsStudent(!HiveController.getIsStudent());
      await Get.find<MainLogic>().getProfile();
      _apiRequests.onInit();
      showMessage(res.data['message'].toString(), 1);
//      showMessage('You should log In again'.tr, 1);
      initUserModel();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  goToBlog() {
    Get.to(const ProfileBlogPage());
  }

  onChangeSubject(CommonModel? val) {
    selectedSubject = val;
    update(['addPost']);
  }

  void initUserModel() async {
    await mainLogic.getProfile();
    userModel = mainLogic.userModel;
    firstNameController.text = userModel?.firstName ?? '';
    lastNameController.text = userModel?.lastName ?? '';
    emailController.text = userModel?.email ?? '';
    phoneController.text = userModel?.mobile ?? '';
    birthdayController.text = userModel?.profile?.birthday ?? '';
    genderValue = userModel?.gender;
    isStudent = userModel?.type == 'student';
//  log("user type ${userModel?.type}");
    for (var element in authLogic.countriesList) {
      if (element.id == userModel?.profile?.countryId) {
        authLogic.selectedCountry = element;
        await authLogic.getCities(countryId: element.id);
        await authLogic.getTimezone(countryId: element.id);
      }
      if (element.id == userModel?.profile?.countryOriginId) {
        authLogic.selectedOrigin = element;
      }
    }
    for (var element in authLogic.citiesList) {
      if (element.name == userModel?.profile?.cityName) {
        authLogic.selectedCities = element;
      }
    }
    for (var element in authLogic.timezoneList) {
      if (element == userModel?.profile?.timezone) {
        authLogic.selectedTimezone = element;
      }
    }
    for (var element in authLogic.languagesList) {
      userModel?.languagesProfile?.forEach((elementLP) {
        if (element.id == elementLP.id) {
          authLogic.selectedLanguage = element;
          authLogic.selectedLevel = elementLP.level;
        }
      });
    }
  }

  changeGender(val) {
    genderValue = val;
    update(['gender']);
  }

  void updatePersonalInformation() async {
    isPersonalLoading = true;
    update(['personal']);
    try {
      var res = await _apiRequests.updateTeacherProfile(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          mobile: phoneController.text,
          countyId: authLogic.selectedCountry?.id,
          countyOriginId: authLogic.selectedOrigin?.id,
          cityName: authLogic.selectedCities?.name,
          timezone: authLogic.selectedTimezone,
          birthday: birthdayController.text,
          level: authLogic.selectedLevel,
          languageId: authLogic.selectedLanguage?.id,
          gender: genderValue);
      await mainLogic.getProfile();
      Get.back();
      showMessage(res.data['message'].toString(), 1);
      update();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isPersonalLoading = false;
    update(['personal']);
  }

  void addPost() async {
    isLoading = true;
    update(['addPost']);
    try {
      var res = await _apiRequests.addPost(
          title: titleController.text,
          description: descriptionController.text,
          startPrice: startPriceController.text,
          endPrice: endPriceController.text,
          subjectId: selectedSubject?.id);
      titleController.text = '';
      descriptionController.text = '';
      startPriceController.text = '';
      endPriceController.text = '';
      selectedSubject = null;
      Get.back();
      showMessage(res.data['message'].toString(), 1);
      await getPosts();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(['addPost']);
  }

  Future<void> getPosts() async {
    isLoading = true;
    update(['posts']);
    try {
      var res = await _apiRequests.getPosts();
      postList = (res.data['object']['data'] as List)
          .map(
            (e) => PostModel.fromJson(e, {}),
          )
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(['posts']);
  }

  Future<void> getStatistics() async {
    isLoading = true;
    update(['statistics']);
    try {
      var res = await _apiRequests.getStatistics();
      statisticsModel = StatisticsModel.fromJson(res.data['object']);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(['statistics']);
  }

  Future<void> getWithdraw() async {
    isLoading = true;
    update(['withdraw']);
    try {
      var res = await _apiRequests.getWithdraw(HiveController.getIsStudent());
      withdrawModel = WithdrawModel.fromJson(res.data['object']);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(['withdraw']);
  }

  Future<void> getRefLink() async {
    isLoading = true;
    update(['refLink']);
    try {
      var res = await _apiRequests.getRefLink();
      //log(json.encode(res.data));
      referModel = ReferModel.fromJson(res.data['object']);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(['refLink']);
  }

  String? imagePath;

  addImage() async {
    try {
      XFile? image;
      final ImagePicker _picker = ImagePicker();
      image = await _picker.pickImage(source: ImageSource.gallery);
      imagePath = image!.path;
      if (imagePath != null) {
        Get.dialog(Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: GetBuilder<ProfileLogic>(
              id: 'send_button',
              builder: (logic) {
                return SizedBox(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CustomText(
                          'Upload your identity image'.tr,
                          fontSize: 18,
                        ),
                        const Divider(),
                        Expanded(child: Image.file(File(imagePath!))),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: CustomButtonWidget(
                                    title: 'Send'.tr,
                                    textSize: 12,
                                    loading: logic.isLoading,
                                    onTap: () => uploadTutorIdentity())),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: CustomButtonWidget(
                                    title: 'Cancel'.tr,
                                    textSize: 12,
                                    onTap: () {
                                      Get.back();
                                    })),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ));
      }
    } catch (e) {
      log('image error => ${e.toString()}');
    }
  }

  withdraw() async {
    withdrawDepositLogic.goToTeacherWithdrawOptions();
    // if (Get.find<MainLogic>().userModel?.isIdentityUploaded == true) {
    //   if (Get.find<MainLogic>().userModel?.verified == true) {
    //     startWithdraw();
    //   } else {
    //     showMessage('Your identity under review', 2);
    //   }
    // } else {
    //   addImage();
    // }
  }

  uploadTutorIdentity() async {
    isLoading = true;
    update(['send_button']);
    try {
      var res = await _apiRequests.uploadUserIdentity(image: imagePath);
      log(res.data.toString());
      await mainLogic.getProfile();
      Get.back();
      imagePath = null;
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(['send_button']);
  }

  void startWithdraw() {}

  Future<void> getStudentReqestProposals(int requestId) async {
    try {
      isLoading = true;
      // update();
      var res = await _apiRequests.getStudentReqestProposals(requestId);

      postDetailspage = 
          PostModel.fromJson(res.data["post"], res.data["proposals"]);
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    update();
  }

  bool updaingOfferRequest = false;
  int? propaslTeacherSubjectId;
  int selectedtTeacherAvalibleSuggstedBooksIndex = 0;
  String selcetedTeacherSlug = "";

  List<TeacherAvalibleSuggstedBooks> teacherAvalibleSuggstedBooks = [];

  onChangeSelectedtTeacherAvalibleSuggstedBooksType(int? index) async {
    try {
      isLoading = true;
      update(["stdunt_offers_requests"]);
      selectedtTeacherAvalibleSuggstedBooksIndex = index!;
      // final ViewProfileLogic viewProfileLogic = Get.find();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(["stdunt_offers_requests"]);
  }

  Future<void> updateStudentReqestProposalsStatus(
      {required int requestId, required String status}) async {
    try {
      updaingOfferRequest = true;
      update(["stdunt_offers_requests"]);
      var res = await _apiRequests.updateStudentReqestProposalsStatus(
          requestId, status);

      propaslTeacherSubjectId = res.data["proposal"]["teacher_subject_id"];

      log(propaslTeacherSubjectId.toString());
      // log(res.data.toString());
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    updaingOfferRequest = false;
    update(["stdunt_offers_requests"]);
  }

  Future<void> getTeacherAvalibleSuggstedBooks({
    required String teacherSlug,
    required String teacherSubjectId,
  }) async {
    updaingOfferRequest = true;
    update(['stdunt_offers_requests']);
    try {
      var res = await _apiRequests.getTeacherAvalibleSuggstedBooks(
          teacherSlug: teacherSlug, teacherSubjectId: "");
      selcetedTeacherSlug = teacherSlug;
      log(res.data.toString());
      teacherAvalibleSuggstedBooks = (res.data['object'] as List)
          .map((e) => TeacherAvalibleSuggstedBooks.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    updaingOfferRequest = false;
    update(['stdunt_offers_requests']);
  }

  handelExpermentalesson({
    required PropaslPostModel propaslPostModel,
    required BuildContext context,
  }) async {
    try {
      updaingOfferRequest = true;
      update(['stdunt_offers_requests']);
      await Get.find<MainLogic>().getProfile();
      UserModel? updatedUserData = Get.find<MainLogic>().userModel;
      if (updatedUserData != null) {
        double subjuctHourlyrate = double.parse(propaslPostModel.price);
        double userWallet = updatedUserData.wallet ?? 0;

        if (userWallet > subjuctHourlyrate) {
          log("have enough credit");
          await experimentalProposalBookLesson(
              propaslId: propaslPostModel.id, context: context);
        } else {
          // log("dose not have enough credit"); and we will convert him to pay from paypal or stripe
          // log("dose not have enough credit");
          await Get.find<ViewProfileLogic>().handleChargeWallet(
              context: context, comeFrom: ComeFrom.acceptStuedntRequest);
          // to get wallet
          await Get.find<MainLogic>().getProfile();
          UserModel? updatedUserData = Get.find<MainLogic>().userModel;
          // the charge wasn't enough charge more
          // log("wallet now : " + updatedUserData!.wallet!.toString());
          if (updatedUserData!.wallet! < subjuctHourlyrate) {
            showMessage("The charged amount was not enough".tr, 2);
            // isOrderLoading = false;
            update();
            return;
          }
          await experimentalProposalBookLesson(
              propaslId: propaslPostModel.id, context: context);
        }
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    updaingOfferRequest = false;
    update(['stdunt_offers_requests']);
  }

  Future<void> experimentalProposalBookLesson(
      {required propaslId, required BuildContext context}) async {
    try {
      var res = await _apiRequests.createExperimnetalBook(
          teachersubjectID: propaslTeacherSubjectId.toString(),
          bookId: teacherAvalibleSuggstedBooks[
                  selectedtTeacherAvalibleSuggstedBooksIndex]
              .id,
          propaslId: propaslId);
      log(res.data.toString());
      await Get.find<CalendarLogic>().getStudentBooks();
      await Get.find<MainLogic>().getProfile();
      propaslTeacherSubjectId == null;
      selectedtTeacherAvalibleSuggstedBooksIndex = 0;
      teacherAvalibleSuggstedBooks.clear();
      await getPosts();
      Get.back();
      Get.back();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
      if (e is DioError) {
        if (e.response?.statusCode == 400 &&
            e.response!.data["message"] == "YOU_SHOULD_BUY_PACKAGE") {
          // log((e.response?.statusCode ?? 0).toString());
          // log(e.response.toString());
          handleBuyPackegs(
            context: context,
          );
        }
      }
    }
  }

  List<CommonModel> packagesList = [];

  Future<void> getPackages() async {
    // isTimesLoading = true;
    update();
    try {
      // log(selcetedTeacherSlug);
      // log(propaslTeacherSubjectId.toString());

      var res = await _apiRequests.getPackages(
          slug: selcetedTeacherSlug, teacherSubjectId: propaslTeacherSubjectId);
      packagesList = (res.data['object'] as List)
          .map((e) => CommonModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    // isTimesLoading = false;
    update();
  }

  Future<void> handleChargeWallet(
      {required BuildContext context, required ComeFrom comeFrom}) async {
    await showDialog(
        context: context,
        builder: (ctx) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AlertDialog(
                scrollable: true,
                contentPadding: const EdgeInsets.all(8),
                insetPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: const Center(
                  child: CustomText(
                    "Charge wallet",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: ChargeWallteOptions(
                  comeFrom: comeFrom,
                ),
              ),
            ));
  }

  Future<void> handleBuyPackegs({
    required BuildContext context,
  }) async {
    if (propaslTeacherSubjectId == null || selcetedTeacherSlug.isEmpty) {
      return;
    }
    await getPackages();
    await showDialog(
        context: context,
        builder: (ctx) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AlertDialog(
                scrollable: true,
                contentPadding: const EdgeInsets.all(8),
                insetPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: const Center(
                  child: CustomText(
                    "Packages",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: BuyPackageStudentTutorRequestOptions(),
              ),
            ));
  }

  Future<void> bookReservation({required CommonModel selectedPackage}) async {
    try {
      log(selectedPackage.name.toString());
      log(selectedPackage.hour.toString());
      var res = await _apiRequests.reservationBookIFPackagesExists(
          teachersubjectID: propaslTeacherSubjectId.toString(),
          bookId: teacherAvalibleSuggstedBooks[
                  selectedtTeacherAvalibleSuggstedBooksIndex]
              .id,
          hour: selectedPackage.hour);
      log(res.data.toString());
      await Get.find<CalendarLogic>().getStudentBooks();
      await Get.find<MainLogic>().getProfile();
      Get.back();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
  }
}
