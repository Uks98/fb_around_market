import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/common/color/color_box.dart';
import 'package:fb_around_market/common/size_valiable/utill_size.dart';
import 'package:fb_around_market/data/chat_favorite_data.dart';
import 'package:fb_around_market/presentation/service/char_data_service/chat_get_send_service.dart';
import 'package:fb_around_market/presentation/view/chat/s_image_detail.dart';
import 'package:fb_around_market/ropository/firs_base_mixin/fire_base_queue.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../domain/logic/image_compress.dart';
import '../../widget/w_dialog_list_widget.dart';
import '../my_page/widgets/w_favorite_widget.dart';

class UserChatPage extends StatefulWidget {
  const UserChatPage(
      {super.key,
      required this.senderEmail,
      required this.receiverID,
      required this.receiverUserImage,
      required String docId,
        required this.receiverEmail
      });

  final String senderEmail;
  final String receiverID; //uid
  final String? receiverUserImage;
  final String? receiverEmail;
  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> with FireBaseInitialize {
  final ChatService _chatService = ChatService();

  //textfield focus
  FocusNode myFocusNode = FocusNode();
  Uint8List? imageData; // 라이브러리를 사용해서 이미지를 저장할때 사용하는 변수
  String? userChatImage; //유저가 보낸 채팅창에 이미지
  XFile? image;
  final favorite = Favorite(
    marketName: "1",
    kindOfCash: "1",
    categories: "1",
    imagePath: "1",
  );

  //이미지를 firestorage에 저장하는 함수
  Future<void> saveUserChatImage() async {
    final ComplexImageLogicBox _imageCompress = ComplexImageLogicBox();
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref("userChatImage/").child(
        "${DateTime.now().microsecondsSinceEpoch}_${image?.name ?? "??"}.jpg");
    final compressImage = await _imageCompress.imageCompressList(imageData!);
    await storageRef.putData(compressImage);
    userChatImage = await storageRef.getDownloadURL();
    await _chatService.sendMessage(widget.receiverID, _messageController.text.toString(), userChatImage, favorite.toJson());
  }

  ///이미지를 갤러리나 카메라에서 가져오는 함수
  Future<void> pickImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    final img = await imagePicker.pickImage(source: source);
    if (img != null) {
      imageData = await img.readAsBytes();
      setState(() {});
      await saveUserChatImage();
    }
  }

  ///채팅방 유니크 아이디입니다.
  String chatRoomIds() {
    String senderId = fireBaseAuthInit.currentUser!.uid;
    final ids = [widget.receiverID, senderId];
    ids.sort();
    ids.join("_");
    final idd = ids.join("_");
    return idd;
  }

  final TextEditingController _messageController = TextEditingController();
  ///즐겨찾기에 저장된 내 길거리음식점을 상대방에게 전송해 주는 기능
  Future<void> sendUserFavorite() async {
    if (_messageController.text.isNotEmpty) {
      // 메세지 보내기
      await _chatService.sendMessage(widget.receiverID, _messageController.text.toString(), "", favorite.toJson());
      // 메세지 클리어_messageController.clear();
    }
    readMessage();
    scrollDown();
  }
  ///메세지 전송
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      //메세지 보내기
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text.toString(), "", Favorite(
        marketName: "1",
        kindOfCash: "1",
        categories: "1",
        imagePath: "1",
      ).toJson());
      //메세지 클리어
      _messageController.clear();
    }
    readMessage();
    scrollDown();
  }
