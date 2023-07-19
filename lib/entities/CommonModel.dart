import 'package:intl/intl.dart';
import 'package:you_learnt/entities/UserModel.dart';
import 'package:you_learnt/utils/functions.dart';

class CommonModel {
  int? id;
  int? userId;
  int? categoryId;
  int? subjectId;
  int? active;
  int? website;
  int? countLiked;
  int? languageId ;
  String? hour;
  double? rating;
  double? price;
  double? discount;
  String? name;
  String? categoryName;
  String? iso2;
  String? code;
  String? native;
  String? languageName;
  String? level;
  String? image;
  String? flag;
  String? createdAt;
  String? updatedAt;
  String? eventName;
  String? start;
  String? end;
  String? title;
  String? subTitle;
  String? description;
  String? imageUrl;
  String? referralLink;
  String? status;
  String? date;
  String? comment;
  String? emoji;
  String? question;
  String? answer;
  CommonModel? language;
  UserModel? user;
  List<CommonModel>? comments;
  List<CommonModel>? tags;
  List<CommonModel>? related;
  List<CommonModel> notifications = [];
  bool isSelected = false;

  CommonModel.fromJson(dynamic json) {
    countLiked = json['count_liked'];
    answer = json['answer'];
    question = json['question'];
    referralLink = json['referral_link'];
    id = json['id'];
    userId = json['user_id'];
    languageId = json['language_id'];
    categoryId = json['category_id'];
    subjectId = json['subject_id'];
    active = json['active'];
    categoryName = json['lang_name']; //category_name
    status = json['status'];
    eventName = json['event_name'];
    title = json['lang_title'];
    subTitle = json['lang_sub_title'];
    description = json['lang_description'];
    imageUrl = json['image_url'];
    start = json['start'];
    end = json['end'];
    level = json['level'];
    website = json['website'];
    name = json['name'] is Map ? json['lang_name'] : json['name'];
    iso2 = json['iso2'];
    code = json['code'];
    native = json['native'];
    image = json['image'];
    flag = json['flag'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    languageName = json['language_name'];
    comment = json['comment'];
    emoji = json['emoji'];
    hour = json['hour'].toString();
    price = checkDouble(json['price']);
    discount = checkDouble(json['discount']);
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    language = json['language'] != null
        ? CommonModel.fromJson(json['language'])
        : null;
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags?.add(CommonModel.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = [];
      json['comments'].forEach((v) {
        comments?.add(CommonModel.fromJson(v));
      });
    }
    if (json['related_blog'] != null) {
      related = [];
      json['related_blog'].forEach((v) {
        related?.add(CommonModel.fromJson(v));
      });
    }
    try {
      date = DateFormat()
          .add_yMMMd()
          .add_Hm()
          .format(DateTime.parse(createdAt ?? ''));
    } catch (e) {}
    try {
      rating = [
            'angry',
            'sad',
            'normal',
            'satisfy',
            'happy',
          ].indexOf(emoji!) +
          1;
    } catch (e) {
      rating = 3 ;
    }
  }

  @override
  String toString() {
    return 'CommonModel{id: $id, userId: $userId, categoryId: $categoryId, subjectId: $subjectId, active: $active, website: $website, hour: $hour, rating: $rating, price: $price, discount: $discount, name: $name, categoryName: $categoryName, iso2: $iso2, code: $code, native: $native, languageName: $languageName, image: $image, flag: $flag, createdAt: $createdAt, updatedAt: $updatedAt, eventName: $eventName, start: $start, end: $end, title: $title,subTitle: $subTitle  ,  description: $description, imageUrl: $imageUrl, referralLink: $referralLink, status: $status, date: $date, comment: $comment, emoji: $emoji, question: $question, answer: $answer, language: $language, user: $user, comments: $comments, tags: $tags, related: $related, notifications: $notifications, isSelected: $isSelected}';
  }
}
