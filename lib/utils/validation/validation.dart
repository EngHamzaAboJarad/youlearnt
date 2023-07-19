import 'package:get/get.dart';

class Validation {
  static String? fieldValidate(val) {
    return val!.isEmpty ? 'This Field is required'.tr : null;
  }

  static String? nameValidate(val) {
    return val!.isEmpty ? 'Name is required'.tr : null;
  }

  static String? firstnameValidate(val) {
    return val!.isEmpty ? 'First name is required'.tr : null;
  }

  static String? lastnameValidate(val) {
    return val!.isEmpty ? 'Last name is required'.tr : null;
  }

  static String? phoneValidate(val) {
    return val!.isEmpty ? 'Phone is required'.tr : null;
  }

  static String? emailValidate(val) {
    return val!.isEmpty
        ? 'Email is required'.tr
        : !GetUtils.isEmail(val)
            ? "Email invalid".tr
            : null;
  }

  static String? passwordValidate(val) {
    return val!.isEmpty ? 'Password is required'.tr : null;
  }

  static String? noValdation(val) {
    return null;
  }
}
