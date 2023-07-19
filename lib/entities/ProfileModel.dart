class ProfileModel {
  int? userId;
  String? level;
  int? studentCount;
  int? canceledLessons;
  int? absencesStudents;
  String? bio;
  String? customLink;
  String? publicLink;
  dynamic introduceYourSelf;
  dynamic introduceYourSelfOtherLanguage;
  String? rating;
  int? reviews;
  String? timezone;
  String? birthday;
  dynamic gender;
  int? countryId;
  int? countryOriginId;
  int? cityId;
  String? experienceYears;
  String? cityName;
  String? createdAt;
  String? updatedAt;
  String? countryFlag;
  String? introduceVideoLink;

  ProfileModel.fromJson(dynamic json) {
    userId = json['user_id'];
    level = json['level'];
    experienceYears = json['experience_years'] != null
        ? json['experience_years'].toString()
        : null;
    studentCount = json['student_count'];
    canceledLessons = json['canceled_lessons'];
    absencesStudents = json['absences_students'];
    bio = json['bio'];
    customLink = json['customLink'];
    publicLink = json['publicLink'];
    introduceVideoLink = json['introduce_video_link'];
    introduceYourSelf = json['introduceYourSelf'];
    introduceYourSelfOtherLanguage = json['introduceYourSelfOtherLanguage'];
    rating = json['rating'];
    reviews = json['reviews'];
    timezone = json['timezone'];
    birthday = json['birthday'];
    gender = json['gender'];
    countryId = json['country_id'];
    countryOriginId = json['origin_country_id'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    try {
      countryFlag = json['country'] == null ? null : json['country']['flag'];
    } catch (e) {
      countryFlag = null;
    }
  }
}
