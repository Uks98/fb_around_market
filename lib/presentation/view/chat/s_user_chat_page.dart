import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/ropository/firs_base_mixin/fire_base_queue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserChatPage extends StatelessWidget with FireBaseInitialize{
  UserChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatUserUid = fireBaseAuthInit.currentUser!.uid;
    final chatUserEmail = fireBaseAuthInit.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    Future<void> sendMessage(){

    }
    return const Scaffold(
      body: Column(
        children: [

        ],
      ),
    );
  }
}
