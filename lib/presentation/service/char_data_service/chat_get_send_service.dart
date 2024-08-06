import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/ropository/firs_base_mixin/fire_base_queue.dart';
import 'package:intl/intl.dart';

import '../../../data/messageData.dart';

class ChatService with FireBaseInitialize{
  Future<void> sendMessage(String receiverId, message, String? userChatImage) async {
    final chatUserUid = fireBaseAuthInit.currentUser!.uid;
    final chatUserEmail = fireBaseAuthInit.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();
    bool isRead = false;
    Message newMessage = Message(
      senderId: chatUserUid ?? "",
      senderEmail: chatUserEmail ?? "a",
      receiverId: receiverId ?? "",
      message: message ?? "a",
      timeStamp: timestamp,
      isRead: isRead,
      userChatImage: userChatImage ?? ""
    );
    List<String> ids = [chatUserUid, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');

    await firestoreInit
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("message")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(String ids) {

    return firestoreInit
        .collection("chat_rooms")
        .doc(ids)
        .collection("message")
        .orderBy("timeStamp", descending: false)
        .snapshots();

  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessageStream(String ids) {
    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(ids)
        .collection("message")
        .orderBy("timeStamp", descending: true) // 최신 메시지가 맨 앞에 오도록 정렬
        .limit(1)
        .snapshots();
  }
  void readAllMessages(String chatRoomId,String receiverId) async {
    try {
      // 메시지 컬렉션에서 모든 문서를 가져오기
      var messages = await firestoreInit
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("message")
          .get();
      final String myUid = fireBaseAuthInit.currentUser!.uid;
      // 모든 문서에 대해 isRead 필드를 true로 업데이트
      // 현재 id와 보내는 사람의 메세지가 같은 경우에만 update를 진행합니다.
      for (var doc in messages.docs) {
        if(myUid != receiverId){
        await doc.reference.update({'isRead': false,});
        print("실행");
        }if(myUid == receiverId){
          await doc.reference.update({'isRead': true,});
        }
      }
          print("myUid  ${myUid}");
          print("receiverId ${receiverId}");
      print("All messages updated successfully");
    } catch (e) {
      print("Error updating messages: $e");
    }
  }

  String exchangeTime(DateTime time){
    String formattedTime = DateFormat('a h시 mm분').format(time);
    return formattedTime;
  }
}