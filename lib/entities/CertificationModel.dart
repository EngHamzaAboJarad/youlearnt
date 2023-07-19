import 'package:flutter/material.dart';

import 'CommonModel.dart';

class CertificationModel {
  int? id;
  int? userId;
  TextEditingController issuedBy = TextEditingController();
  String? issuedDate;
  String? certificationImage;
  String? status;
  String? imageUrl;
  String? subjectName;
  bool openMenu = false;
  CommonModel? selectedSubject;

  CertificationModel({this.id, this.certificationImage});
  CertificationModel.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    subjectName = json['subject_name'];
    issuedBy = TextEditingController(text: json['issued_by']);
    issuedDate = json['issued_date'];
    certificationImage = json['certification_image'].toString();
    status = json['status'].toString();
    imageUrl = json['image_url'];
  }
}
