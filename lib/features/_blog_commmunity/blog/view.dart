import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:you_learnt/entities/CommonModel.dart';
import 'package:you_learnt/features/_blog_commmunity/profile_blog/logic.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../utils/custom_widget/custom_image.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../_main/widgets/header_widget.dart';
import '../blog_details/view.dart';
import '../widgets/item_blog.dart';

class BlogPage extends StatelessWidget {
  final String? name;

  const BlogPage({this.name, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<ProfileBlogLogic>().getWebsiteBlogs(search: name);
    return Container(
      color: secondaryColor,
      child: GetBuilder<ProfileBlogLogic>(
          init: Get.find<ProfileBlogLogic>(),
          builder: (logic) {
            return Column(
              children: [
                HeaderWidget(
                    titleBig: 'Blog'.tr, hintSearchText: 'Search Blogs', titleSmall: ''.tr),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                    child: logic.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: () async {
                              await Get.find<ProfileBlogLogic>().getWebsiteBlogs();
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /* Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomText(
                          'Featured Articles'.tr,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 330.h,
                      child: ListView.builder(
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Container(
                                  width: 280.w,
                                  margin:
                                      const EdgeInsetsDirectional.only(start: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(width: 0.5 , color: Colors.grey),),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Column(
                                    children: [

                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          imageSlider,
                                          fit: BoxFit.fill,
                                          height: 150.h,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: CustomText(
                                          'Lorem ipsum dolor sit amet, dolor sit amet, consetetur sadipscing elitr, sed',
                                          maxLines: 3,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            imagePerson,
                                            width: 30.sp,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: CustomText(
                                            'Sara Ali',
                                            fontWeight: FontWeight.bold,
                                          )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Icon(Icons.circle , color: yalowColor, size: 10,),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          CustomText('4 min read')
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                )),
                    ),*/
                                  if (logic.tagsWebsiteList.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: CustomText(
                                        'Trending Topics'.tr,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  if (logic.tagsWebsiteList.isNotEmpty)
                                    SizedBox(
                                    height: 150.h,
                                    child: ListView.builder(
                                        itemCount: logic.tagsWebsiteList.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) => GestureDetector(
                                              onTap: () {
                                                logic.changeSelectedTag(
                                                    logic.tagsWebsiteList[index]);
                                              },
                                              child: Container(
                                                margin: const EdgeInsetsDirectional.only(start: 10),
                                                width: 110.w,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Image.asset(
                                                      imageTopic,
                                                      height: 100.h,
                                                    ),
                                                    CustomText(
                                                      '#${logic.tagsWebsiteList[index].name}'
                                                          .replaceAll('##', '#'),
                                                      fontSize: 16,
                                                      maxLines: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                  ),
                                  if (logic.blogsWebsiteList.isNotEmpty)
                                    Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CustomText(
                                      'Trending Articles'.tr,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: logic.blogsWebsiteList.length,
                                      itemBuilder: (context, index) =>
                                          ItemBlog(logic.blogsWebsiteList[index])),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
