import 'package:fb_around_market/common/size_valiable/utill_size.dart';
import 'package:fb_around_market/presentation/view/chat/w_chat_room_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../ropository/firs_base_mixin/fire_base_queue.dart';

class ChatPage extends StatelessWidget with FireBaseInitialize{
  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeightBox(40),
          "채팅".text.size(bigFontSize + 10).fontWeight(FontWeight.bold).make(),
          Expanded(
            child: StreamBuilder(stream: firestoreInit.collection("users").snapshots(), builder: (BuildContext context,snapshot) {
              if(snapshot.hasError){
                return "error".text.make();
              }else if(snapshot.connectionState == ConnectionState.waiting){
                return "loding . . .".text.make();
              }
              return ListView(
                children: snapshot.data!.docs.map((doc)=>ChatRoomTile(userDataImage: doc["profileImage"],userName: doc["userId"],)).toList(),
              );
            },),
          ),
        ],
      ).p(bigWidth),
    );
  }
}
