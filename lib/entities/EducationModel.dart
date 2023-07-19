import 'package:flutter/material.dart';

import 'CommonModel.dart';

class EducationModel {
  int? id;
  int? userId;
  String? imageUrl;
  TextEditingController degree = TextEditingController();
  TextEditingController degreeType = TextEditingController();
  TextEditingController university = TextEditingController();
  TextEditingController specialization = TextEditingController();
  String? startAt;
  String? endAt;
  String? status;
  String? educationImage;
  bool openMenu = false;
  CommonModel? selectedSubject;

  EducationModel();

  EducationModel.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    imageUrl = json['image_url'];
    degreeType.text = json['degree_type'];
    status = json['status'];
    endAt = json['end_at'];
    startAt = json['start_at'];
    specialization.text = json['specialization'];
    degree.text = json['degree']??"";
    university.text = json['university'];
  }
}
