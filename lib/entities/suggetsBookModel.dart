import 'UserModel.dart';
import 'classroom_book_model.dart';

class SuggetsBookModel {
  final int id;
  final String startAt;
  final String endAt;
  final String status;
  ClassroomBookModel? classroomBookModel;
  UserModel? userModel;

  SuggetsBookModel(
      {required this.id,
      required this.startAt,
      required this.endAt,
      required this.status,
      this.classroomBookModel,
      this.userModel});

  factory SuggetsBookModel.fromJson(Map<String, dynamic> map, String type) {
    return SuggetsBookModel(
        id: map["id"],
        startAt: map["from"],
        endAt: map["to"],
        status: map["status"],
        // classroomBookModel: map["cancelled_book"] == null
        //     ? null
        //     : ClassroomBookModel.fromJson(map["cancelled_book"]["book"]),
        userModel: map[type] == null ? null : UserModel.fromJson(map[type]));
  }
}
