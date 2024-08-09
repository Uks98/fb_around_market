import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/common/color/color_box.dart';
import 'package:fb_around_market/common/size_valiable/utill_size.dart';
import 'package:fb_around_market/presentation/view/chat/s_user_chat_page.dart';
import 'package:fb_around_market/ropository/firs_base_mixin/fire_base_queue.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../service/char_data_service/chat_get_send_service.dart';

String? docId;
class ChatRoomTile extends StatelessWidget with FireBaseInitialize {
  ChatRoomTile(
      {super.key, required this.userDataImage, required this.senderEmail, required this.userID,required this.receiverEmail});

  final String? userDataImage;
  final String? senderEmail;
  final String? userID;
  final String? receiverEmail;
  @override
  Widget build(BuildContext context) {
    String senderId = fireBaseAuthInit.currentUser!.uid;
    final ids = [userID, senderId];
    ids.sort();
    ids.join("_");
    final idd = ids.join("_");
    final _chatService = ChatService();
    String nullUserImage = "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=";
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return UserChatPage(
                    senderEmail: senderEmail ?? "", //email
                    receiverID: userID ?? "", //uid
                    receiverUserImage: userDataImage ?? "",
                    docId : docId ?? "",
                    receiverEmail: receiverEmail,
                  );
              },
            ),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                userDataImage
                    ?.toString()
                    .replaceAll("(", "")
                    .replaceAll(")", "") ?? nullUserImage),
          ),
          WidthBox(normalWidth),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              senderEmail!.text.fontWeight(FontWeight.bold).size(smallFontSize).make(),
              lastMessageWidget(_chatService, idd),
            ],
          ),
          ///사용자가 읽지않은 메세지를 표시하는 위젯입니다.
          getCurrentNotReadWidget(_chatService,idd).pOnly(left: 10)
        ],
      ).pOnly(top: normalHeight),



    );
  }
  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> getCurrentNotReadWidget(ChatService _chatService, String idd) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _chatService.getUnreadMessagesCount(idd),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return "".text.size(smallFontSize-3).color(Colors.grey[700]).make();
        }
        final doc = snapshot.data!.docs.length;
        return VxBox(child: doc.toString().text.center.size(3).color(Colors.white).make()).roundedFull.color(baseColor).padding(EdgeInsets.all(smallHeight)).make();
      },
    );
  }
  ///채팅방 내 가장 마지막에 보낸 메세지를 표시합니다.
  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> lastMessageWidget(ChatService _chatService, String idd) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _chatService.getLastMessageStream(idd),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return "메세지가 없습니다.".text.size(smallFontSize-3).color(Colors.grey[700]).make();
        }
        final doc = snapshot.data!.docs.first;
        final time = _chatService.exchangeTime(doc["timeStamp"].toDate());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            doc["userImage"] == "" ?doc["message"].toString().text.size(smallFontSize-3).color(Colors.grey[500]).make() : "사진을 보냈습니다.".toString().text.size(smallFontSize-3).color(Colors.grey[500]).make(),
            time.toString().text.size(1).color(Colors.grey[500]).make(),
          ],
        );
      },
    );
  }
}

