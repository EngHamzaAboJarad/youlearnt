import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_learnt/features/_blog_commmunity/profile_blog/logic.dart';

import '../../../constants/colors.dart';
import '../../../entities/CommonModel.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../blog_details/view.dart';

class ItemBlog extends StatelessWidget {
  final CommonModel item;
  final bool isHorizontal;

  const ItemBlog(this.item, {
    this.isHorizontal = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(BlogDetailsPage(item)),
      child: Container(
        width: isHorizontal ? Get.width - 50 : null,
        margin: isHorizontal
            ? const EdgeInsetsDirectional.only(end: 10)
            : const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 0.5, color: Colors.grey),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CustomImage(
                    url: item.imageUrl,
                    height: 120,
                    fit: BoxFit.cover,
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    item.title,
                    fontSize: 18,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CustomImage(
                            url: item.user?.imageUrl,
                            width: 30,
                            height: 30,
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomText(
                        item.user?.fullName,
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GetBuilder<ProfileBlogLogic>(
                      init: Get.find<ProfileBlogLogic>(),
                      builder: (logic) {
                    return Wrap(
                      children: item.tags
                          ?.map((e) =>
                          GestureDetector(
                            onTap: () =>
                                logic.changeSelectedTag(e),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  end: 10),
                              child: CustomText(
                                '#${e.name}'.replaceAll('##', '#'),
                                color: primaryColor,
                              ),
                            ),
                          ))
                          .toList() ??
                          [],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
