import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as ge;
import 'package:you_learnt/constants/env.dart';
import 'package:you_learnt/data/hive/hive_controller.dart';
import 'package:you_learnt/entities/EducationModel.dart';
import 'package:you_learnt/entities/SubjectModel.dart';

import '../../entities/CertificationModel.dart';
import '../../entities/ExperienceModel.dart';
import '../../entities/wallet_account_model.dart';

class ApiRequests extends ge.GetxController {
  late Dio _dio;

  @override
  Future<void> onInit() async {
    log("INIT ==> ApiRequests");

    var headers = {
      if (HiveController.getToken() != null)
        'Authorization': 'Bearer ' + HiveController.getToken()!,
      'Accept': accept,
      'Accept-Language': HiveController.getLanguageCode() ?? 'en',
      'lang': HiveController.getLanguageCode() ?? 'en',
    };
    log(HiveController.getToken().toString());
    _dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 120 * 1000,
        receiveTimeout: 120 * 1000,
        headers: headers));
    super.onInit();
  }

  ///-------------------------------------------- Auth --------------------------------------------///
  Future<Response> register({
    String? firstName,
    String? lastName,
    String? email,
    String? type,
    String? password,
    int? countyId,
    int? cityId,
  }) async {
    var map = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'country_id': countyId,
      'city_id': cityId,
      'type': type,
      'password': password,
      'password_confirmation': password,
    };
    log(map.toString());
    var request = await _dio.post("auth/register", data: map);
    return request;
  }

  Future<Response> login({
    String? email,
    String? password,
    String? provider,
  }) async {
    var map = {
      'email': email,
      'password': password,
      'provider': provider,
    };
    log(map.toString());
    var request = await _dio.post("auth/login", data: map);
    return request;
  }

  Future<Response> loginSocial({
    String? firstName,
    String? lastName,
    String? email,
    String? type,
    String? provider,
  }) async {
    var map = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'page': type,
      'provider': provider,
    };
    log(map.toString());
    var request = await _dio.post("auth/login", data: map);
    return request;
  }

  Future<Response> forgetPassword({
    String? email,
  }) async {
    var map = {
      'email': email,
    };
    return await _dio.post("passwordCode/forgetPasswordCode", data: map);
  }

  Future<Response> checkValdationCode({
    required String? email,
    required String? code,
  }) async {
    var map = {
      'email': email,
      'code': code,
    };
    return await _dio.post("passwordCode/check_code", data: map);
  }

  Future<Response> resetNewPassword(
      {required String? email,
      required String? code,
      required String? password,
      required String? confirmationPassword}) async {
    var map = {
      'email': email,
      'code': code,
      'password': password,
      "password_confirmation": confirmationPassword
    };
    return await _dio.post("passwordCode/resetPasswordCode", data: map);
  }

  Future<Response> changePassword({
    String? currentPassword,
    String? password,
    String? passwordConfirmation,
  }) async {
    var map = {
      'password': currentPassword,
      'new_password': password,
      'new_password_confirmation': passwordConfirmation,
    };
    log(map.toString());
    return await _dio.post("auth/update-password", data: map);
  }

  Future<Response> uploadUserPhoto({
    String? image,
  }) async {
    return await _dio.post("auth/upload/user/photo",
        data: FormData.fromMap(
            {if (image != null) 'image': await MultipartFile.fromFile(image)}));
  }

  Future<Response> uploadUserIdentity({
    String? image,
  }) async {
    return await _dio.post("auth/upload_identity",
        data: FormData.fromMap(
            {if (image != null) 'image': await MultipartFile.fromFile(image)}));
  }

  Future<Response> switchUserType() async {
    return await _dio.post("auth/switch_user");
  }

  Future<Response> logout() async {
    return await _dio.get("auth/logout");
  }

  Future<Response> getRefLink({int page = 1}) async {
    return await _dio.get("auth/get_ref_link",
        queryParameters: {'page': page, 'limit': 1000});
  }

  ///Profile
  Future<Response> getTeacherProfile() async {
    return await _dio.get(HiveController.getIsStudent()
        ? 'auth/student_general_profile'
        : "auth/teacher_general_profile");
  }

  Future<Response> setUserNotificationId(token) async {
    return await _dio.post("token", data: {
      'type': 'OneSignal',
      'token': token,
      'device': Platform.isAndroid ? 'android' : 'ios'
    });
  }

  Future<Response> updateNotificationUser(
    bool notificationSound,
    bool notificationSend,
  ) async {
    return await _dio.post("auth/updateNotificationUser", data: {
      'notification_sound': notificationSound ? 1 : 0,
      'notification_send': notificationSend ? 1 : 0,
    });
  }

  Future<Response> getNotification() async {
    return await _dio.get("auth/get_user_notifications");
  }

  ///---------------------- Subjects ----------------------///
  Future<Response> createSubject({
    String? name,
  }) async {
    return await _dio.post("subject", data: {
      'name': {
        'ar': name,
        'en': name,
      },
    });
  }

  ///---------------------- Categories ----------------------///
  Future<Response> createCategory({
    String? name,
    int? subjectId,
  }) async {
    return await _dio.post("teacher/category",
        data: {'category_name': name, 'subject_id': subjectId});
  }

  ///---------------------- Website ----------------------///
  /// Get
  Future<Response> getCountries() async {
    return await _dio.get('get/country');
  }

  Future<Response> getCities({int? countryId}) async {
    return await _dio.get('get/city', queryParameters: {'id': countryId});
  }

  Future<Response> getLanguages() async {
    return await _dio.get('get/language_wibsite');
  }

  Future<Response> getSubjects() async {
    return await _dio.get('get/subject_with_image');
  }

  Future<Response> getCategories() async {
    return await _dio.get('get/category');
  }

  Future<Response> getAvalibleLanguages() async {
    return await _dio.get('get/language_wibsite');
  }

  Future<Response> getTimezone(countryId) async {
    return await _dio.get('get/timezone/$countryId');
  }

  Future<Response> getFAQs({required String type}) async {
    return await _dio.get('get/faqs', queryParameters: {'type': type});
  }

  Future<Response> getPages(typePage) async {
    return await _dio.get('youlearnt/pages?type_page=$typePage');
  }

  Future<Response> getTeacherBySlug(String? slug) async {
    log('Slug => $slug');
    return await _dio.get('youlearnt/user/$slug');
  }

  Future<Response> getRatingTeacherBySlug(String? slug) async {
    return await _dio.get('youlearnt/user/rating/$slug');
  }

  Future<Response> getUsersBySlugs(List<String?> list) async {
    return await _dio.get('auth/get_users', queryParameters: {'users[]': list});
  }

  Future<Response> uploadChatPhoto({
    String? image,
  }) async {
    return await _dio.post("auth/uploadChatPhoto",
        data: FormData.fromMap(
            {if (image != null) 'image': await MultipartFile.fromFile(image)}));
  }

  Future<Response> getTutors({
    int? subjectId,
    int? countryId,
    int? languageId,
    int? speakId,
    String? name,
    String? startedTime,
    String? endTime,
    String? timezone,
    String? ordering,
    String? soringDirection,
    required String startPrice,
    required String endPrice,
    int? page,
  }) async {
    var queryParameters = {
      if (subjectId != null) 'subject': subjectId,
      if (countryId != null) 'country': countryId,
      if (languageId != null) 'language': languageId,
      if (speakId != null) 'speak': speakId,
      if (name != null) 'search': name,
      if (startedTime != null) 'time_start': startedTime,
      if (endTime != null) 'time_end': endTime,
      if (timezone != null) 'timezone': timezone,
      if (ordering != null) 'sorted[$ordering]': soringDirection,
      if (startPrice.isNotEmpty) 'start_price': startPrice,
      if (endPrice.isNotEmpty) 'last_price': endPrice,
      'page': page,
      'search_type': name == null ? 'advanced' : 'normal',
      'limit': 1000
    };
    log(queryParameters.toString());
    return await _dio.get('search/tutor', queryParameters: queryParameters);
  }

  Future<Response> getStudents({
    String? name,
  }) async {
    return await _dio.get('search/student', queryParameters: {
      'name': name,
    });
  }

  Future<Response> getWebsiteCommunity({String? search}) async {
    return await _dio.get("search/community",
        queryParameters: {'page': 1, 'limit': 1000, 'search': search});
  }

  Future<Response> addCommunityComment(int? id, String comment) async {
    return await _dio
        .post("student/community/comments/$id/comment?comment=$comment");
  }

  Future<Response> addLikeOnComment(int? id, bool like) async {
    return await _dio.get("student/community/comments/$id/comment/like");
  }

  Future<Response> getWebsiteBlogs({String? search}) async {
    return await _dio.get("search/blog",
        queryParameters: {'page': 1, 'limit': 1000, 'search': search});
  }

  Future<Response> getBlogDetails({int? id}) async {
    return await _dio
        .get("search/blog/$id", queryParameters: {'page': 1, 'limit': 1000});
  }

  Future<Response> addBlogComment(int? id, String comment, String emoji) async {
    return await _dio.post("auth/blog/comment/$id",
        data: FormData.fromMap({'comment': comment}));
    // return await _dio.post("auth/blog/comment/$id",
    //     data: FormData.fromMap({'emoji': emoji, 'comment': comment}));
  }

  Future<Response> addRemoveBlogEmoji(int id, String emoji) async {
    // log("id $id");
    // log("emoji $emoji");
    var map = {"emoji": emoji.toString(), "blog_id": id.toString()};

    log(map.toString());
    return await _dio.post("auth/blog-emoji", data: map);
  }

  Future<Response> getTimesBySlug(String? slug) async {
    return await _dio.get("guest/book/$slug");
  }

  ///---------------------- Teacher ----------------------///
  ///Book
  Future<Response> addBook({
    String? title,
    String? status,
    String? type,
    String? startAt,
    String? endAt,
  }) async {
    var map = {
      'title': title,
      'status': status,
      'type': type,
      'start_at': startAt,
      'end_at': endAt,
    };
    log(map.toString());
    return await _dio.post("teacher/profile/book", data: map);
  }

  Future<Response> deleteBook({
    int? id,
  }) async {
    return await _dio.delete("teacher/profile/book/$id");
  }

  Future<Response> getTimes({int? month}) async {
    return await _dio
        .get("teacher/profile/book", queryParameters: {'month': month});
  }

  ///certifications
  Future<Response> addCertification({
    required List<CertificationModel> certificationsList,
  }) async {
    Map<String, dynamic> map = {};
    int index = 0;
    await Future.forEach<CertificationModel>(certificationsList,
        (element) async {
      map['certification[$index][subject_id]'] = element.id;
      map['certification[$index][issued_by]'] = element.issuedBy.text;
      map['certification[$index][issued_date]'] = element.issuedDate;
      //log(map.toString());
      if (element.certificationImage != null) {
        map['certification[$index][certification_image]'] =
            await MultipartFile.fromFile(element.certificationImage!);
      }
      index++;
    });

    return await _dio.post("teacher/profile/background",
        data: FormData.fromMap(map));
  }

  Future<Response> getCertifications() async {
    return await _dio.get("teacher/profile/certification",
        queryParameters: {'page': 1, 'limit': 1000});
  }

  Future<Response> geBackgroundHelper(
      {required String type, required String searchKey}) async {
    // log(type);
    return await _dio.get("teacher/profile/background-helper",
        queryParameters: {'type': type, 'search': searchKey});
  }

  Future<Response> deleteCertifications(int? id) async {
    return await _dio.delete("teacher/profile/certification/$id");
  }

  ///education
  Future<Response> addEducation({
    required List<EducationModel> educationsList,
  }) async {
    Map<String, dynamic> map = {};
    int index = 0;
    await Future.forEach<EducationModel>(educationsList, (element) async {
      map['education[$index][degree]'] = element.degree.text;
      map['education[$index][university]'] = element.university.text;
      map['education[$index][specialization]'] = element.specialization.text;
      map['education[$index][degree_type]'] = element.degreeType.text;
      map['education[$index][start_at]'] = element.startAt;
      map['education[$index][end_at]'] = element.endAt;
      if (element.educationImage != null) {
        map['education[$index][education_image]'] =
            await MultipartFile.fromFile(element.educationImage!);
      }
      index++;
    });

    return await _dio.post("teacher/profile/education",
        data: FormData.fromMap(map));
  }

  Future<Response> getEducation() async {
    return await _dio.get("teacher/profile/education",
        queryParameters: {'page': 1, 'limit': 1000});
  }

  Future<Response> deleteEducation(int? id) async {
    return await _dio.delete("teacher/profile/education/$id");
  }

  ///experience
  Future<Response> addExperience({
    required List<ExperienceModel> educationsList,
  }) async {
    Map<String, dynamic> map = {};
    int index = 0;
    await Future.forEach<ExperienceModel>(educationsList, (element) async {
      map['exp[$index][position]'] = element.position.text;
      map['exp[$index][company]'] = element.company.text;
      map['exp[$index][start_at]'] = element.startAt;
      map['exp[$index][end_at]'] = element.endAt;
      index++;
    });

    return await _dio.post("teacher/profile/experience",
        data: FormData.fromMap(map));
  }

  Future<Response> getExperience() async {
    return await _dio.get("teacher/profile/experience",
        queryParameters: {'page': 1, 'limit': 1000});
  }

  Future<Response> deleteExperience(int? id) async {
    return await _dio.delete("teacher/profile/experience/$id");
  }

  Future<Response> updateTeacherProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? type,
    String? mobile,
    String? birthday,
    String? timezone,
    String? cityName,
    String? level,
    String? gender,
    int? countyId,
    int? countyOriginId,
    int? languageId,
    int? cityId,
  }) async {
    var map = {
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (countyOriginId != null) 'origin_country_id': countyOriginId,
      if (countyId != null) 'country_id': countyId,
      if (cityId != null) 'city_id': cityId,
      if (mobile != null) 'mobile': mobile,
      if (birthday != null) 'birthday': birthday,
      if (level != null) 'language[0][level]': level,
      if (languageId != null) 'language[0][id]': languageId,
      if (timezone != null) 'timezone': timezone,
      if (cityName != null) 'city_name': cityName,
      if (gender != null) 'gender': gender,
    };
    log(json.encode(map));
    var request = await _dio.post(
        HiveController.getIsStudent()
            ? 'student/profile/store'
            : 'teacher/profile/info',
        data: FormData.fromMap(map));
    return request;
  }

  Future<Response> updateTeacherDescription({
    String? bio,
    String? introduceYourSelf,
    String? introduceYourSelfOtherLanguage,
    String? publicLink,
    String? customLink,
    List<SubjectModel>? subject,
  }) async {
    Map<String, dynamic> map = {
      if (bio != null) 'bio': bio,
      if (introduceYourSelf != null) 'introduceYourSelf': introduceYourSelf,
      if (introduceYourSelfOtherLanguage != null)
        'introduceYourSelfOtherLanguage': introduceYourSelfOtherLanguage,
      if (publicLink != null) 'introduce_video_link': publicLink,
      if (customLink != null) 'customLink': customLink,
    };
    int index = 0;
    if (subject != null && subject.isNotEmpty) {
      await Future.forEach<SubjectModel>(subject, (element) async {
        int index2 = 0;
        int index3 = 0;
        int index4 = 0;
        map['subject[$index][id]'] = element.subjectId ?? element.id;
        map['subject[$index][certification_hour]'] =
            int.parse(element.certificationHourController.text);
        map['subject[$index][description]'] =
            element.descriptionController.text;
        map['subject[$index][hourlyRate]'] = element.hourRateController.text;
        for (var element in element.youtubeLinkControllerList) {
          map['subject[$index][youtubeLink][$index2]'] = element.text;
          index2++;
        }
        for (var element in element.uploadedVideosPaths) {
          map['subject[$index][videos_url][$index4]'] =
              await MultipartFile.fromFile(element);
          index4++;
        }
        for (var element in element.images) {
          if (element != null) {
            map['subject[$index][imagelist][$index3]'] =
                await MultipartFile.fromFile(element ?? '');
            index3++;
          }
        }
        index++;
      });
    }

    var request =
        await _dio.post("teacher/profile", data: FormData.fromMap(map));
    return request;
  }

  ///Blogs
  Future<Response> addBlog(bool edit,
      {String? title,
      String? subTitle,
      String? description,
      List<String>? tags,
      String? blogImage,
      int? categoryId,
      int? languageId,
      int? blogId}) async {
    Map<String, dynamic> map = {
      'title': title,
      'description': description,
      'sub_title': subTitle,
      'category_id': categoryId,
      "language_id": languageId,
      if (edit) '_method': 'PUT'
    };
    int index = 0;
    tags?.forEach((element) {
      map['tag[$index]'] = element;
      index++;
    });
    // log(map.toString());
    if (blogImage != null) {
      map['blog_image'] = await MultipartFile.fromFile(blogImage);
    }
    log(edit.toString() + blogId.toString());
    return edit
        ? await _dio.post("teacher/blog/$blogId", data: FormData.fromMap(map))
        : await _dio.post("teacher/blog", data: FormData.fromMap(map));
  }

  Future<Response> getBlogs() async {
    return await _dio
        .get("teacher/blog", queryParameters: {'page': 1, 'limit': 1000});
  }

  Future<Response> deleteBlog(int? blogId) async {
    return await _dio.delete("teacher/blog/$blogId");
  }

  ///Community
  Future<Response> addCommunity(bool edit,
      {String? title,
      String? description,
      List<String>? tags,
      int? subjectId,
      int? categoryId,
      int? languageId,
      int? communityId}) async {
    Map<String, dynamic> map = {
      'title': title,
      'description': description,
      'subject_id': subjectId,
      "language_id": languageId,
      'category_id': categoryId,
      if (edit) '_method': 'PUT'
    };
    int index = 0;
    tags?.forEach((element) {
      map['tag[$index]'] = element;
      index++;
    });
    log(map.toString());
    return edit
        ? await _dio.post(
            "${HiveController.getIsStudent() ? 'student' : 'teacher'}/community/$communityId}",
            data: map)
        : await _dio.post(
            "${HiveController.getIsStudent() ? 'student' : 'teacher'}/community",
            data: FormData.fromMap(map));
  }

  Future<Response> deleteCommunity(int? communityId) async {
    return await _dio.delete(
        "${HiveController.getIsStudent() ? 'student' : 'teacher'}/community/$communityId");
  }

  Future<Response> getCommunity() async {
    return await _dio.get(
        "${HiveController.getIsStudent() ? 'student' : 'teacher'}/community",
        queryParameters: {'page': 1, 'limit': 1000});
  }

  Future<Response> getCommunityDetails(id) async {
    return await _dio.get("get/community/$id/comments");
  }

  Future<Response> newProposal({
    int? id,
    String? price,
    String? description,
  }) async {
    return await _dio.post("teacher/proposal/$id",
        data: FormData.fromMap({
          'price': price,
          'description': description,
        }));
  }

  Future<Response> getStatistics() async {
    return await _dio.get("teacher/profile/statistics");
  }

  Future<Response> getWithdraw(bool isStudent) async {
    return await _dio
        .get("${isStudent ? 'student' : 'teacher'}/profile/withdrow");
  }

