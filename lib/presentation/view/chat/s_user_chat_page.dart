import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/common/color/color_box.dart';
import 'package:fb_around_market/common/size_valiable/utill_size.dart';
import 'package:fb_around_market/presentation/service/char_data_service/chat_get_send_service.dart';
import 'package:fb_around_market/presentation/view/chat/w_chat_room_tile.dart';
import 'package:fb_around_market/ropository/firs_base_mixin/fire_base_queue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:velocity_x/velocity_x.dart';


class UserChatPage extends StatefulWidget  {
  const UserChatPage({super.key, required this.receiverEmail, required this.receiverID, required this.receiverUserImage, required String docId});

  final String receiverEmail;
  final String receiverID; //uid
  final String? receiverUserImage;

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> with FireBaseInitialize {

  final ChatService _chatService = ChatService();
  //Timer? _timer;
  String chatRoomIds(){
    String senderId = fireBaseAuthInit.currentUser!.uid;
    final ids = [widget.receiverID,senderId];
    ids.sort();
    ids.join("_");
    final idd = ids.join("_");
    return idd;
  }///채팅방 유니크 아이디입니다.
  final TextEditingController _messageController = TextEditingController();
  void sendMessage() async {
    final String senderId = fireBaseAuthInit.currentUser!.uid;
    final String userUid = fireBaseAuthInit.currentUser!.uid;
    if (_messageController.text.isNotEmpty) {
      //메세지 보내기
      await _chatService.sendMessage(widget.receiverID, _messageController.text.toString());
      //메세지 클리어
      _messageController.clear();
    }
  }
  void readMessage()async{
    final String myUid = fireBaseAuthInit.currentUser!.uid;
    if(myUid != widget.receiverID){
      _chatService.readAllMessages(chatRoomIds());
    }
  }

  @override
  void initState() {
    super.initState();
    readMessage();
    // _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    //   if(fireBaseAuthInit.currentUser!.uid != widget.receiverID){
    //     _chatService.readAllMessages(chatRoomIds());
    //   }
    // });
  }
  @override
  void dispose() {
    // 위젯이 dispose될 때 타이머 취소
   // _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Widget _chatBubble(String message,Alignment alignment,bool isCurrentUser,DateTime time,bool isReadChat){
      String nullUserImage = "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=";
      String exchangeTime = _chatService.exchangeTime(time);
      bool notCurrentUser = !isCurrentUser;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          notCurrentUser ? CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
                widget.receiverUserImage
                    ?.toString()
                    .replaceAll("(", "")
                    .replaceAll(")", "") ?? nullUserImage),
          ) : Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              isReadChat == false ? "안읽음".text.color(baseColor).size(smallFontSize).make() : "".text.color(baseColor).size(smallFontSize).make(),
              !notCurrentUser ? exchangeTime.toString().text.size(smallFontSize).make() : Container(),
            ],
          ),
          WidthBox(smallWidth),
          ChatBubble(
            backGroundColor: notCurrentUser ? Colors.grey[100] : baseColor,
            alignment: alignment,
            clipper: ChatBubbleClipper5(type: notCurrentUser ?BubbleType.receiverBubble : BubbleType.sendBubble),
            child: message.text.color(notCurrentUser ? Colors.black :Colors.white).make(),
            // Container(
            //     width: 100,
            //     height: 100,
            //     child :Image.network(receiverUserImage!))
          ).pOnly(right: normalWidth),
          notCurrentUser ? exchangeTime.toString().text.size(smallFontSize).make() : Container(),

        ],
      ).pOnly(bottom: normalHeight);
    }

    Widget _buildMessageItem(DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      bool isCurrentUser = data["senderId"] == fireBaseAuthInit.currentUser!.uid;
      final messageTime = data["timeStamp"].toDate();
      var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
      return Container( alignment : alignment,child: _chatBubble(data["message"],alignment,isCurrentUser,messageTime,data["isRead"]),);
    }

    //메세지 리스트
    Widget _buildMessageList() {
      return StreamBuilder(
        stream: _chatService.getMessage(chatRoomIds()),
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
              decoration: const InputDecoration(
                hintText: '메세지 보내기..',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
              controller: _messageController,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.photo),
            onPressed: () {
              // 갤러리 버튼 클릭 시 동작 정의
            },
          ),
          IconButton(
              onPressed: () => sendMessage(),
              icon: const Icon(Icons.arrow_upward))
        ],
      );
    }


    return Scaffold(
      appBar: AppBar(title: widget.receiverEmail.text.make(),centerTitle: true,elevation: 2, backgroundColor: baseColor.withOpacity(0.3),),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput()
        ],
      ).p(bigHeight),
    );
  }
  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> currentUserLength(
      ChatService _chatService, String idd) {
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
        docId = doc.id;
        return doc["userCount"].toString().text.size(smallFontSize-3).color(Colors.grey[700]).make();
      },
    );
  }
}
