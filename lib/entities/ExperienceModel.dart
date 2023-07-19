import 'package:flutter/material.dart';

import 'CommonModel.dart';

class ExperienceModel {
  int? id;
  int? userId;
  TextEditingController company = TextEditingController();
  TextEditingController position = TextEditingController();
  String? startAt;
  String? endAt;
  bool openMenu = false;
  CommonModel? selectedSubject;

  ExperienceModel();

  ExperienceModel.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    position.text = json['position'];
    company.text = json['company'];
    endAt = json['end_at'];
    startAt = json['start_at'];
  }
}
