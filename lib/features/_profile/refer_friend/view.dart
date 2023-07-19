import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants/colors.dart';
import '../../../constants/images.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../logic.dart';

class ReferFriendPage extends StatelessWidget {
  ReferFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<ProfileLogic>().getRefLink();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
      body: Container(
        color: secondaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'Profile'.tr,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  CustomText(
                    'Refer a friend'.tr,
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25), topLeft: Radius.circular(25))),
                child: GetBuilder<ProfileLogic>(
                    init: Get.find<ProfileLogic>(),
                    id: 'refLink',
                    builder: (logic) {
                      return logic.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomText(
                                    'Share your link'.tr,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  /*
                                  CustomText(
                                    ''.tr,
                                    color: Colors.grey.shade400,
                                    fontSize: 12,
                                  ),*/
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey.shade400, width: 1)),
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: CustomText(
                                          logic.referModel?.referLink,
                                          fontSize: 16,
                                          color: secondaryColor,
                                        )),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        IconButton(
                                            onPressed: () => Clipboard.setData(ClipboardData(
                                                    text: "logic.referModel?.referLink"))
                                                .then((_) =>
                                                    Fluttertoast.showToast(msg: 'Copied'.tr)),
                                            icon: const Icon(
                                              Icons.copy,
                                              color: Colors.grey,
                                            ))
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Share.share(logic.referModel?.referLink ?? '');
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: secondaryColor, width: 1)),
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            iconShare,
                                            scale: 2,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          CustomText(
                                            'Share'.tr,
                                            color: secondaryColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        'You have earned'.tr,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const CustomText(
                                        '\$0 USD',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: secondaryColor,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  if (logic.referModel?.users?.data?.isNotEmpty == true)
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey.shade400, width: 1)),
                                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                                        child: ListView.builder(
                                            itemCount: logic.referModel?.users?.data?.length ?? 0,
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              var item = logic.referModel?.users?.data?[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 15),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          CustomText(
                                                            item?.email,
                                                            fontSize: 12,
                                                          ),
                                                          CustomText(
                                                            item?.date,
                                                            fontSize: 10,
                                                            color: Colors.grey,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    CustomText(
                                                      item?.status,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.bold,
                                                    )
                                                  ],
                                                ),
                                              );
                                            })),
                                ],
                              ),
                            );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
