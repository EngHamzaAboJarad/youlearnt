import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:you_learnt/constants/colors.dart';
import 'package:you_learnt/features/_main/logic.dart';
import 'package:you_learnt/features/_main/widgets/header_widget.dart';
import 'package:you_learnt/utils/custom_widget/custom_text.dart';

import '../../data/hive/hive_controller.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../_auth/auth/view.dart';
import 'build_chat_widget.dart';
import 'fb_services.dart';

class ChatNavScreen extends StatefulWidget {
  const ChatNavScreen({Key? key}) : super(key: key);

  @override
  State<ChatNavScreen> createState() => _ChatNavScreenState();
}

class _ChatNavScreenState extends State<ChatNavScreen> {
  @override
  Widget build(BuildContext context) {

    return Container(
      color: secondaryColor,
      child: Column(
        children: [
          HeaderWidget(titleBig: 'Messages'.tr, titleSmall: ''.tr),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25), topLeft: Radius.circular(25))),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ValueListenableBuilder(
                valueListenable: HiveController.generalBox.listenable(),
                  builder: (context, box, _){
                  return HiveController.getToken() == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              'You should login or create new account to see your chats'.tr,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: CustomButtonWidget(
                                  title: 'Log In'.tr,
                                  textSize: 16,
                                  onTap: () => Get.to(AuthPage())?.then((value) => setState(() {}))),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            StreamBuilder<QuerySnapshot>(
                                stream: FBServices().getChats(),
                                builder: (context, snapshot) {
                                  try {
                                    if (!snapshot.hasData) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else {
                                      List<QueryDocumentSnapshot> listChat =
                                          snapshot.data?.docs ?? [];
                                      return listChat.isEmpty
                                          ? Center(
                                              child: CustomText(
                                                  "You don't receive and messages yet".tr))
                                          : Builder(builder: (context) {
                                              List<String?> list = [];
                                              for (var element in listChat) {
                                                list.add(element['advertise_id']);
                                              }
                                              Get.find<MainLogic>().getUsersBySlugs(list);
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 0, vertical: 10),
                                                child: GetBuilder<MainLogic>(
                                                    init: Get.find<MainLogic>(),
                                                    builder: (logic) {
                                                      return ListView.builder(
                                                        itemCount: logic.usersList.length,
                                                        shrinkWrap: true,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        itemBuilder: (context, index) {
                                                          return BuildChatWidget(
                                                              logic.usersList[index]);
                                                        },
                                                      );
                                                    }),
                                              );
                                            });
                                    }
                                  } catch (e) {
                                    print(e);
                                    return Container();
                                  }
                                }),
                          ],
                        ),
                      );},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
