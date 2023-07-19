import 'package:you_learnt/entities/CertificationModel.dart';
import 'package:you_learnt/entities/EducationModel.dart';
import 'package:you_learnt/entities/ProfileModel.dart';
import 'package:you_learnt/entities/SubjectModel.dart';

import 'UserModel.dart';

class TeacherModel {
  ProfileModel? profile;
  UserModel? user;
  List<CertificationModel>? certifications;
  List<EducationModel>? educations;
  List<SubjectModel>? subjects;
  List<String?> images = [];
  List<String?> videos = [];

  TeacherModel.fromJson(dynamic json) {
    profile =
        json['profile'] != null ? ProfileModel.fromJson(json['profile']) : null;
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    if (json['certifications'] != null) {
      certifications = [];
      json['certifications'].forEach((v) {
        certifications?.add(CertificationModel.fromJson(v));
      });
    }
    if (json['educations'] != null) {
      educations = [];
      json['educations'].forEach((v) {
        educations?.add(EducationModel.fromJson(v));
      });
    }
    if (json['subjects'] != null) {
      subjects = [];
      json['subjects'].forEach((v) {
        subjects?.add(SubjectModel.fromJson(v));
      });

      subjects?.forEach((element) {
        images.addAll(element.images);
      });
      subjects?.forEach((element) {
        videos.addAll(
            element.youtubeLinkControllerList.map((e) => e.text).toList());
      });
    }
  }
}
