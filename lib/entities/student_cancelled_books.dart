class StudentCancelledBooks {
  final int id;
  final String type;
  final String startAt, endAt;
  final String teacherFullName;
  final String teacherImage;

  StudentCancelledBooks(
      {required this.id,
      required this.type,
      required this.startAt,
      required this.endAt,
      required this.teacherFullName,
      required this.teacherImage});

  factory StudentCancelledBooks.fromJson(Map<String, dynamic> map) {
    return StudentCancelledBooks(
      id: map['id'],
      type: map['type'],
      startAt: map['book']["user_zone"]["start_at"],
      endAt: map['book']["user_zone"]["end_at"],
      teacherFullName:
          map['book']["user"] == null ?"" : map['book']["user"]["full_name"],
      teacherImage:
          map['book']["user"] == null ? "" : map['book']["user"]["image_url"],
    );
  }
}
