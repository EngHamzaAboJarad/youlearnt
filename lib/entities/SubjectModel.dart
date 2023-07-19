import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:you_learnt/entities/CommonModel.dart';

class SubjectModel {
  SubjectModel({
    this.selectedSubject,
  });

  List<String?> images = [null];
  List<String> imagesUrl = [];
  CommonModel? selectedSubject;
  TextEditingController hourRateController = TextEditingController();
  TextEditingController certificationHourController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<TextEditingController> youtubeLinkControllerList = [
    TextEditingController()
  ];

  List<String> uploadedVideosPaths = [];
  List<VideoPlayerController> uploadedVideos = [
    // VideoPlayerController(),
  ];

  int? id;
  int? subjectId;
  int? userId;
  int? hourlyRate;
  String? teacherSubjectImage;
  int? rating;
  int? totalReviews;

  // String? imageUrl;
  String? subjectName;

  SubjectModel.fromJson(dynamic json) {
    id = json['id'];
    subjectId = json['subject_id'];
    userId = json['user_id'];
    hourlyRate = json['hourlyRate'];
    hourRateController.text = (json['hourlyRate'] ?? '').toString();
    certificationHourController.text =
        (json['certification_hour'] ?? '').toString();
    descriptionController.text = (json['description'] ?? '').toString();
    teacherSubjectImage = json['teacherSubjectImage'];
    rating = json['rating'];
    totalReviews = json['total_reviews'];
    //imageUrl = json['image_url'];
    if (json['youtube_videos'] != null) {
      if (json['youtube_videos'].runtimeType == List) {
        log(json['youtube_videos'].runtimeType.toString());
        json['youtube_videos'].forEach((v) {
          // youtubeLinkControllerList = [];
          // youtubeLinkControllerList.add(TextEditingController(text: v));
        });
      }
    } else {
      youtubeLinkControllerList = [TextEditingController()];
    }
    if (json['videos_url'] != null) {
      if (json['videos_url'].runtimeType == List) {
        // json['videos_url'].forEach((v) {
        //   // youtubeLinkControllerList = [];
        //   uploadedVideos.add(v);
        // });
      }
    }
    if (json['gallery'] != null) {
      images = [];
      json['gallery'].forEach((v) {
        images.add(v);
        imagesUrl.add(v);
      });
    } else {
      images = [null];
    }
    try {
      // subjectName = "";
      subjectName = json['subject_name'] ?? json['subject']['name']['en'];
    } catch (e) {}
  }
}
