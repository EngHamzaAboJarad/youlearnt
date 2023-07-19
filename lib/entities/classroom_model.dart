import 'package:you_learnt/entities/UserModel.dart';
import 'package:you_learnt/entities/classroom_book_model.dart';

class ClassRoomModel {
  final int id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? subjectName;
  final bool isStudent;

  int? maxStudent;
  int? teacherSubjectId;
  bool isSelected = false;
  double? price;
  List<ClassroomBookModel> booksList;
  UserModel? userModel;
  final String? type;
  final int? studentCount;
  ClassRoomModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.maxStudent,
    this.teacherSubjectId,
    this.price,
    this.userModel,
    this.subjectName,
    this.isStudent = false,
    this.type,
    this.studentCount,
    this.booksList = const [],
  });

  factory ClassRoomModel.fromJson(Map<String, dynamic> map) {
    final List<ClassroomBookModel> tempbooks = [];
    if (map["books"] != null) {
      List? loadedBooks = map["books"] as List;
      for (var extraMap in loadedBooks) {
        tempbooks.add(ClassroomBookModel.fromJson(extraMap));
      }
    }
    return ClassRoomModel(
      id: map["id"],
      title: map["title"],
      type: map["type"],
      studentCount: map["students_count"] ?? 0,
      isStudent: map["is_student"] ?? false,
      description: map["description"] ?? "",
      imageUrl: map["teacher_subject"]["image_url"] ?? "",
      maxStudent: map["max_student"],
      teacherSubjectId: map["teacher_subject_id"],
      booksList: tempbooks,
      subjectName: map["teacher_subject"]["subject"] == null
          ? ""
          : map["teacher_subject"]["subject"]["lang_name"],
      userModel: map["user"] == null ? null : UserModel.fromJson(map["user"]),
      price: double.parse(map["price"].toString()),
    );
  }
}
