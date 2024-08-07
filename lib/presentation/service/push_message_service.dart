import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  //알람초기화
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();

    print("Token : $fCMToken");
  }
  // Future<void> sendPushMessage(String token, String title, String body) async {
  //   final String serverToken = 'YOUR_SERVER_KEY';  // Firebase Console에서 복사한 서버 키
  //   try {
  //     await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'key=$serverToken',
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           'notification': <String, dynamic>{
  //             'body': body,
  //             'title': title,
  //           },
  //           'priority': 'high',
  //           'data': <String, dynamic>{
  //             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //             'id': '1',
  //             'status': 'done',
  //           },
  //           'to': token,
  //         },
  //       ),
  //     );
  //     print('Push message sent');
  //   } catch (e) {
  //     print('Error sending push message');
  //     print(e);
  //   }
  // }
}

