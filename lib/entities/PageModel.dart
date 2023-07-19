
class PageModel {

  PageModel.fromJson(dynamic json) {
    title = json['title'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }
  String? title;
  Body? body;


}
class Body {

  Body.fromJson(dynamic json) {
    recommendationsVideos = json['recommendations_videos'];
    recommendationsPictures = json['recommendations_pictures'];
    typePage = json['type_page'];
  }
  String? recommendationsVideos;
  String? recommendationsPictures;
  String? typePage;


}