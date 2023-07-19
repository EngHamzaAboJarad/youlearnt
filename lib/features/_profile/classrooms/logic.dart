import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:you_learnt/entities/BookModel.dart';
import 'package:you_learnt/entities/TeacherModel.dart';
import 'package:you_learnt/entities/classroom_model.dart';
import 'package:you_learnt/entities/reschduldedBookModel.dart';
import 'package:you_learnt/features/_main/calendar/logic.dart';
import 'package:you_learnt/features/_profile/classrooms/student/rescduledBookdetails/view.dart';
import 'package:you_learnt/features/_profile/classrooms/teacher/add_class_room/view.dart';
import 'package:you_learnt/features/_profile/classrooms/teacher/classroom%20details/view.dart';
import 'package:you_learnt/utils/functions.dart';

import '../../../data/remote/api_requests.dart';
import '../../../entities/SubjectModel.dart';
import '../../../entities/UserModel.dart';
import '../../../entities/student_cancelled_books.dart';
import '../../../entities/suggetsBookModel.dart';
import '../../../entities/teacher_avalible_suggstedd_book.dart';
import '../../../sub_features/add_reschdule_classroom_dialog.dart';
import '../../../utils/error_handler/error_handler.dart';
import '../../_auth/logic.dart';
import '../../_main/logic.dart';
import '../../payment/view.dart';
import '../view_profile/logic.dart';
import 'student/classroom details/view.dart';

class ClassroomsLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  final MainLogic mainLogic = Get.find();
  final AuthLogic authLogic = Get.find();
  final ViewProfileLogic viewProfileLogic = Get.find();

  bool isLoading = false;

  List<ClassRoomModel> classroomsList = [];
  ClassRoomModel? classRoomDetails;

  SubjectModel? selectedSubject;
  TeacherModel? teacherModel;
  String selctedSubjectId = "";
  String classId = "";
  // ClassRoomModel? classRoomModel ;

  int studentClassRoomPage = 1;
  final ScrollController studentClassroomListController = ScrollController();
  bool isThereNextPageStudentClassroom = true;

  List<ReschduldedBookModel> studentRescduleBooksList = [];
  ReschduldedBookModel? studentReschduldedBookModelDetails;
  int studentRescduledbooksPage = 1;
  final ScrollController studentReschduldedBookistController =
      ScrollController();
  bool isThereNextPagestudentReschduldedBook = true;

  List<SuggetsBookModel> teacherSuggetsBookLists = [];
  SuggetsBookModel? teacherSuggetsBookDetails;
  int teacherSuggetsbooksPage = 1;
  final ScrollController teacherSuggetsController = ScrollController();
  bool isThereNextPagesTeacherSuggets = true;

  // List<SuggetsBookModel> studentSuggetsBookLists = [];
  // SuggetsBookModel? studentSuggetsBookDetails;
  // int studentSuggetsbooksPage = 1;
  // final ScrollController studentuggetsController = ScrollController();
  // bool isThereNextPagesstudentSuggets = true;

  List<StudentCancelledBooks> studentCancelledBooksList = [];

  List<TeacherAvalibleSuggstedBooks> teacherAvalibleSuggstedBooks = [];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void onInit() {
    // teacher
    teacherSuggetsController.addListener(() {
      if (teacherSuggetsController.position.pixels ==
          teacherSuggetsController.position.maxScrollExtent) {
        log("init state");
        if (!isThereNextPagesTeacherSuggets) return;
        getTeacherSuggetsBooks(false);
      }
    });
    //end teacher
    // student section

    // studentuggetsController.addListener(() {
    //   if (studentuggetsController.position.pixels ==
    //       studentuggetsController.position.maxScrollExtent) {
    //     log("init state");
    //     if (!isThereNextPagesstudentSuggets) return;
    //     getTeacherSuggetsBooks(false);
    //   }
    // });

    studentClassroomListController.addListener(() {
      if (studentClassroomListController.position.pixels ==
          studentClassroomListController.position.maxScrollExtent) {
        log("init state");
        if (!isThereNextPageStudentClassroom) return;
        getStudentClassrooms(false);
      }
    });

    studentReschduldedBookistController.addListener(() {
      if (studentReschduldedBookistController.position.pixels ==
          studentReschduldedBookistController.position.maxScrollExtent) {
        log("init state");
        if (!isThereNextPagestudentReschduldedBook) return;
        getStudentReschduledBooks(false);
      }
    });

    // end student section

    super.onInit();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descrptionController = TextEditingController();
  final TextEditingController maxStudentController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final start = DateTime.utc(2023, 6, 13, 2, 00, 0);
  final end = DateTime.utc(2023, 6, 13, 3, 00, 0);
  List<Map> classRoomsTimes = [];

  editClassRoom(ClassRoomModel classRoom) async {
    // classRoomsTimes.clear();
    // selctedSubjectId = classRoom.teacherSubjectId.toString();
    titleController.text = classRoom.title;
    descrptionController.text = classRoom.description.toString();
    maxStudentController.text = classRoom.maxStudent.toString();
    classId = classRoom.id.toString();

    Get.to(const AddNewClassRoomPage(
      edit: true,
    ));
  }

  convertTimeToUtc() {
    var dateTime = DateTime.now();
    var val = DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
    var offset = dateTime.timeZoneOffset;
    var hours =
        offset.inHours > 0 ? offset.inHours : 1; // For fixing divide by 0

    if (!offset.isNegative) {
      val = val +
          "+" +
          offset.inHours.toString().padLeft(2, '0') +
          ":" +
          (offset.inMinutes % (hours * 60)).toString().padLeft(2, '0');
    } else {
      val = val +
          "-" +
          (-offset.inHours).toString().padLeft(2, '0') +
          ":" +
          (offset.inMinutes % (hours * 60)).toString().padLeft(2, '0');
    }
    print(val);
  }

  Future<void> deleteTeacherClassroom(String classId) async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.deleteTeacherClassroom(classId);
      await getTeacherClassrooms();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  Future<void> deleteTeacherClassroomBookedTime(
      String bookId, int classroomId) async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.deleteTeacherClassroomBookedId(bookId);
      await getTeacherClassroomDetails(classroomId);
      Get.back();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  void addNewClassRoom(bool edit) async {
    if (!edit) {
      // if (classRoomsTimes.isEmpty) {
      //   showMessage("You must add time!".tr, 2);
      //   return;
      // }
      if (selectedSubject == null) {
        showMessage("You must select subject!".tr, 2);
        return;
      }
    }

    // convert timeشش

    log(classRoomsTimes[0].toString());

    isLoading = true;
    update(['addNewClassRoom']);
    try {
      // selctedSubjectId = selectedSubject!.id.toString();
      // log("class id $classId");
      var res = await _apiRequests.addNewClassroom(edit,
          classId: classId,
          title: titleController.text.trim(),
          description: descrptionController.text,
          subjectId:
              selectedSubject != null ? selectedSubject!.id.toString() : "",
          dates: classRoomsTimes,
          maxStudent: maxStudentController.text,
          classPrice: priceController.text);

      classRoomsTimes.clear();
      selectedSubject = null;
      classId = "";
      // selctedSubjectId = "";
      titleController.text = "";
      descrptionController.text = "";
      maxStudentController.text = "";
      priceController.text = "";

      await getTeacherClassrooms();
      // clearAddNewClassRoom();
      Get.back();
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(['addNewClassRoom']);
  }

  Future<void> getTeacherClassrooms() async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.fetchTeacherClassrooms();
      // log(res.data.toString());
      classroomsList = (res.data['class_rooms'] as List)
          .map((e) => ClassRoomModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  Future<void> getStudentsCancelledBooks() async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.fetchStudentCancelledClassrooms();
      // log(res.data.toString());
      studentCancelledBooksList = (res.data['records'] as List)
          .map((e) => StudentCancelledBooks.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  int selectedtTeacherAvalibleSuggstedBooksIndex = 0;

  onChangeSelectedtTeacherAvalibleSuggstedBooksType(int? index) async {
    try {
      isLoading = true;
      update(["student-action"]);
      selectedtTeacherAvalibleSuggstedBooksIndex = index!;
      // final ViewProfileLogic viewProfileLogic = Get.find();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update(["student-action"]);
  }

  Future<void> getTeacherAvalibleSuggstedBooks({
    required String teacherSlug,
    required String teacherSubjectId,
  }) async {
    isStudentActionUpdaitng = true;
    update(["student-action"]);
    try {
      var res = await _apiRequests.getTeacherAvalibleSuggstedBooks(
          teacherSlug: teacherSlug, teacherSubjectId: "");
      log(res.data.toString());
      teacherAvalibleSuggstedBooks = (res.data['object'] as List)
          .map((e) => TeacherAvalibleSuggstedBooks.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isStudentActionUpdaitng = false;
    update(["student-action"]);
  }

  goToTeacherClassroomDetails(
      {required ClassRoomModel? classroomModel,
      required BookModel? bookModel}) async {
    Get.to(TeacherClassroomDetails(
      classroomModel: classroomModel,
      bookCalenderModel: bookModel,
    ));
  }

  Future<void> getTeacherClassroomDetails(int classroomId) async {
    try {
      isLoading = true;
      // update();
      var res = await _apiRequests.fetchTeacherClassroomDetails(classroomId);

      classRoomDetails = ClassRoomModel.fromJson(res.data["class_room"]);
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    update();
  }

  Future<void> getTeacherPrivateSuggestDetails(int suggestId) async {
    try {
      isLoading = true;
      // update();
      var res = await _apiRequests.fetchTeacherPrivateSuggestDetails(suggestId);

      teacherSuggetsBookDetails =
          SuggetsBookModel.fromJson(res.data["record"], "student");
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    update();
  }

  Future<void> getStudentPrivateSuggestDetails(int suggestId) async {
    try {
      isLoading = true;
      // update();
      var res = await _apiRequests.fetchStudentPrivateSuggestDetails(suggestId);

      teacherSuggetsBookDetails =
          SuggetsBookModel.fromJson(res.data["record"], "teacher");
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    update();
  }

  Future refreshStudentList() async {
    getStudentClassrooms(true);
  }

  bool loadMoreItems = false;
  Future<void> getStudentClassrooms(bool firstTime) async {
    if (firstTime) {
      classroomsList.clear();
      studentClassRoomPage = 1;
    }
    if (studentClassRoomPage == 1) {
      isLoading = true;
    } else {
      loadMoreItems = true;
    }
    update();

    try {
      var res = await _apiRequests.fetchStudnetClassrooms(studentClassRoomPage);
      // log(res.data.toString());
      if (studentClassRoomPage == 1) {
        classroomsList = (res.data["class_rooms"]["data"] as List)
            .map((e) => ClassRoomModel.fromJson(e))
            .toList();

        // log("first page");
        // transactionList
        //     .addAll(transactionList + transactionList + transactionList);
      } else {
        classroomsList.addAll((res.data["class_rooms"]["data"] as List)
            .map((e) => ClassRoomModel.fromJson(e))
            .toList());

        log("next pages");
      }

      studentClassRoomPage++;

      isThereNextPageStudentClassroom =
          res.data["class_rooms"]["next_page_url"] == null ? false : true;
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    loadMoreItems = false;

    update();
  }

  Future<void> getStudentReschduledBooks(bool firstTime) async {
    if (firstTime) {
      studentRescduleBooksList.clear();
      studentRescduledbooksPage = 1;
    }
    if (studentRescduledbooksPage == 1) {
      isLoading = true;
    } else {
      loadMoreItems = true;
    }
    update();

    try {
      var res = await _apiRequests
          .fetchStudnetReschudeledBooks(studentRescduledbooksPage);
      // log(res.data.toString());
      if (studentRescduledbooksPage == 1) {
        studentRescduleBooksList = (res.data["records"]["data"] as List)
            .map((e) => ReschduldedBookModel.fromJson(e))
            .toList();

        // log("first page");
        // transactionList
        //     .addAll(transactionList + transactionList + transactionList);
      } else {
        studentRescduleBooksList.addAll((res.data["records"]["data"] as List)
            .map((e) => ReschduldedBookModel.fromJson(e))
            .toList());

        log("next pages");
      }

      studentRescduledbooksPage++;

      isThereNextPagestudentReschduldedBook =
          res.data["records"]["next_page_url"] == null ? false : true;
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    loadMoreItems = false;

    update();
  }

  Future<void> getTeacherSuggetsBooks(bool firstTime) async {
    if (firstTime) {
      teacherSuggetsBookLists.clear();
      teacherSuggetsbooksPage = 1;
    }
    if (teacherSuggetsbooksPage == 1) {
      isLoading = true;
    } else {
      loadMoreItems = true;
    }
    update();

    try {
      var res =
          await _apiRequests.fetchTeacherSuggetsBooks(teacherSuggetsbooksPage);
      // log(res.data.toString());
      if (teacherSuggetsbooksPage == 1) {
        teacherSuggetsBookLists = (res.data["records"]["data"] as List)
            .map((e) => SuggetsBookModel.fromJson(e, ""))
            .toList();

        // log("first page");
        // transactionList
        //     .addAll(transactionList + transactionList + transactionList);
      } else {
        teacherSuggetsBookLists.addAll((res.data["records"]["data"] as List)
            .map((e) => SuggetsBookModel.fromJson(e, ""))
            .toList());

        log("next pages");
      }

      teacherSuggetsbooksPage++;

      isThereNextPagesTeacherSuggets =
          res.data["records"]["next_page_url"] == null ? false : true;
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    loadMoreItems = false;

    update();
  }

  Future<void> getStudentSuggetsBooks(bool firstTime) async {
    if (firstTime) {
      teacherSuggetsBookLists.clear();
      teacherSuggetsbooksPage = 1;
    }
    if (teacherSuggetsbooksPage == 1) {
      isLoading = true;
    } else {
      loadMoreItems = true;
    }
    update();

    try {
      var res =
          await _apiRequests.fetchStudentSuggetsBooks(teacherSuggetsbooksPage);
      // log(res.data.toString());
      if (teacherSuggetsbooksPage == 1) {
        teacherSuggetsBookLists = (res.data["records"]["data"] as List)
            .map((e) => SuggetsBookModel.fromJson(e, ""))
            .toList();

        // log("first page");
        // transactionList
        //     .addAll(transactionList + transactionList + transactionList);
      } else {
        teacherSuggetsBookLists.addAll((res.data["records"]["data"] as List)
            .map((e) => SuggetsBookModel.fromJson(e, ""))
            .toList());

        log("next pages");
      }

      teacherSuggetsbooksPage++;

      isThereNextPagesTeacherSuggets =
          res.data["records"]["next_page_url"] == null ? false : true;
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    loadMoreItems = false;

    update();
  }

  Future<void> getStudentClassroomDetails(int classroomId) async {
    try {
      isLoading = true;
      // update();
      var res = await _apiRequests.fetchStudnetClassroomDetails(classroomId);

      classRoomDetails = ClassRoomModel.fromJson(res.data["class_room"]);
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    update();
  }

  Future<void> getStudentReschduledBookClassroomDetails(int rescBookId) async {
    try {
      isLoading = true;
      // update();
      var res = await _apiRequests
          .fetchStudnetReschdueldBookClassroomDetails(rescBookId);
      studentReschduldedBookModelDetails =
          ReschduldedBookModel.fromJson(res.data["record"]);
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    update();
  }

  bool isUpdatingReschdule = false;
  Future<void> updateStudentRescduledBookStatus(
      int rescBookId, String status) async {
    try {
      isUpdatingReschdule = true;
      update(["update_rescdule"]);
      var res = await _apiRequests.updateStudentRescduledBookStatus(
          requestId: rescBookId.toString(), status: status);
      // studentReschduldedBookModelDetails =
      //     ReschduldedBookModel.fromJson(res.data["record"]);

      await getStudentReschduledBookClassroomDetails(rescBookId);
      await Get.find<CalendarLogic>().getStudentBooks();
      await getStudentReschduledBooks(true);
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isUpdatingReschdule = false;
    update(["update_rescdule"]);
  }

  Future<void> updateStudentSuggstedBookStatus(
      int suggestBookId, String status) async {
    try {
      isUpdatingReschdule = true;
      update(["update-suggest"]);
      var res = await _apiRequests.updateStudentSuugestBookStatus(
          suggestId: suggestBookId.toString(), status: status);
      // studentReschduldedBookModelDetails =
      //     ReschduldedBookModel.fromJson(res.data["record"]);

      await getStudentPrivateSuggestDetails(suggestBookId);
      await Get.find<CalendarLogic>().getStudentBooks();
      await getStudentSuggetsBooks(true);
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isUpdatingReschdule = false;
    update(["update-suggest"]);
  }

  Future<void> deleteTeacherSuggestBook(int suggestId) async {
    try {
      isUpdatingReschdule = true;
      update(["delete-suggest"]);
      var res =
          await _apiRequests.deleteTeacherSuggestBook(suggestId.toString());
      // studentReschduldedBookModelDetails =
      //     ReschduldedBookModel.fromJson(res.data["record"]);

      // await getTeacherPrivateSuggestDetails(suggestId);
      Get.back();
      await getTeacherSuggetsBooks(true);
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isUpdatingReschdule = false;
    update(["delete-suggest"]);
  }

  Future<void> getTeacherAvalibleClassroomDetails(int classroomId) async {
    try {
      isLoading = true;
      // update();
      var res =
          await _apiRequests.fetchTeacherAvalibleClassroomDetails(classroomId);

      classRoomDetails = ClassRoomModel.fromJson(res.data["record"]);
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;
    update();
  }

  goToStudentClassroomDetails(ClassRoomModel item) async {
    Get.to(StudentClassroomDetails(
      item: item,
    ));
  }

  goToStudentReschduledBooksDetails(ReschduldedBookModel item) async {
    Get.to(StudentReschduledBooksClassroomDetails(
      item: item,
    ));
  }

  toggleMenu(ClassRoomModel commonModel) {
    commonModel.isSelected = !commonModel.isSelected;
    update();
  }

  closeAllOpentoggeldMenues() {
    classroomsList.map((e) => e.isSelected = false).toList();
    update();
  }

  onChangeSubject(SubjectModel? val) {
    selectedSubject = val;
    // log(selectedSubject!.id.toString());
    update(["addNewClassRoom"]);
  }

  deleteClassAddedTime(int index) {
    classRoomsTimes.removeAt(index);
    update(["addNewClassRoom"]);
  }

  clearAddNewClassRoom() {
    classId = "";
    // selctedSubjectId = "";
    classRoomsTimes.clear();
    titleController.text = "";
    descrptionController.text = "";
    maxStudentController.text = "";
    priceController.text = "";
  }

  Future<void> getTeacherAvalibaleClassrooms(
      bool firstTime, TeacherModel teacherModel) async {
    if (firstTime) {
      classroomsList.clear();
    }
    isLoading = true;
    update();

    try {
      var res = await _apiRequests
          .fetchTeacherAvalibleClassrooms(teacherModel.user!.slug!);
      // log(res.data.toString());
      classroomsList = (res.data["records"] as List)
          .map((e) => ClassRoomModel.fromJson(e))
          .toList();
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isLoading = false;

    update();
  }

  bool isOrderLoading = false;
  Future<void> handleJoinClass(
      {required BuildContext context,
      required ClassRoomModel classRoomModel}) async {
    try {
      isOrderLoading = true;
      update();
      //  we check localy if he has enough money in wallet or not  before sending to book the sessions and if he dosen't have will convert him to pay page
      await Get.find<MainLogic>().getProfile();
      UserModel? updatedUserData = Get.find<MainLogic>().userModel;
      if (updatedUserData != null) {
        double classCost = classRoomModel.price ?? 0;
        double userWallet = updatedUserData.wallet ?? 0;

        log("wallet : $userWallet");
        log("class cost : $classCost");
        if (userWallet > classCost) {
          log("have enough credit and will register him ");
          await joinToAvalibleClass(classRoomModel.id);
          await getTeacherAvalibleClassroomDetails(classRoomModel.id);
        } else {
          // log("dose not have enough credit"); and we will convert him to pay from paypal or stripe
          // log("dose not have enough credit");
          await viewProfileLogic.handleChargeWallet(
              context: context, comeFrom: ComeFrom.joinTeacherGroup);
          // to get wallet
          await Get.find<MainLogic>().getProfile();
          UserModel? updatedUserData = Get.find<MainLogic>().userModel;
          // the charge wasn't enough charge more
          // log("wallet now : " + updatedUserData!.wallet!.toString());
          if (updatedUserData!.wallet! < classCost) {
            showMessage("The charged amount was not enough".tr, 2);
            isOrderLoading = false;
            update();
            return;
          }
          await joinToAvalibleClass(classRoomModel.id);
          await getTeacherAvalibleClassroomDetails(classRoomModel.id);

          log("have enough credit and will register him now ");
        }
      }
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isOrderLoading = false;

    update();
  }

  Future<void> joinToAvalibleClass(int classroomId) async {
    try {
      // isLoading = true;
      // update();
      var res = await _apiRequests.joinTeacherAvalibleCourse(
          classroomId: classroomId.toString());
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    // isLoading = false;
    // update();
  }

  Future<void> getProfileBySlug(String? slug,
      {bool withoutLoading = false}) async {
    // if (teacherModel != null) return;
    if (!withoutLoading) isLoading = true;
    if (!withoutLoading) update();
    try {
      var res = await _apiRequests.getTeacherBySlug(slug);

      ///log(json.encode(res.data));
      teacherModel = TeacherModel.fromJson(res.data['object']);
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isLoading = false;
    update();
  }

  // resechdeul  classroom book time

  DateTime? selectedDate;
  String? fromTime = 'From'.tr;
  String? toTime = 'To'.tr;
  TimeOfDay? fromTimeOfDay;
  TimeOfDay? toTimeOfDay;
  bool isAddLoading = false;

  void reschduleNewTime({required int classRoomId}) async {
    if (fromTimeOfDay == null) {
      Fluttertoast.showToast(msg: 'Add start time first'.tr);
      return;
    }
    if (toTimeOfDay == null) {
      Fluttertoast.showToast(msg: 'Add end time first'.tr);
      return;
    }
    isAddLoading = true;
    update(["rescdule"]);
    try {
      DateTime startAt = DateTime.utc(selectedDate!.year, selectedDate!.month,
          selectedDate!.day, fromTimeOfDay!.hour, fromTimeOfDay!.minute);
      DateTime endAt = DateTime.utc(selectedDate!.year, selectedDate!.month,
          selectedDate!.day, toTimeOfDay!.hour, toTimeOfDay!.minute);

      log(startAt.toString().substring(0, 19));
      log(endAt.toString().substring(0, 19));

      var res = await _apiRequests.reschdeulTeacherBook(
          classroomId: classRoomId.toString(),
          startAt: startAt.toString().substring(0, 19),
          endAt: endAt.toString().substring(0, 19));
      // var res = await _apiRequests.addBook(
      //     title: selectedDate.toString().substring(0, 10),
      //     startAt: selectedDate.toString().substring(0, 11) +
      //         '${formatNumber(fromTimeOfDay!.hour)}:${formatNumber(fromTimeOfDay!.minute)}',
      //     endAt: selectedDate.toString().substring(0, 11) +
      //         '${formatNumber(toTimeOfDay!.hour)}:${formatNumber(toTimeOfDay!.minute)}',
      //     status: 'available',
      //     type: isPrivate ? 'one' : 'group');
      // await getTimes();
      // await getTeacherClassroomDetails(classRoomId);
      Get.back();
      Get.back();

      showMessage(res.data['message'].toString(), 1);
      // selectedDate = null;
      fromTime = 'From'.tr;
      toTime = 'To'.tr;
      fromTimeOfDay = null;
      toTimeOfDay = null;
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isAddLoading = false;
    update(["rescdule"]);
  }

  void teachrSuggestNewTime({required int classRoomId}) async {
    if (fromTimeOfDay == null) {
      Fluttertoast.showToast(msg: 'Add start time first'.tr);
      return;
    }
    if (toTimeOfDay == null) {
      Fluttertoast.showToast(msg: 'Add end time first'.tr);
      return;
    }
    isAddLoading = true;
    update(["rescdule"]);
    try {
      DateTime startAt = DateTime.utc(selectedDate!.year, selectedDate!.month,
          selectedDate!.day, fromTimeOfDay!.hour, fromTimeOfDay!.minute);
      DateTime endAt = DateTime.utc(selectedDate!.year, selectedDate!.month,
          selectedDate!.day, toTimeOfDay!.hour, toTimeOfDay!.minute);

      log(startAt.toString().substring(0, 16));
      log(endAt.toString().substring(0, 16));

      var res = await _apiRequests.teacherSuggestNewBook(
          classroomId: classRoomId.toString(),
          startAt: startAt.toString().substring(0, 16),
          endAt: endAt.toString().substring(0, 16));
// return ;
      await getTeacherClassroomDetails(classRoomId);
      Get.back();
      // Get.back();

      showMessage(res.data['message'].toString(), 1);
      // selectedDate = null;
      fromTime = 'From'.tr;
      toTime = 'To'.tr;
      fromTimeOfDay = null;
      toTimeOfDay = null;
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    isAddLoading = false;
    update(["rescdule"]);
  }

  void addClassRoomsTimeToList() async {
    if (fromTimeOfDay == null) {
      Fluttertoast.showToast(msg: 'Add start time first'.tr);
      return;
    }
    if (toTimeOfDay == null) {
      Fluttertoast.showToast(msg: 'Add end time first'.tr);
      return;
    }

    try {
      DateTime startAt = DateTime.utc(selectedDate!.year, selectedDate!.month,
          selectedDate!.day, fromTimeOfDay!.hour, fromTimeOfDay!.minute);
      DateTime endAt = DateTime.utc(selectedDate!.year, selectedDate!.month,
          selectedDate!.day, toTimeOfDay!.hour, toTimeOfDay!.minute);

      log(startAt.toString().substring(0, 16));
      log(endAt.toString().substring(0, 16));

      classRoomsTimes.add({
        "start_at": startAt.toString().substring(0, 16),
        "end_at": endAt.toString().substring(0, 16)
      });

      fromTime = 'From'.tr;
      toTime = 'To'.tr;
      fromTimeOfDay = null;
      toTimeOfDay = null;
      Get.back();
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    update(["addNewClassRoom"]);
  }

  void cancelTeacherPrivateClass(
      {required int classRoomId,
      required bool isTeacher,
      required int bookId}) async {
    isLoading = true;
    update();
    try {
      var res = await _apiRequests.cancelTeacherPrivateBook(
        bookId: bookId.toString(),
      );
      if (isTeacher) {
        await getTeacherClassroomDetails(classRoomId);
        await Get.find<CalendarLogic>().getTeacherBooks();
      }

      Get.back();
      Get.back();

      showMessage(res.data['message'].toString(), 1);
      // selectedDate = null;
      fromTime = 'From'.tr;
      toTime = 'To'.tr;
      fromTimeOfDay = null;
      toTimeOfDay = null;
    } catch (e) {
      ErrorHandler.handleError(e);
    }
    // isAddLoading = false;
    isLoading = false;
    update();
  }

  void openTimeDialog(
      {required int? bookId, required int? classroomId, required String type}) {
    selectedDate = DateTime(
        DateTime.now().year, DateTime.now().month + 1, DateTime.now().day + 1);
    Get.bottomSheet(
        AddReschduleClassroomDialog(
          bookId: bookId,
          type: type,
          classroomId: classroomId,
        ),
        isScrollControlled: true);
  }

  pickDate() {
    showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)))
        .then((value) {
      if (value != null) {
        selectedDate = value;
        update(["rescdule"]);
      }
    });
  }

  pickFromTime() {
    showCustomTimePicker(
      context: Get.context!,
      onFailValidation: (context) => log('Unavailable selection'),
      selectableTimePredicate: (time) =>
          time == null ? false : time.minute % 15 == 0,
      initialTime: fromTimeOfDay ?? const TimeOfDay(hour: 8, minute: 0),
    ).then((value) {
      if (value != null) {
        fromTimeOfDay = value;
        fromTime = '${formatNumber(value.hour)}:${formatNumber(value.minute)}';
        //  '${formatNumber(value.hourOfPeriod)}:${formatNumber(value.minute)}       ${value.period.index == 0 ? 'AM' : 'PM'}';
        if (toTimeOfDay == null) {
          toTimeOfDay = TimeOfDay(hour: value.hour + 1, minute: value.minute);
          toTime =
              '${formatNumber(value.hour + 1)}:${formatNumber(value.minute)}';
        }
        update(["rescdule"]);
      }
    });
  }

  pickToTime() {
    showCustomTimePicker(
      context: Get.context!,
      onFailValidation: (context) => log('Unavailable selection'),
      selectableTimePredicate: (time) =>
          time == null ? false : time.minute % 15 == 0,
      initialTime: fromTimeOfDay ?? const TimeOfDay(hour: 9, minute: 0),
    ).then((value) {
      if (value != null) {
        toTimeOfDay = value;
        toTime = '${formatNumber(value.hour)}:${formatNumber(value.minute)}';
        //   '${formatNumber(value.hourOfPeriod)}:${formatNumber(value.minute)}       ${value.period.index == 0 ? 'AM' : 'PM'}';
        update(["rescdule"]);
      }
    });
  }

  String formatNumber(int num) {
    if ('$num'.length == 1) {
      return '0$num';
    }
    return num.toString();
  }

  bool isStudentActionUpdaitng = false;
  Future<void> updateStudentBookActions(
      {required int bookId, required String type, String? newBookId}) async {
    try {
      isStudentActionUpdaitng = true;
      update(["student-action"]);
      var res = await _apiRequests.updateStudentBookActionsType(
          bookId: bookId.toString(), type: type, newBookId: newBookId);
      // studentReschduldedBookModelDetails =
      //     ReschduldedBookModel.fromJson(res.data["record"]);

      await Get.find<CalendarLogic>().getStudentBooks();
      Get.back();
      if (type == "rescheduled") {
        selectedtTeacherAvalibleSuggstedBooksIndex = 0;
        teacherAvalibleSuggstedBooks.clear();
        Get.back();
      }
      showMessage(res.data['message'].toString(), 1);
    } catch (e) {
      ErrorHandler.handleError(e);
    }

    isStudentActionUpdaitng = false;
    update(["student-action"]);
  }

  showCustomTimePicker({required BuildContext context, required void Function(dynamic context) onFailValidation, required bool Function(dynamic time) selectableTimePredicate, required TimeOfDay initialTime}) {}
}