///읽음 안읽음 표시
  void readMessage() async =>
      _chatService.readAllMessages(chatRoomIds(), widget.receiverID);
  final ScrollController _scrollController = ScrollController();

  void scrollDown() =>
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);


  @override
  void initState() {
    super.initState();
    readMessage();
    print("${widget.senderEmail}");
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  ///이미지 상세페이지로 가는 함수
  void detailImage(String image) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageDetail(
          image: image,
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _chatBubble(
        String message,
        Alignment alignment,
        bool isCurrentUser,
        DateTime time,
        bool isReadChat,
        String userImage,
        String senderId,
        String receiverId,
        dynamic favoriteItem,
        String senderEmail,
        ) {
      String nullUserImage = "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=";
      String exchangeTime = _chatService.exchangeTime(time);
      bool notCurrentUser = !isCurrentUser;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          notCurrentUser
              ? GestureDetector(
                  onTap: () => detailImage(widget.receiverUserImage ?? ""),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(widget.receiverUserImage
                            ?.toString()
                            .replaceAll("(", "")
                            .replaceAll(")", "") ??
                        nullUserImage),
                  ),
                )
              : Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              isReadChat == false
                  ? "안읽음".text.color(baseColor).size(smallFontSize).make()
                  : "".text.color(baseColor).size(smallFontSize).make(),
              !notCurrentUser
                  ? exchangeTime.toString().text.size(smallFontSize).make()
                  : Container(),
            ],
          ),
          WidthBox(smallWidth),
          //챗 버블
          ChatBubble(
                  backGroundColor:
                      notCurrentUser ? Colors.grey[100] : baseColor,
                  alignment: alignment,
                  clipper: ChatBubbleClipper5(
                      type: notCurrentUser
                          ? BubbleType.receiverBubble
                          : BubbleType.sendBubble),
                  child: buildMessageContent(userImage,message,notCurrentUser,favoriteItem,senderEmail).pOnly(right: normalWidth),),
          notCurrentUser
              ? exchangeTime.toString().text.size(smallFontSize).make()
              : Container(),
        ],
      ).pOnly(bottom: normalHeight);
    }
    ///채팅이 전송되면 위젯 실행되는 함수
    Widget _buildMessageItem(DocumentSnapshot doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      bool isCurrentUser = data["senderId"] == fireBaseAuthInit.currentUser!.uid;
      final messageTime = data["timeStamp"].toDate();
      final favoriteItem = data["favorite"];
      var alignment =isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
      //receiverEmail = data["senderEmail"];
      return Container(
        alignment: alignment,
        child: _chatBubble(
            data["message"],
            alignment,
            isCurrentUser,
            messageTime,
            data["isRead"],
            data["userImage"],
            data["senderId"],
            data["receiverId"],
            favoriteItem,
            data["senderEmail"]
        ),
      );
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
          }
          if (snapshot.data!.docs.isEmpty) {
            return "empty !".text.make();
          }
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) {
                  return _buildMessageItem(doc);
                },)
                .toList(),
          );
        },
      );
    }
///채팅 입력 창
    Widget _buildUserInput() {
      return Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: myFocusNode,
              decoration: const InputDecoration(
                hintText: '메세지 보내기..',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
              controller: _messageController,
            ),
          ),
          IconButton(
              icon: const Icon(
                Ionicons.camera_outline,
                size: 25,
              ),
              onPressed: () => sendMessage()),
          IconButton(
            icon: const Icon(
              Ionicons.heart_circle_outline,
              size: 25,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                  receiverId: widget.receiverID,
                  receiverEmail: widget.receiverEmail ?? "",
                   readMessage: readMessage,
                   scrollDown: scrollDown,

                );
              },
            ),
          ),
          IconButton(
              icon: const Icon(
                Ionicons.image_outline,
                size: 25,
              ),
              onPressed: () => pickImage(ImageSource.gallery)),
          IconButton(
              icon: const Icon(
                Ionicons.camera_outline,
                size: 25,
              ),
              onPressed: () => pickImage(ImageSource.camera)),
          IconButton(
            onPressed: () => sendMessage(),
            icon: const Icon(
              Ionicons.send_sharp,
              size: 25,
              color: baseColor,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: widget.senderEmail.text.make(),
        centerTitle: true,
        elevation: 2,
        backgroundColor: baseColor.withOpacity(0.3),
      ),
      body: Column(
        children: [Expanded(child: _buildMessageList()), _buildUserInput()],
      ).p(bigHeight),
    );
  }
  Widget buildMessageContent(String userImage,String message,bool notCurrentUser,dynamic favoriteItem,String senderId) {
    if (userImage == "") {
      return message.text
          .color(notCurrentUser ? Colors.black : Colors.white)
          .make();
    } else if(favoriteItem["imagePath"] != "1"){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "${senderId}님이 추천하는 장소".text.color(notCurrentUser ? Colors.grey[600] : Colors.white).fontWeight(FontWeight.bold).make().pOnly(left: smallWidth,bottom: smallHeight),
          FavoriteWidget(
            imagePath: favoriteItem["imagePath"].toString().replaceAll("(", "").replaceAll(")", ""),
            categories:favoriteItem["categories"],
            marketName:favoriteItem["marketName"],
            kindOfCash:favoriteItem["kindOfCash"],
          ),
        ],
      );
    } {
      return GestureDetector(
        onTap: () => detailImage(userImage),
        child: Container(
          padding: EdgeInsets.zero,
          width: 150,
          height: 200,
          child: Image.network(
            userImage,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    }
}
