class LanguageModel {
  final int id;
  final String name;
  final String code;

  LanguageModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> map) {
    return LanguageModel(
      id: map["id"],
      name: map["language_name"],
      code: map["code"],
    );
  }
}
