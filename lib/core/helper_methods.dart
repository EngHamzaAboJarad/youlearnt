import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:you_learnt/constants/colors.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';

import '../utils/custom_widget/custom_button_widget.dart';

class HelperMethods {
  static final HelperMethods _helperMethods = HelperMethods._internal();
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  factory HelperMethods() {
    return _helperMethods;
  }

  HelperMethods._internal();

  Widget progressIndcator() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(mainColor),
      ),
    );
  }

  convertSuggestBookDate(String? date) {
    if (date == null) return "";
    // "2023-03-18T07:19:23.64"
    DateTime tempDate = DateFormat("yyyy-MM-ddThh:mm:ss", 'en_US').parse(date);
    return DateFormat("yyyy-MM-dd hh:mm").format(tempDate);
  }

  showAlertDilog(
      {required String message,
      required String title,
      required BuildContext context,
      required Function function}) {
    showDialog(
        context: context,
        builder: (ctx) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AlertDialog(
                scrollable: true,
                contentPadding: const EdgeInsets.all(12),
                insetPadding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Center(
                  child: CustomText(
                    title,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        child: CustomText(
                          message,
                          fontSize: 16,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: CustomButtonWidget(
                          title: "Ok".tr,
                          loading: false,
                          onTap: () {
                            function();
                            Get.back();
                          },
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: CustomButtonWidget(
                          title: "Close".tr,
                          loading: false,
                          onTap: () {
                            Get.back();
                          },
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  Color handleStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "cancelled":
        return Colors.red;
      case "approved":
        return Colors.green;
      case "unable_to_attend":
        return Colors.orange;
      default:
        return Colors.black;
    }
  }
}
