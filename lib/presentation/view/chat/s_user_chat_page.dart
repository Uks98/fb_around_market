import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/presentation/service/char_data_service/chat_get_send_service.dart';
import 'package:fb_around_market/ropository/firs_base_mixin/fire_base_queue.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class UserChatPage extends StatelessWidget with FireBaseInitialize {
  UserChatPage(
      {super.key, required this.receiverEmail, required this.receiverID});

  final String receiverEmail;
  final String receiverID; //uid

  @override
  Widget build(BuildContext context) {
    final ChatService _chatService = ChatService();
    final TextEditingController _messageController = TextEditingController();
    void sendMessage() async {
      if (_messageController.text.isNotEmpty) {
        //메세지 보내기
        await _chatService.sendMessage(receiverID, _messageController.text.toString());
        //메세지 클리어
        _messageController.clear();
      }
    }

    Widget _buildMessageItem(DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      bool isCurrentUser = data["senderId"] == fireBaseAuthInit.currentUser!.uid;
      var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
      return Container( alignment : alignment,child: Text(data["message"]));
    }

    //메세지 리스트
    Widget _buildMessageList() {
      String senderId = fireBaseAuthInit.currentUser!.uid;
      final ids = [receiverID,senderId];
      ids.sort();
      ids.join("_");
      final idd = ids.join("_");
      print("aaaadd ${idd}");
      return StreamBuilder(
        stream: _chatService.getMessage(idd),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return "error !".text.make();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return "loding !".text.make();
          }if(snapshot.data!.docs.isEmpty){
            return "empty !".text.make();
          }
          return ListView(
            children: snapshot.data!.docs
                .map(
                  (doc) => _buildMessageItem(doc),
                )
                .toList(),
          );
        },
      );
    }

    Widget _buildUserInput() {
      return Row(
        children: [
          Expanded(
              child: TextField(
            controller: _messageController,
            obscureText: false,
          )),
          IconButton(
              onPressed: () => sendMessage(),
              icon: const Icon(Icons.arrow_upward))
        ],
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput()
        ],
      ),
    );
  }
}
