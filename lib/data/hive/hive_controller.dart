import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:you_learnt/data/hive/hive_constant.dart';

class HiveController extends GetxController {
  static var generalBox = Hive.box(HiveConstant.generalBox);

  //isStudent
  static bool getIsStudent() {
    return generalBox.get(HiveConstant.isStudent, defaultValue: true);
  }
  static setIsStudent(bool isStudent) {
    generalBox.put(HiveConstant.isStudent, isStudent);
  }

  //isArabic
  static bool getIsArabicLanguage() {
    return generalBox.get(HiveConstant.isArabic, defaultValue: false);
  }
  static setIsArabic(bool isArabic) {
    generalBox.put(HiveConstant.isArabic, isArabic);
  }

  //token
  static String? getToken() {
    return generalBox.get(HiveConstant.token, defaultValue: null);
  }
  static setToken(String? token) {
    generalBox.put(HiveConstant.token, token);
  }

  //language
  static String? getLanguageCode() {
    return generalBox.get(HiveConstant.language, defaultValue: null);
  }
  static setLanguageCode(String? language) {
    generalBox.put(HiveConstant.language, language);
  }

  //slug
  static String? getUserId() {
    return generalBox.get(HiveConstant.id, defaultValue: null);
  }

  static setUserId(String? slug) {
    generalBox.put(HiveConstant.id, slug);
  }

  //name
  static String? getUserName() {
    return generalBox.get(HiveConstant.name, defaultValue: null);
  }

  static setUserName(String? name) {
    generalBox.put(HiveConstant.name, name);
  }
}
