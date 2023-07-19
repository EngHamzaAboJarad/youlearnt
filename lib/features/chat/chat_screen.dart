import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart' as intl;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:you_learnt/constants/colors.dart';
import 'package:you_learnt/utils/custom_widget/custom_button_widget.dart';
import 'package:you_learnt/utils/functions.dart';
import '../../data/hive/hive_controller.dart';
import '../../utils/custom_widget/custom_image.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../report/view.dart';
import 'chat_getx_controllers.dart';
import 'fb_services.dart';
import 'gallery_screen.dart';

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerImage;
  final String title;

  ChatScreen({required this.peerId, required this.title, required this.peerImage});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  List<QueryDocumentSnapshot> listMessage = List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;
  late String groupChatId;
  late String id;

  XFile? imageFile;
  late bool isLoading;
  late String getImageUrl;
  String tempImage = '';
  bool isShowSticker = false;
  bool textFieldEmpty = true;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  bool showEmojiPicker = false;
  bool isWriting = false;

  int selectedIndex = -1;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    log('peer =>${widget.peerId}');

    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);

    groupChatId = '';
    isLoading = false;
    getImageUrl = '';

    readLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: CustomText(widget.title,
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
        actions: [
          IconButton(
              onPressed: () => Get.to(ReportPage(
                    id: int.parse(widget.peerId),
                  )),
              icon: const Icon(
                Icons.report,
                color: primaryColor,
              ))
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),
                // Input content
                buildInput(),
              ],
            ),
            // Loading
            //buildLoading()
          ],
        ),
      ),
    );
  }

  _scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  readLocal() async {
    id = HiveController.getUserId() ?? 'slug';
    groupChatId = '${HiveController.getUserId() ?? 'slug'}-${widget.peerId}';
    log('managerId =>$id');
    FirebaseFirestore.instance.collection(kClients).doc(id).update({
      'active': true,
      'chattingWith': widget.peerId,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    //ArchivesGetxController.to.inSideChat = true;
    setState(() {});
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    String id = HiveController.getUserId() ?? 'slug';
    FirebaseFirestore.instance.collection(kClients).doc(id).update({
      'active': false,
      'chattingWith': null,
    });
    ChatGetxController.to.inSideChat = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    String id = HiveController.getUserId() ?? 'slug';
    if (state == AppLifecycleState.resumed) {
      print('resumed');
      ChatGetxController.to.inSideChat = true;
      FirebaseFirestore.instance.collection(kClients).doc(id).update({
        'active': true,
        'chattingWith': '${widget.peerId}',
      });
    } else if (state == AppLifecycleState.paused) {
      print('paused');
      ChatGetxController.to.inSideChat = false;
      FirebaseFirestore.instance.collection(kClients).doc(id).update({
        'active': false,
        'chattingWith': null,
      });
    } else if (state == AppLifecycleState.detached) {
      print('detached');
      ChatGetxController.to.inSideChat = false;
      FirebaseFirestore.instance.collection(kClients).doc(id).update({
        'chattingWith': null,
        'active': false,
      });
    } else if (state == AppLifecycleState.inactive) {
      print('inactive');
      ChatGetxController.to.inSideChat = false;
      FirebaseFirestore.instance.collection(kClients).doc(id).update({
        'chattingWith': null,
        'active': false,
      });
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  void onSendMessage(String content, String type, String? image) {
    log('resId=> $groupChatId');
    log('managerId=> $id');
    log('peerId=> ${widget.peerId}');
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      FBServices().sendMessage(widget.peerId, content, type, image);

      listScrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Get.snackbar('Nothing to send', '');
    }
  }

  Future getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    imageFile = XFile(result!.files.single.path ?? '');
    if (imageFile != null) {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: GetBuilder<ChatGetxController>(
                    init: Get.put(ChatGetxController()),
                    builder: (logic) {
                      return SizedBox(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(child: Image.file(File(imageFile!.path))),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: CustomButtonWidget(
                                          title: 'Send'.tr,
                                          textSize: 12,
                                          loading: logic.loading,
                                          onTap: () async {
                                            logic.loading = true;
                                            logic.update();
                                            await uploadFile(imageFile, 'image');
                                            logic.loading = false;
                                          })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: CustomButtonWidget(
                                          title: 'Cancel'.tr,
                                          textSize: 12,
                                          onTap: () {
                                            Get.back();
                                          })),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ));
    }
  }

  Future getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    imageFile = XFile(result!.files.single.path ?? '');
    if (imageFile != null) {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: GetBuilder<ChatGetxController>(
                    init: Get.put(ChatGetxController()),
                    builder: (logic) {
                      return SizedBox(
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                  child: Row(
                                children: [
                                  const Icon(Icons.file_copy),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: CustomText(
                                          imageFile!.path.substring(
                                              imageFile!.path.lastIndexOf('/')),
                                          fontSize: 12)),
                                ],
                              )),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: CustomButtonWidget(
                                          title: 'Send'.tr,
                                          textSize: 12,
                                          loading: logic.loading,
                                          onTap: () async {
                                            logic.loading = true;
                                            logic.update();
                                            await uploadFile(imageFile, 'file');
                                            logic.loading = false;
                                          })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: CustomButtonWidget(
                                          title: 'Cancel'.tr,
                                          textSize: 12,
                                          onTap: () {
                                            Get.back();
                                          })),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ));
    }
  }

  Future<void> uploadFile(imageFile, type) async {
    if (imageFile == null) return;
    String? imagePath = await ChatGetxController().uploadImage(image: imageFile!);
    if (imagePath != null) {
      getImageUrl = imagePath;
      onSendMessage(getImageUrl, type, imagePath);
      Get.back();
    } else {
      Get.back();
    }
    setState(() {
      isLoading = false;
    });
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage[index - 1]['client_id'] == id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage[index - 1]['client_id'] != id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['client_id'] != null) {
      // Right (my message)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          document['type'] == 'text'
              ? Container(
                  child: CustomText(
                    document['content'],
                    color: Colors.white,
                    fontSize: 15,
                    textAlign: TextAlign.end,
                  ),
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  constraints: const BoxConstraints(maxWidth: 200),
                  decoration: BoxDecoration(
                      color: secondaryColor, borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 5.0 : 5.0, right: 10.0),
                )

              /// image
              : document['type'] == 'image'
                  ? Container(
                      child: MaterialButton(
                        child: Material(
                          child: isLoading && index == 0
                              ? Container(
                                  width: 200.0,
                                  height: 200.0,
                                  color: Colors.grey,
                                  child: const CircularProgressIndicator(),
                                )
                              : CustomImage(
                                  url: document['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GalleryScreen([document['content']])));
                        },
                        padding: const EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 10.0 : 5.0, right: 10.0),
                    )

                  ///other
                  : document['type'] != null
                      ? GestureDetector(
                          onTap: () {
                            downloadFile(
                              document['content'],
                              '${document['file_name']}'.substring(
                                  '${document['file_name']}'.lastIndexOf('/') + 1),
                            );
                          },
                          child: Container(
                            child: Row(
                              children: [
                                const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Icon(
                                      Icons.arrow_circle_down_sharp,
                                      color: Colors.white,
                                    )),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: CustomText(
                                    '${document['file_name']}.${document['file_mime']}'
                                        .substring(
                                            '${document['file_name']}.${document['file_mime']}'
                                                .lastIndexOf('/')),
                                    color: Colors.white,
                                    fontSize: 12,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                            constraints: const BoxConstraints(maxWidth: 200),
                            decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(8.0)),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ),
                        )
                      : Container(),
          isLastMessageLeft(index)
              ? Container(
                  child: Text(
                    intl.DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(int.parse(document['date']))),
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
                  ),
                  margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                )
              : Container(),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CustomImage(
                          url: widget.peerImage,
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),

                /// text
                document['type'] == 'text'
                    ? Container(
                        child: CustomText(
                          document['content'],
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        constraints: const BoxConstraints(maxWidth: 200),
                        decoration: BoxDecoration(
                            color: blueColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10.0)),
                        margin: const EdgeInsets.only(left: 10.0),
                      )

                    /// image
                    : document['type'] == 'image'
                        ? Container(
                            child: MaterialButton(
                              child: Material(
                                child: CustomImage(
                                  url: document['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    const BorderRadius.all(const Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GalleryScreen([document['content']])));
                              },
                              padding: const EdgeInsets.all(0),
                            ),
                            margin: const EdgeInsets.only(left: 10.0),
                          )

                        ///other
                        : document['type'] != null
                            ? GestureDetector(
                                onTap: () {
                                  /*   HomeController.to.downloadFile(document['content'],
                                      '${document['file_name']}', document['file_mime']);
                               */
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Icon(Icons.arrow_circle_down_sharp)),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: CustomText(
                                          '${document['file_name']}.${document['file_mime']}',
                                          color: Colors.white,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                  padding:
                                      const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                                  constraints: const BoxConstraints(maxWidth: 200),
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10.0)),
                                  margin: const EdgeInsets.only(left: 10.0),
                                ),
                              )
                            : Container(),
              ],
            ),
            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      intl.DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['date']))),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: const EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: const EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const CircularProgressIndicator() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: const Icon(Icons.upload_file, size: 30),
                onPressed: getFile,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: const Icon(Icons.image, size: 30),
                onPressed: getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Expanded(
            child: TextField(
              onSubmitted: (value) {
                onSendMessage(textEditingController.text, 'text', null);
              },
              style: const TextStyle(color: primaryColor, fontSize: 14),
              controller: textEditingController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              focusNode: focusNode,
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () =>
                        onSendMessage(textEditingController.text, 'text', null),
                    color: primaryColor,
                  )
                ],
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor)))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('client_chats')
                  .doc(groupChatId)
                  .collection('messages')
                  .orderBy('date', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor)));
                } else {
                  listMessage.addAll(snapshot.data?.docs ?? []);
                  if (listMessage.isNotEmpty) {
                    if (listMessage[0]['client_id'] == null) {
                      FBServices().updateSeenLastMessage(groupChatId);
                    }
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(10.0),
                          itemBuilder: (context, index) =>
                              buildItem(index, snapshot.data!.docs[index]),
                          itemCount: snapshot.data!.docs.length,
                          reverse: true,
                          controller: listScrollController,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
    );
  }
}