//  classroom
  Future<Response> fetchTeacherClassrooms() async {
    return await _dio.get("teacher/profile/classroom");
  }

  Future<Response> fetchStudentCancelledClassrooms() async {
    return await _dio.get("student/cancelled-book");
  }

  Future<Response> fetchTeacherClassroomDetails(int classId) async {
    return await _dio.get("teacher/profile/classroom/$classId");
  }

  Future<Response> fetchTeacherPrivateSuggestDetails(int suggestId) async {
    return await _dio.get("teacher/suggest-book-request/$suggestId");
  }

  Future<Response> fetchStudentPrivateSuggestDetails(int suggestId) async {
    return await _dio.get("student/suggest-book-request/$suggestId");
  }

  Future<Response> fetchStudnetClassrooms(int page) async {
    return await _dio.get("student/class-room?page=$page");
  }

  Future<Response> fetchStudnetReschudeledBooks(int page) async {
    return await _dio.get("student/reschedule-book-request?page=$page");
  }

  Future<Response> fetchTeacherSuggetsBooks(int page) async {
    return await _dio.get("teacher/suggest-book-request?page=$page");
  }

  Future<Response> fetchStudentSuggetsBooks(int page) async {
    return await _dio.get("student/suggest-book-request?page=$page");
  }

  Future<Response> fetchTeacherAvalibleClassrooms(String teacherSlug) async {
    return await _dio.get("order/group-class/$teacherSlug");
  }

  Future<Response> fetchStudnetClassroomDetails(int classId) async {
    return await _dio.get("student/class-room/$classId");
  }

  Future<Response> getStudentReqestProposals(int requestId) async {
    return await _dio.get("student/post/$requestId");
  }

  Future<Response> updateStudentReqestProposalsStatus(
      int requestId, String staus) async {
    return await _dio
        .post("student/handel-proposal/$requestId", data: {"status": staus});
  }

  Future<Response> deleteTeahcerSubjectItem(
      {required int subjectId,
      required String url,
      required String type}) async {
    var map = {"teacher_subject_id": subjectId, "type": type, "url": url};
    log(map.toString());
    return await _dio.post("teacher/profile/delete-subject-files", data: map);
  }

  Future<Response> fetchStudnetReschdueldBookClassroomDetails(
      int rescId) async {
    return await _dio.get("student/reschedule-book-request/$rescId");
  }

  Future<Response> fetchTeacherAvalibleClassroomDetails(int classId) async {
    return await _dio.get("order/group-class/show/$classId");
  }

  Future<Response> addNewClassroom(bool edit,
      {String? title,
      String? description,
      String? subjectId,
      List<Map>? dates,
      String? maxStudent,
      String? classPrice,
      String? classId}) async {
    Map<String, dynamic> map = {
      'title': title,
      'description': description,
      if (!edit) 'teacher_subject_id': subjectId,
      if (!edit) 'dates': dates,
      'max_student': maxStudent,
      if (!edit) 'price': classPrice,
      if (edit) '_method': 'PUT'
    };
    log(map.toString());
    return edit
        ? await _dio.post("teacher/profile/classroom/$classId",
            data: FormData.fromMap(map))
        : await _dio.post("teacher/profile/classroom",
            data: FormData.fromMap(map));
  }

  Future<Response> deleteTeacherClassroom(String classId) async {
    return await _dio.delete("teacher/profile/classroom/$classId");
  }

  Future<Response> deleteTeacherClassroomBookedId(String bookId) async {
    return await _dio.delete("teacher/profile/classroom/book/$bookId");
  }

  Future<Response> reschdeulTeacherBook({
    required String startAt,
    required String endAt,
    required String classroomId,
  }) async {
    Map<String, dynamic> map = {
      "book_id": classroomId,
      "type": "rescheduled",
      "time_form": startAt,
      "time_to": endAt
    };
    log(map.toString());
    return await _dio.post("teacher/cancelled-book",
        data: FormData.fromMap(map));
  }

  Future<Response> teacherSuggestNewBook({
    required String startAt,
    required String endAt,
    required String classroomId,
  }) async {
    Map<String, dynamic> map = {
      "classroom_id": classroomId,
      "from": startAt,
      "to": endAt,
    };
    log(map.toString());
    return await _dio.post("teacher/suggest-book-request",
        data: FormData.fromMap(map));
  }

  Future<Response> cancelTeacherPrivateBook({
    required String bookId,
  }) async {
    Map<String, dynamic> map = {
      "book_id": bookId,
      "type": "cancelled",
    };
    return await _dio.post("teacher/cancelled-book",
        data: FormData.fromMap(map));
  }

  Future<Response> updateStudentRescduledBookStatus(
      {required String requestId, required String status}) async {
    Map<String, dynamic> map = {"status": status, '_method': 'PUT'};
    return await _dio.post("student/reschedule-book-request/$requestId",
        data: FormData.fromMap(map));
  }

  Future<Response> updateStudentSuugestBookStatus(
      {required String suggestId, required String status}) async {
    Map<String, dynamic> map = {"status": status, '_method': 'PUT'};
    log(map.toString());
    return await _dio.post("student/suggest-book-request/$suggestId",
        data: FormData.fromMap(map));
  }

  Future<Response> deleteTeacherSuggestBook(String suggestID) async {
    return await _dio.delete("teacher/suggest-book-request/$suggestID");
  }

  Future<Response> updateStudentBookActionsType(
      {required String bookId, required String type, String? newBookId}) async {
    Map<String, dynamic> map = {
      "book_id": bookId,
      "type": type,
      if (newBookId != null) "new_book_date": newBookId
    };
    log(map.toString());
    return await _dio.post("student/cancelled-book",
        data: FormData.fromMap(map));
  }

  Future<Response> getTeacherAvalibleSuggstedBooks(
      {required String teacherSlug, required String teacherSubjectId}) async {
    return await _dio.get("guest/book/$teacherSlug", queryParameters: {
      'status[]': "available",
      "type": "one"
      // 'teacher_subject_id': teacherSubjectId

      // 'teacher_subject_id': 99
    });
  }

  ///---------------------- Student ----------------------///
  ///Favorite
  Future<Response> addToFavorite({String? slug}) async {
    return await _dio.post("student/profile/fav/$slug");
  }

  Future<Response> getFavoriteItems() async {
    return await _dio.get("student/profile/fav");
  }

  ///Posts
  Future<Response> addPost(
      {String? title,
      String? description,
      int? subjectId,
      String? startPrice,
      String? endPrice}) async {
    Map<String, dynamic> map = {
      'title': title,
      'description': description,
      'subject_id': subjectId,
      'start_price': startPrice,
      'end_price': endPrice,
    };
    log(map.toString());
    return await _dio.post("student/post", data: FormData.fromMap(map));
  }

  Future<Response> getPosts() async {
    return await _dio.get("student/profile/posts",
        queryParameters: {'page': 1, 'limit': 1000});
  }

  Future<Response> addStudentRecommendations({
    List<int?>? subjectsIdsList,
    List<int?>? countriesIdsList,
    List<int?>? languageIdsList,
  }) async {
    Map<String, dynamic> map = {};
    var subjectIds = [];
    subjectsIdsList?.forEach((element) {
      if (element != null) subjectIds.add(element);
    });
    map['subject_id'] = subjectIds;
    map['country_id'] = countriesIdsList;
    map['language_id'] = languageIdsList;
    log(map.toString());
    return await _dio.post("student/profile/recommendation", data: map);
  }

  Future<Response> getStudentRecommendations() async {
    return await _dio.get("student/profile/recommendation",
        queryParameters: {'page': 1, 'limit': 1000});
  }

  Future<Response> getStudentBooks({int? month}) async {
    return await _dio
        .get("student/profile/books", queryParameters: {'month': month});
  }

  Future<Response> getTeacherBooks({int? month}) async {
    return await _dio
        .get("teacher/profile/book", queryParameters: {'month': month});
  }

  Future<Response> joinTeacherAvalibleCourse({
    String? classroomId,
  }) async {
    Map<String, dynamic> map = {
      'classroom_id': classroomId,
    };
    // log(map.toString() + slug.toString());
    return await _dio.post("order/group-class-reservation",
        data: FormData.fromMap(map));
  }

  ///-------------------------------------------- Order --------------------------------------------///
  Future<Response> createOrder({
    String? slug,
    int? bookId,
    int? teacherSubjectId,
    String? hour,
  }) async {
    Map<String, dynamic> map = {
      'book_id': bookId,
      'teacher_subject': teacherSubjectId,
      if (hour != null) 'hour': hour,
    };
    log(map.toString() + slug.toString());
    return await _dio.post("order/$slug", data: FormData.fromMap(map));
  }

  /* 
  Sulaiman work  for singel student reservations
   */

  Future<Response> checkIfOrderBefore({
    String? slug,
  }) async {
    return await _dio.get("order/$slug");
  }

  Future<Response> createExperimnetalBook({
    String? teachersubjectID,
    int? bookId,
    int? propaslId,
  }) async {
    Map<String, dynamic> map = {
      'book_id': bookId,
      'teacher_subject_id': teachersubjectID,
      if (propaslId != null) "proposel_id": propaslId
    };
    log(map.toString());
    return await _dio.post("order/experimental-book",
        data: FormData.fromMap(map));
  }

  Future<Response> reservationBookIFPackagesExists(
      {required String? teachersubjectID,
      required int? bookId,
      required String? hour}) async {
    Map<String, dynamic> map = {
      'book_id': bookId,
      'teacher_subject_id': teachersubjectID,
      'hour': hour
    };
    log("map:" + map.toString());
    return await _dio.post("order/package", data: FormData.fromMap(map));
  }

