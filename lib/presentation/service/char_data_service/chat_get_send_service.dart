import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/data/chat_favorite_data.dart';
import 'package:fb_around_market/domain/model/market_add_data/map_marker_data.dart';
import 'package:fb_around_market/ropository/firs_base_mixin/fire_base_queue.dart';
import 'package:intl/intl.dart';

import '../../../data/messageData.dart';

class ChatService with FireBaseInitialize{
  Future<void> sendMessage(String senderId, message, String? userChatImage,Map<String,dynamic>? favorite) async {
    final receiverId = fireBaseAuthInit.currentUser!.uid;
    final chatUserEmail = fireBaseAuthInit.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();
    bool isRead = false; //답장을 받는 사람이 답장을 확인했는지 유무 boolean
    Message newMessage = Message(
      senderId: receiverId ?? "",
      senderEmail: chatUserEmail ?? "a",
      receiverId: senderId ?? "",
      message: message ?? "a",
      timeStamp: timestamp,
      isRead: isRead,
      userChatImage: userChatImage ?? "",
      favorite: favorite
    );
    List<String> ids = [receiverId, senderId];
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

 ///사용자가 즐겨찾기한 맛집 리스트를 제공합니다.
  Stream<QuerySnapshot<Map<String, dynamic>>> getLikeUserList(String? receiverEmail) {
    final favorites = firestoreInit.collection("users").doc(receiverEmail ?? " ")
        .collection("favorite").snapshots();
    return favorites;
  }

  void readAllMessages(String chatRoomId, String receiverId) async {
    try {
      // 메시지 컬렉션에서 모든 문서를 가져오기
      var messages = await firestoreInit
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("message")
          .get();

      final String myUid = fireBaseAuthInit.currentUser!.uid;

      // 모든 문서에 대해 isRead 필드를 업데이트
      for (var doc in messages.docs) {
        if (doc['receiverId'] == myUid) {
          // 내가 메시지를 받는 사람인 경우
          await doc.reference.update({'isRead': true});
        }
      }
    } catch (e) {
      print(e);
    }
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getUnreadMessagesCount(String chatRoomId) {
    final String myUid = fireBaseAuthInit.currentUser!.uid;

    // Firestore snapshots 사용하여 실시간으로 변화를 감지하는 Stream 반환
    return firestoreInit
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("message")
        .where('isRead', isEqualTo: false)
        .where('receiverId', isEqualTo: myUid)
        .snapshots();
  }


  String exchangeTime(DateTime time){
    String formattedTime = DateFormat('a h시 mm분').format(time);
    return formattedTime;
  }
}