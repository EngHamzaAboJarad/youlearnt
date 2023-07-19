import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:you_learnt/entities/TutorModel.dart';
import 'package:you_learnt/entities/UserModel.dart';

import '../../utils/custom_widget/custom_image.dart';
import '../../utils/custom_widget/custom_text.dart';
import 'chat_screen.dart';
import 'fb_services.dart';
import 'package:timeago/timeago.dart' as timeago;

class BuildChatWidget extends StatelessWidget {
  final UserModel? tutorModel;

  const BuildChatWidget(this.tutorModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: GestureDetector(
        onTap: () {
          Get.to(ChatScreen(
              peerId: (tutorModel?.id ?? 0).toString(),
              title: tutorModel?.fullName ?? '',
              peerImage: tutorModel?.imageUrl ?? ''));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade400, width: 1)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.w),
                  child: CustomImage(
                    url: tutorModel?.imageUrl ?? '',
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tutorModel?.fullName ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                          stream: FBServices().getLastMessage((tutorModel?.id ?? 0).toString()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              try {
                                var documentFields = snapshot.data!;
                                Map<String, dynamic> data =
                                    documentFields.data() as Map<String, dynamic>;
                                if (data.containsKey('last_message_content')) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width - 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          data['last_message_content'].length > 15
                                              ? '${data['last_message_content'].substring(0, 15)}...'
                                              : data['last_message_content'],
                                          fontSize: 12,
                                          fontWeight: (data['seen'] == false &&
                                                  data['sender'] == 'client')
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          timeago.format(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  int.parse(data['last_message_date']))),
                                          style: const TextStyle(
                                              color: Color(0xff8E8E93),
                                              fontSize: 10,
                                              fontFamily: 'Poppins'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              } catch (e) {
                                log('last message => $e');
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
