import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/core/helper_methods.dart';
import 'package:you_learnt/features/_profile/classrooms/logic.dart';
import 'package:you_learnt/features/_profile/classrooms/teacher/classrooms%20list/suggets_books_view.dart';
import 'package:you_learnt/features/_profile/classrooms/teacher/classrooms%20list/teacher_avalible_classrooms_view.dart';

import '../../../../../constants/colors.dart';
import '../../../../../utils/custom_widget/custom_text.dart';
import '../../../../_main/logic.dart';

class TeacherClassrooms extends StatefulWidget {
  const TeacherClassrooms({Key? key}) : super(key: key);

  @override
  State<TeacherClassrooms> createState() => _TeacherClassroomsState();
}

class _TeacherClassroomsState extends State<TeacherClassrooms> {
  final HelperMethods _helperMethods = HelperMethods();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // executes after build

    // });
    Get.find<ClassroomsLogic>().getTeacherClassrooms();
    Get.find<ClassroomsLogic>().getTeacherSuggetsBooks(true);
  }

  MainLogic mainLogic = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.find<ClassroomsLogic>()
        .getProfileBySlug(mainLogic.userModel!.slug!, withoutLoading: true);
    return GestureDetector(
      onTap: () {
        Get.find<ClassroomsLogic>().closeAllOpentoggeldMenues();
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: secondaryColor,
              title: CustomText(
                'Classrooms'.tr,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              bottom: TabBar(
                // isScrollable: true,
                labelStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    text: "Available Classes".tr,
                  ),
                  Tab(
                    text: "Suggested Books".tr,
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                TeacherAvalibaleClassrooms(),
                SuggetsTeacherBooksPage()
              ],
            )),
      ),
    );
  }
}
