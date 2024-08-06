import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? senderId;
  final String? senderEmail;
  final String? receiverId;
  final String? message;
  final Timestamp timeStamp;
  final String? userChatImage;
  bool isRead = false;
  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timeStamp,
    required this.isRead,
    required this.userChatImage
});

  Map<String,dynamic> toMap(){
    return {
      "senderId" : senderId,
      "senderEmail" :senderEmail ,
      "receiverId" :receiverId ,
      "message" :message,
      "timeStamp" :timeStamp,
      "isRead" : isRead,
      "userImage": userChatImage
    };
  }
}