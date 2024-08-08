import 'package:fb_around_market/common/size_valiable/utill_size.dart';
import 'package:fb_around_market/presentation/view/chat/s_user_chat_page.dart';
import 'package:fb_around_market/presentation/view/chat/w_chat_room_tile.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../ropository/firs_base_mixin/fire_base_queue.dart';

class ChatPage extends StatelessWidget with FireBaseInitialize {
  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? receiverEmail;
    final userUid = fireBaseAuthInit.currentUser!.uid;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeightBox(40),
          "채팅".text.size(bigFontSize + 10).fontWeight(FontWeight.bold).make(),
          Expanded(
            child: StreamBuilder(
              stream: firestoreInit.collection("users").snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return "error".text.make();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return "loding . . .".text.make();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    final isReceiverUid = userUid == doc["userUid"];
                    if(isReceiverUid){
                      receiverEmail = doc["userId"];
                    }
                    return ChatRoomTile(
                      userDataImage: doc["profileImage"],
                      senderEmail: doc["userId"], // email
                      userID: doc["userUid"] ?? "",
                      receiverEmail: receiverEmail,// uid
                    );
                  },
                );
              },
            ),
          ),
        ],
      ).p(bigWidth),
    );
  }
}
