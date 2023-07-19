import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/_main/find_tutor/logic.dart';
import 'package:you_learnt/features/_main/widgets/header_widget.dart';

import '../../../constants/colors.dart';
import '../../../sub_features/item_tutor.dart';
import '../../../utils/custom_widget/custom_text.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<FindTutorLogic>().getFavoriteItems();
    return Container(
      color: secondaryColor,
      child: Column(
        children: [
          HeaderWidget(titleBig: 'My Favorites'.tr, titleSmall: ''.tr),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25), topLeft: Radius.circular(25))),
              child: GetBuilder<FindTutorLogic>(
                  init: Get.find<FindTutorLogic>(),
                  builder: (logic) {
                    return logic.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            strokeWidth: 1,
                          ))
                        : logic.favoriteList.isEmpty ? Center(child: CustomText('You haven\'t any tutor at your favourite'.tr)) :ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) => Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                        height: 265.h,
                                        child: ListView.builder(
                                            itemCount: logic.favoriteList.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) => ItemTutor(
                                                  tutor: logic.favoriteList[index],
                                                  isForFav: true,
                                                ))),
                                  ],
                                ));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
