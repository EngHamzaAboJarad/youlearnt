

class PostModel {
  PostModel({
    this.userId,
    this.startPrice,
    this.endPrice,
    this.title,
    this.type,
    this.description,
    this.status,
    this.subjectId,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.subjectsImage,
    this.slug,
    this.createdAt,
  });

  PostModel.fromJson(dynamic json, Map<String, dynamic> propaslsMap) {
    // log(propaslsMap["data"][0]["description"]);
    if (propaslsMap["data"] != null) {
      propaslsMap["data"].forEach((v) {
        // log(v.toString());
        propaslPostList.add(PropaslPostModel.fromJson(v));
      });
    }
    id = json['id'];
    userId = json['user_id'];
    startPrice = json['start_price'];
    endPrice = json['end_price'];
    title = json['title'];
    type = json['type'];
    description = json['description'];
    status = json['status'];
    subjectId = json['subject_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
    subjectsImage = json['subjects_image'];
    subjectsName = json['subjects_name'];
    languagesFlag = json['languages_flag'];
    countryFlag = json['country_flag'];
    slug = json['slug'];
    createdAt = json['created_at'];
  }
  int? id;
  int? userId;
  int? startPrice;
  int? endPrice;
  String? title;
  String? type;
  String? description;
  String? status;
  int? subjectId;
  String? firstName;
  String? lastName;
  dynamic profileImage;
  String? subjectsImage;
  String? subjectsName;
  String? slug;
  String? createdAt;
  String? countryFlag;
  String? languagesFlag;
  List<PropaslPostModel> propaslPostList = [];
}

class PropaslPostModel {
  final int id;
  final String description;
  final String teacherName;
  final String teacheImage;
  final String teacherSlug;
  final String price;
  // final int? subjectId ;

  PropaslPostModel(
      {required this.id,
      required this.description,
      required this.teacherName,
      required this.teacheImage,
      required this.teacherSlug,
      // required this.subjectId,
      required this.price});

  factory PropaslPostModel.fromJson(Map<String, dynamic> map) {
    return PropaslPostModel(
      id: map["id"],
      // subjectId: map["teacher_subject_id"],
      description: map["description"],
      teacherName: map["user"]["full_name"],
      teacheImage: map["user"]["image_url"],
      teacherSlug: map["user"]["slug"],
      price: map['price'].toString(),
    );
  }
}