/* 
end  Sulaiman work
   */

  Future<Response> getPackages({
    int? teacherSubjectId,
    String? slug,
  }) async {
    log(teacherSubjectId.toString());
    log(slug.toString());
    return await _dio.get("order/package/$slug",
        queryParameters: {'teacher_subject_id': teacherSubjectId});
  }

  Future<Response> getMeetUrl({
    int? id,
  }) async {
    return await _dio.get("auth/meet_link", queryParameters: {'id': id});
  }

  Future<Response> translateMap({
    required Map<String, String> map,
  }) async {
    onInit();
    Map<String, String> newMap = {};
    int index = 0;
    map.forEach((key, value) {
      newMap['lang[$index]'] = key;
      index++;
    });
    var res = await _dio.post("translate", data: FormData.fromMap(map));
    return res;
  }

  // check if the student has free lessons
  Future<Response> checkHasfreeLessons({
    String? teacherSlug,
    int? teacherSubjectId,
  }) async {
    return await _dio.get("order/$teacherSlug", queryParameters: {
      'teacher_subject_id': teacherSubjectId,
    });
  }

  ///report
  Future<Response> report({
    required int reportedId,
    required String title,
    required String description,
    required List<String> imagesList,
  }) async {
    Map<String, dynamic> map = {};
    map['reported_id'] = reportedId;
    map['title'] = title;
    map['description'] = description;
    int index = 0;
    await Future.forEach<String>(imagesList, (element) async {
      map['image[$index]'] = await MultipartFile.fromFile(element);
      index++;
    });

    return await _dio.post("auth/report", data: FormData.fromMap(map));
  }

  ///contactUs
  Future<Response> contactUs({
    int? subjectId,
    required String name,
    required String email,
    required String body,
    String? phone,
  }) async {
    Map<String, dynamic> map = {};
    map['email'] = email;
    map['name'] = name;
    map['subject_id'] = subjectId;
    map['body'] = body;
    map['phone'] = phone;
    return await _dio.post("guest/contact_us", data: FormData.fromMap(map));
  }

