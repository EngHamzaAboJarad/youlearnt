
import 'UserModel.dart';
import 'classroom_book_model.dart';

class ReschduldedBookModel {
  final int id;
  final String startAt;
  final String endAt;
  final String status;
  ClassroomBookModel? classroomBookModel;
  UserModel? userModel;
  

  ReschduldedBookModel(
      {required this.id,
      required this.startAt,
      required this.endAt,
      required this.status,
      this.classroomBookModel,
      this.userModel});

  factory ReschduldedBookModel.fromJson(Map<String, dynamic> map) {
    return ReschduldedBookModel(
        id: map["id"],
        startAt: map["time_form"],
        endAt: map["time_to"],
        status: map["status"],
        classroomBookModel:  map["cancelled_book"] ==null ? null: ClassroomBookModel.fromJson(map["cancelled_book"]["book"]),
        userModel: map["cancelled_book"] ==null ? null:  UserModel.fromJson(map["cancelled_book"]["teacher"]));
  }
}
