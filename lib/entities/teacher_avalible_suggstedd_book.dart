class TeacherAvalibleSuggstedBooks {
  final int id;
  final String? title;
  final String? subjectName;
  final String start;
  final String end;
  bool isSelected;

  TeacherAvalibleSuggstedBooks({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.subjectName,
    this.isSelected = false,
  });

  factory TeacherAvalibleSuggstedBooks.fromJson(Map<String, dynamic> map) {
    return TeacherAvalibleSuggstedBooks(
      id: map["id"],
      title: map["title"],
      // title: "",
      subjectName: map["teacherSubject"]!=null ?map["teacherSubject"]["subject"]["lang_name"] :null,
      start: map["start"],
      end: map['end'],
    );
  }
}
