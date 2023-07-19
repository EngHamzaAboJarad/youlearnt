import 'package:intl/intl.dart';

class ReviewModel {

  ReviewModel.fromJson(dynamic json) {
    id = json['id'];
    reviewableType = json['reviewable_type'];
    reviewableId = json['reviewable_id'];
    userId = json['user_id'];
    rating = json['rating'];
    review = json['review'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fullName = json['full_name'];
    slug = json['slug'];
    imageUrl = json['image_url'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    subjectSlug = json['subject_slug'];
    try{
      dateFormat = DateFormat().format(DateTime.parse(updatedAt ?? ''));
    }catch(e){}
  }
  int? id;
  int? reviewableType;
  int? reviewableId;
  int? userId;
  int? subjectId;
  String? rating;
  String? review;
  String? createdAt;
  String? updatedAt;
  String? dateFormat;
  String? fullName;
  String? slug;
  String? imageUrl;
  String? subjectName;
  String? subjectSlug;



}