// Withdraw & Deposit

// teacher
  Future<Response> getTeacherWallets() async {
    return await _dio.get(
      "auth/withdraw-method",
    );
  }

  Future<Response> addAccountTowallet(bool edit,
      {String? type,
      String? email,
      String? accountNumber,
      String? accountHolder,
      String? routingNumber,
      String? swiftBic,
      String? accountId}) async {
    Map<String, dynamic> map = {
      'type': type,
      'email': email,
      'account_number': accountNumber,
      'account_holder': accountHolder,
      'routing_number': routingNumber,
      'swift_bic': swiftBic,
      if (edit) '_method': 'PUT'
    };
    return edit
        ? await _dio.post("auth/withdraw-method/$accountId",
            data: FormData.fromMap(map))
        : await _dio.post("auth/withdraw-method", data: FormData.fromMap(map));
  }

  Future<Response> deleteAcoountWallet(String walletId) async {
    return await _dio.delete("auth/withdraw-method/$walletId");
  }

  Future<Response> withdrawWalletRequest(
      {required String ammount,
      required WalletAccountModel accountModel}) async {
    Map<String, dynamic> map = {
      "type": accountModel.type,
      "withdraw_method_id": accountModel.id,
      "amount": ammount
    };

    return await _dio.post("auth/withdraw-request",
        data: FormData.fromMap(map));
  }

  Future<Response> withdrawPaypalRequest(
      {required String ammount, required String paypalEmail}) async {
    Map<String, dynamic> map = {"paypal_email": paypalEmail, "amount": ammount};

    return await _dio.post("paypal-withdraw", data: FormData.fromMap(map));
  }

  Future<Response> chargePaypalepage({
    required String ammount,
  }) async {
    Map<String, dynamic> map = {"amount": ammount};

    return await _dio.post("paypal-charge", data: FormData.fromMap(map));
  }

  Future<Response> chargeStripePage({required String userId}) async {
    return await _dio.get(
      "strip-charge?user_id=$userId",
    );
  }

  Future<Response> getTransctionsList(
      {int? page, String? type, String? status}) async {
    Map<String, dynamic> queryMap = {
      "page": page,
    };
    if (type != null) {
      queryMap["type"] = type;
    }
    if (status != null) {
      queryMap["status"] = status;
    }
    return await _dio.get("auth/transaction", queryParameters: queryMap);
  }
}
