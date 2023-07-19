class ClassroomBookModel {
  final int? id;
  final String? type;
  final String? startAt;
  final String? endAt;
  final bool? cancelled;
  final bool? rescheduled;

  ClassroomBookModel({
    this.id,
    this.type,
    this.startAt,
    this.endAt,
    this.rescheduled,
    this.cancelled,
  });

  factory ClassroomBookModel.fromJson(Map<String, dynamic> map) {
    return ClassroomBookModel(
        id: map['id'],
        type: map["type"],
        cancelled: map["show_buttons"] != null
            ? map["show_buttons"]["cancelled"]
            : null,
        rescheduled: map["show_buttons"] != null
            ? map["show_buttons"]["rescheduled"]
            : null,
        startAt: map["user_zone"]["start_at"],
        endAt: map["user_zone"]["end_at"]);
  }
}
