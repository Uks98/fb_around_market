import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/model/market_add_data/map_marker_data.dart';
import 'chat_favorite_data.dart';

class Message {
  final String? senderId;
  final String? senderEmail;
  final String? receiverId;
  final String? message;
  final Timestamp timeStamp;
  final String? userChatImage;
  bool isRead = false;
  Map<String,dynamic>? favorite;
  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timeStamp,
    required this.isRead,
    required this.userChatImage,
   required this.favorite
});

  Map<String,dynamic> toMap(){
    return {
      "senderId" : senderId,
      "senderEmail" :senderEmail ,
      "receiverId" :receiverId ,
      "message" :message,
      "timeStamp" :timeStamp,
      "isRead" : isRead,
      "userImage": userChatImage,
      "favorite" : favorite
    };
  }
}