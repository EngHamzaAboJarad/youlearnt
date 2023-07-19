import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/colors.dart';
import '../../../entities/CommonModel.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';
import '../profile_community/logic.dart';

class ItemCommunity extends StatelessWidget {
  final ProfileCommunityLogic logic;
  final CommonModel item;

  const ItemCommunity({
    required this.logic,
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => logic.goToDetails(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.tags?.isNotEmpty == true)
              SizedBox(
                height: 25.h,
                child: ListView.builder(
                    itemCount: item.tags?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () =>
                              logic.changeSelectedTag(item.tags?[index]),
                          child: Container(
                            margin: const EdgeInsetsDirectional.only(end: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: secondaryColor.withOpacity(0.1)),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: CustomText(
                              item.tags?[index].name,
                              color: secondaryColor,
                              fontSize: 12,
                            ),
                          ),
                        )),
              ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              item.title,
              color: secondaryColor,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomText(
              parseHtmlString(item.description),
              color: greyTextColor,
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 35.sp,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.sp),
                    child: CustomImage(
                      url: item.user?.imageUrl,
                      height: 35.sp,
                      width: 35.sp,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        item.user?.fullName,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      CustomText(
                        item.date,
                        fontSize: 10,
                        color: greyTextColor,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
