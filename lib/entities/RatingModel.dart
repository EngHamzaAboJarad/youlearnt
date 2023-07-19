import 'package:you_learnt/entities/ReviewModel.dart';

class RatingModel {
  String? rating;
  dynamic review;
  AllRating? allRating;
  List<ReviewModel>? reviews;

  RatingModel.fromJson(dynamic json) {
    rating = json['rating'];
    review = json['review'];
    allRating = json['all_rating'] != null ? AllRating.fromJson(json['all_rating']) : null;
    try {
      if (json['last_record']['reviews'] != null) {
        reviews = [];
        json['last_record']['reviews'].forEach((v) {
          reviews?.add(ReviewModel.fromJson(v));
        });
      }
    } catch (e) {}
  }
}

class AllRating {
  int? onestar;
  int? twostar;
  int? threestar;
  int? fourstar;
  int? fivestar;
  int? allStar;

  AllRating.fromJson(dynamic json) {
    onestar = json['onestar'];
    twostar = json['twostar'];
    threestar = json['threestar'];
    fourstar = json['fourstar'];
    fivestar = json['fivestar'];
    allStar =
        (onestar ?? 0) + (twostar ?? 0) + (threestar ?? 0) + (fourstar ?? 0) + (fivestar ?? 0);
    allStar = allStar == 0 ? 1 : allStar;
  }
}
