import 'package:you_learnt/entities/ProfileModel.dart';
import 'package:you_learnt/entities/SubjectModel.dart';

import 'CommonModel.dart';

class UserModel {
  UserModel.fromJson(dynamic json) {
    firstName = json['first_name'];
    date = json['date'];
    lastName = json['last_name'];
    email = json['email'];
    mobile = json['mobile'];
    type = json['type'];
    slug = json['slug'];
    status = json['status'];
    gender = json['gender'];
    birthday = json['birthday'];
    id = json['id'];
    wallet = double.tryParse(json['wallet'].toString()) ?? 0;
    token = json['token'];
    refreshToken = json['refresh_token'];
    fullName = json['full_name'];
    referralLink = json['referral_link'];
    imageUrl = json['image_url'];
    completeProfile = json['complete_profile'];
    notificationSend = json['notification_send'];
    notificationSound = json['notification_sound'];
    favoritesExists = json['favorites_exists'];
    profile =
        json['profile'] != null ? ProfileModel.fromJson(json['profile']) : null;
    if (json['teacherSubject'] != null) {
      teacherSubject = [];
      json['teacherSubject'].forEach((v) {
        teacherSubject?.add(SubjectModel.fromJson(v));
      });
    }
    try {
      verified = json['verifide_identity']['verify'];
      isIdentityUploaded = json['verifide_identity']['is_upload_photo'];
    } catch (e) {}

    if (json['languages'] != null) {
      languagesProfile = [];
      json['languages'].forEach((v) {
        languagesProfile?.add(CommonModel.fromJson(v));
      });
    }
  }

  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? birthday;
  String? type;
  String? slug;
  String? status;
  String? gender;
  String? date;
  int? id;
  int? completeProfile;
  int? notificationSound;
  int? notificationSend;
  String? token;
  String? refreshToken;
  String? fullName;
  String? referralLink;
  String? imageUrl;
  bool? verified;
  bool? isIdentityUploaded;
  bool? favoritesExists;
  ProfileModel? profile;
  List<SubjectModel>? teacherSubject;
  List<CommonModel>? languagesProfile;
  double? wallet;
}
