import 'package:you_learnt/entities/CommonModel.dart';

import 'ProfileModel.dart';
import 'SubjectModel.dart';

class TutorModel {
  TutorModel.fromJson(dynamic json) {
    fullName = json['full_name'];
    emailVerifiedAt = json['email_verified_at'];
    slug = json['slug'];
    type = json['type'];
    lastLoginAt = json['last_login_at'];
    timezone = json['timezone'];
    //level = json['level'];
    gender = json['gender'];
    status = json['status'];
    countryFlag = json['country_flag'];
    languagesFlag = json['languages_flag'];
    rating = json['rating'];
    reviews = json['reviews'];
    imageUrl = json['image_url'];
    favoritesExists = json['favorites_exists'];
    teachers = json['teachers'] != null
        ? ProfileModel.fromJson(json['teachers'])
        : null;

    if (json['teacher_subject'] != null) {
      subjects = [];
      json['teacher_subject'].forEach((v) {
        if (SubjectModel.fromJson(v).subjectName?.isNotEmpty == true) {
          subjects?.add(SubjectModel.fromJson(v));
        }
      });
    }
    if (json['user_language'] != null) {
      languages = [];
      json['user_language'].forEach((v) {
        languages?.add(CommonModel.fromJson(v));
      });
    }
  }

  String? fullName;
  String? emailVerifiedAt;
  String? slug;
  String? type;
  String? lastLoginAt;
  String? timezone;
  String? level;
  dynamic gender;
  String? status;
  String? countryFlag;
  String? languagesFlag;
  String? rating;
  int? reviews;
  String? imageUrl;
  bool? favoritesExists;
  ProfileModel? teachers;
  List<SubjectModel>? subjects;
  List<CommonModel>? languages;
  List<CommonModel>? languagesProfile;
}
