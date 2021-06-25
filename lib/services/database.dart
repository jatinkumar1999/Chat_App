import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUserName(String userName) async {
    return await FirebaseFirestore.instance
        .collection('chat_app_users')
        .where('name', isEqualTo: userName)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection('chat_app_users')
        .where('email', isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(String userName, String email) {
    FirebaseFirestore.instance
        .collection('chat_app_users')
        .add({'name': userName, 'email': email});
  }

  createChatRoom(String chatRoomID, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomID)
        .set(chatRoomMap)
        .catchError((e) {
      print(e);
    });
  }

  addConversationMessage(String chatRoomid, messageMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomid)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  showConversationMessage(String chatRoomid) async {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomid)
        .collection('chats')
        .orderBy('time')
        .snapshots();
  }

  getChatroom(String userName) async {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }

  messageid(String chatRoomid) {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomid)
        .collection('chats')
        .doc()
        .id;
  }

  deletemessage(String chatRoomid, String docid) {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomid)
        .collection('chats')
        .doc(docid)
        .delete();
  }

  deleteRoomid(String chatRoomid) {
    return FirebaseFirestore.instance.collection('ChatRoom').id;
  }

  deleteRoom(String chatRoomid, String id) {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomid)
        .delete();
  }

  updatemessage(String chatRoomid, String docid, message) {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomid)
        .collection('chats')
        .doc(docid)
        .update({"message": message});
  }
}
