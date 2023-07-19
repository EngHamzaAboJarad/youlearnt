import 'dart:collection';
import 'dart:convert';
import 'dart:math';

class StatisticsModel {

  StatisticsModel.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    slug = json['slug'];
    amount = json['amount'];
    amountCanDrow = json['amount_can_drow'];
    referrerId = json['referrer_id'];
    mobile = json['mobile'];
    identetyVerifiedAt = json['identety_verified_at'];
    type = json['type'];
    status = json['status'];
    report = json['report'] != null ? Report.fromJson(json['report']) : null;
    lessons = json['lessons'] != null ? Lessons.fromJson(json['lessons']) : null;
    achievements = json['achievements'] != null ? Achievements.fromJson(json['achievements']) : null;
    fullName = json['full_name'];
    referralLink = json['referral_link'];
    imageUrl = json['image_url'];
  }
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  dynamic emailVerifiedAt;
  String? slug;
  num? amount;
  num? amountCanDrow;
  dynamic referrerId;
  dynamic mobile;
  dynamic identetyVerifiedAt;
  String? type;
  String? status;
  Report? report;
  Lessons? lessons;
  Achievements? achievements;
  String? fullName;
  dynamic referralLink;
  String? imageUrl;


}

class Achievements {
  Achievements.fromJson(dynamic json) {
    totalIncomeEarned = json['total_income_earned'];
    totalHour = json['total_hour'];
    rating = json['rating'];
    reviews = json['reviews'];
  }
  int? totalIncomeEarned;
  int? totalHour;
  String? rating;
  int? reviews;
}

class Lessons {
  Lessons.fromJson(dynamic json) {
    if (json['teacher_subject'] != null) {
      teacherSubject = [];
      json['teacher_subject'].forEach((v) {
        teacherSubject?.add(TeacherSubject.fromJson(v));
      });
    }
    totalStudents = json['total_students'];
    totalStudentsNew = json['total_students_new'];
    totalBooks = json['total_books'];
    newBooks = json['new_books'];
    canceledLessons = json['canceled_lessons'];
    absences = json['absences'];
    totalStudentsLastMonth = json['total_students_last_month'];
    if (json['new_stu_statstic'] != null) {
      newStuStatstic = [];
      json['new_stu_statstic'].forEach((v) {
       newStuStatstic?.add(v);
        //newStuStatstic?.add(Random().nextInt(100));
      });
    }
    if (json['last_month_stu_statstic'] != null) {
      lastMonthStuStatstic = [];
      json['last_month_stu_statstic'].forEach((v) {
        lastMonthStuStatstic?.add(v);
        //lastMonthStuStatstic?.add(Random().nextInt(100));
      });
    }
  }
  List<TeacherSubject>? teacherSubject;
  int? totalStudents;
  int? totalStudentsNew;
  int? totalBooks;
  int? newBooks;
  int? canceledLessons;
  int? absences;
  int? totalStudentsLastMonth;
  List<int>? newStuStatstic;
  List<int>? lastMonthStuStatstic;

}

class TeacherSubject {

  TeacherSubject.fromJson(dynamic json) {
    id = json['id'];
    subjectId = json['subject_id'];
    userId = json['user_id'];
    hourlyRate = json['hourlyRate'];
    youtubeUrl = json['youtubeUrl'] != null ? json['youtubeUrl'].cast<String>() : [];
    teacherSubjectImage = json['teacherSubjectImage'];
    rating = json['rating'];
    totalReviews = json['total_reviews'];
    studentpackageCount = json['studentpackage_count'];
    imageUrl = json['image_url'];
    subject = json['subject'] != null ? Subject.fromJson(json['subject']) : null;
    if (json['studentpackage'] != null) {
      studentpackage = [];
      json['studentpackage'].forEach((v) {
        studentpackage?.add(v);
      });
    }
  }
  int? id;
  int? subjectId;
  int? userId;
  int? hourlyRate;
  List<String>? youtubeUrl;
  dynamic teacherSubjectImage;
  int? rating;
  int? totalReviews;
  int? studentpackageCount;
  String? imageUrl;
  Subject? subject;
  List<dynamic>? studentpackage;
}

class Subject {


  Subject.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'] != null ? Name.fromJson(json['name']) : null;
    subjectsImage = json['subjects_image'];
    slug = json['slug'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
    visibleCategoryCount = json['visible_category_count'];
  }
  int? id;
  Name? name;
  String? subjectsImage;
  String? slug;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;
  int? visibleCategoryCount;

}

class Name {
  Name.fromJson(dynamic json) {
    ar = json['ar'];
    en = json['en'];
    ro = json['ro'];
  }
  String? ar;
  String? en;
  String? ro;

}

class Report {
  Report.fromJson(dynamic e) {
    profileViewsCount = e['profile_views_count'];
    profileViews = e['profile_views'];
    rating = e['rating'];
    reviews = e['reviews'];
    completeProfile = e['complete_profile'];
    completeMassages = Map.from(e['complete_massages']);
  }
  int? profileViewsCount;
  String? profileViews;
  String? rating;
  int? reviews;
  int? completeProfile;
  Map<String , dynamic>? completeMassages;

}

class CompleteMassages {
  CompleteMassages.fromJson(dynamic json) {
    userLanguage = json['user_language'];
    teacherSubjectVideo = json['teacher_subject_video'];
    generalInfo = json['general_info'];
    emailVerified = json['email_verified'];
    identetyVerified = json['identety_verified'];
  }
  String? userLanguage;
  String? teacherSubjectVideo;
  String? generalInfo;
  String? emailVerified;
  String? identetyVerified;


}