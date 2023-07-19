import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:you_learnt/entities/SubjectModel.dart';
import 'package:you_learnt/entities/UserModel.dart';
import 'package:you_learnt/utils/functions.dart';

class BookModel {
  BookModel.fromJson(dynamic json) {
    // log(json.toString());
    id = json['id'];
    eventName = json['event_name'];
    cancelled =
        json['show_buttons'] != null ? json['show_buttons']["cancelled"] : false;
    rescheduled = json['show_buttons'] != null
        ? json['show_buttons']["rescheduled"]
        : false;
    unableToAttend = json['show_buttons'] != null
        ? json['show_buttons']["unable_to_attend"]
        : false;
    title = json['title'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    type = json['type'];
    teacherSubjectId = json["class_id"] != null
        ? json["class_id"].runtimeType == int
            ? null
            : json["class_id"]["teacher_subject"]["subject_id"]
        : null;
    // log(type)
    if (json['students'] != null) {
      students = [];
      json['students'].forEach((v) {
        students?.add(UserModel.fromJson(v));
      });
    }
    if (students != null) {
      classId = json['class'] != null ? ClassId.fromJson(json['class']) : null;
    } else {
      classId =
          json['class_id'] != null ? ClassId.fromJson(json['class_id']) : null;
    }
    start = json['start'] ?? json['start_at'];
    end = json['end'] ?? json['end_at'];
    try {
      startFormated = DateFormat().add_Hm().format(DateTime.parse(start!));
      endFormated = DateFormat().add_Hm().format(DateTime.parse(end!));
    } catch (e) {
      log(e.toString());
    }
  }

  int? id;
  String? eventName;
  String? title;
  UserModel? user;
  ClassId? classId;
  String? start;
  String? end;
  String? startFormated;
  String? endFormated;
  String? type;
  List<UserModel>? students;
  int? teacherSubjectId;

  bool? cancelled;
  bool? rescheduled;
  bool? unableToAttend;
}

class ClassId {
  ClassId.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    link = json['link'];
    discount = checkDouble(json['discount']);
    price = checkDouble(json['price']);
    userId = json['user_id'];
    teacherSubjectId = json['teacher_subject_id'];
    teacherSubject = json['teacher_subject'] != null
        ? SubjectModel.fromJson(json['teacher_subject'])
        : null;
    status = json['status'];
    type = json['type'];
    hour = checkDouble(json['hour']);
    rating = checkDouble(json['rating']);
    totalReviews = json['total_reviews'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['order_package_class'] != null) {
      orderPackageClass = [];
      json['order_package_class'].forEach((v) {
        orderPackageClass?.add(v);
      });
    }
  }

  int? id;
  String? title;
  String? description;
  String? link;
  double? discount;
  double? price;
  int? userId;
  int? teacherSubjectId;
  String? status;
  String? type;
  double? hour;
  double? rating;
  int? totalReviews;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? orderPackageClass;
  SubjectModel? teacherSubject;
}
