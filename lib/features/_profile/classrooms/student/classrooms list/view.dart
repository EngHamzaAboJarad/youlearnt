import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/core/helper_methods.dart';
import 'package:you_learnt/features/_profile/classrooms/logic.dart';
import 'package:you_learnt/features/_profile/classrooms/student/classrooms%20list/reschduled_books_view.dart';
import 'package:you_learnt/features/_profile/classrooms/student/classrooms%20list/suggets_books_view.dart';

import '../../../../../constants/colors.dart';
import '../../../../../utils/custom_widget/custom_text.dart';
import 'avalible_classrooms.dart';
import 'cancelled_books.dart';

class StudentClassrooms extends StatefulWidget {
  const StudentClassrooms({Key? key}) : super(key: key);

  @override
  State<StudentClassrooms> createState() => _StudentClassroomsState();
}

class _StudentClassroomsState extends State<StudentClassrooms> {
  final HelperMethods _helperMethods = HelperMethods();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // executes after build

    // });
    Get.find<ClassroomsLogic>().getStudentClassrooms(true);
    Get.find<ClassroomsLogic>().getStudentReschduledBooks(true);
    Get.find<ClassroomsLogic>().getStudentSuggetsBooks(true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<ClassroomsLogic>().closeAllOpentoggeldMenues();
      },
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: secondaryColor,
            title: CustomText(
              'Classrooms'.tr,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            bottom: TabBar(
              isScrollable: true,
              labelStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  text: "Available Classes".tr,
                ),
                Tab(
                  text: "Rescheduled Books".tr,
                ),
                Tab(
                  text: "Suggested Books".tr,
                ),
                Tab(
                  text: "Canceled Books".tr,
                ),
              ],
            ),
            // title: const Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              const AvalibelStudentClassroom(),
              ReschduldedStudentsBooksPage(),
              SuggetStudentBooksPage(),
              const StudentCancelledBooksPage(),
            ],
          ),
        ),
      ),
    );
  }
}
