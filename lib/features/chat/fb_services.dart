import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/hive/hive_controller.dart';

String kClients = 'table_1';
String imageUrl = 'imageUrl';

class FBServices {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getChats() async* {
    yield* _fireStore
        .collection('client_chats')
        .where('client_id', isEqualTo: '${HiveController.getUserId()}')
        .snapshots();
  }


  sendMessage(String advertiseId, String content, String type, String? image) async {
    String? clientId = HiveController.getUserId();
    var documentRef = _fireStore.collection('client_chats').doc('$clientId-$advertiseId');
    documentRef.set({
      'client_id': '$clientId',
      'advertise_id': advertiseId,
      'last_message_content': content,
      'sender': 'client',
      'seen': false,
      'last_message_date': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    documentRef.collection('messages').doc().set({
      'client_id': '$clientId',
      'advertise_id': null,
      'date': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': content,
      'type': type,
      'client_name': HiveController.getUserName(),
      if (image != null) 'file_mime': '${image}',
      if (image != null) 'file_name': '${image}',
    });
    var documentRef1 = _fireStore.collection('client_chats').doc('$advertiseId-$clientId');
    documentRef1.set({
      'client_id': advertiseId,
      'advertise_id': '$clientId',
      'last_message_content': '$content',
      'sender': 'client',
      'seen': false,
      'last_message_date': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    documentRef1.collection('messages').doc().set({
      'client_id': null,
      'advertise_id': advertiseId,
      'date': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': content,
      'type': type,
      'client_name': HiveController.getUserName(),
      if (image != null) 'file_mime': image,
      if (image != null) 'file_name': image,
    });
  }

  void updateSeenLastMessage(uid) {
    var documentRef = _fireStore.collection('client_chats').doc(uid);
    documentRef.update({'seen': true});
  }

  Stream<DocumentSnapshot> getLastMessage(String advertiseId) async* {
    yield* _fireStore
        .collection('client_chats')
        .doc('${HiveController.getUserId()}-$advertiseId')
        .snapshots();
  }
}
