import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../entities/CommonModel.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../_main/widgets/header_widget.dart';
import '../profile_community/logic.dart';
import '../widgets/item_blog.dart';
import '../widgets/item_community.dart';
import 'logic.dart';

class TagsPage extends StatelessWidget {
  final List<CommonModel> selectedTagList;
  final String? tagName;
  final bool isBlog;
  ProfileCommunityLogic? logic;

  TagsPage(
      {Key? key,
      required this.selectedTagList,
      required this.tagName,
      this.logic,
      required this.isBlog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        centerTitle: false,
        title: CustomText(
          tagName ?? '',
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25))),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: selectedTagList.length,
                        itemBuilder: (context, index) => !isBlog
                            ? ItemCommunity(
                                logic: logic!, item: selectedTagList[index])
                            : ItemBlog(selectedTagList[index])),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
