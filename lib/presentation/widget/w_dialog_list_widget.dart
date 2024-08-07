
import 'package:fb_around_market/presentation/service/char_data_service/chat_get_send_service.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../data/chat_favorite_data.dart';
import '../view/my_page/widgets/w_favorite_widget.dart';

class CustomAlertDialog extends StatelessWidget {
    CustomAlertDialog({super.key,required this.senderEmail,required this.callback,required this.receiverId});
  final String senderEmail;
  final Future<void> Function() callback;
  final String receiverId;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: 500.0,
        height: 800.0,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _buildUserLikeList(senderEmail),),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildUserLikeList(String senderEmail) {
    final ChatService _chatService = ChatService();
    return StreamBuilder(
      stream: _chatService.getLikeUserList(senderEmail),
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
          children: snapshot.data!.docs.map((doc) =>
              GestureDetector(
                onTap: () async{
                  //callback;
                  await _chatService.sendMessage(receiverId, "a","a", Favorite(
                    imagePath: doc["favoriteItem"]["categoryImage"].toString().replaceAll("(", "").replaceAll(")", ""),
                    categories: doc["favoriteItem"]["categories"][0],
                    marketName: doc["favoriteItem"]["marketName"],
                    kindOfCash: doc["favoriteItem"]["kindOfCash"][0],
                  ).toJson()
                  );
                  Navigator.of(context).pop();
                },
                child: FavoriteWidget(
                            imagePath: doc["favoriteItem"]["categoryImage"].toString().replaceAll("(", "").replaceAll(")", ""),
                            categories: doc["favoriteItem"]["categories"][0],
                            marketName: doc["favoriteItem"]["marketName"],
                            kindOfCash: doc["favoriteItem"]["kindOfCash"][0],
                          ),
              ),
          ).toList(),
        );
      },
    );
  }
}