import 'package:fb_around_market/presentation/service/push_message_service.dart';
import 'package:fb_around_market/presentation/view/login/s_login_integrated_page.dart';
import 'package:fb_around_market/presentation/view/login/signup/s_sign_up_seq1_name.dart';
import 'package:fb_around_market/presentation/view/login/signup/s_signup_seq2_password.dart';
import 'package:fb_around_market/presentation/view/login/signup/s_user_profile_set_page.dart';
import 'package:fb_around_market/presentation/view/main_page/s_main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/color/color_box.dart';

String? userCredentialWithGoogle;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAjmW-LuFp779s0Nsh-l18BAn_Q6ZmwaA4',
      appId: '1:567948579243:web:8a4465b8c875aee53242ee',
      messagingSenderId: '567948579243',
      projectId: 'fbaroundmarket',
      authDomain: 'fbaroundmarket.firebaseapp.com',
      storageBucket: 'fbaroundmarket.appspot.com',
      measurementId: 'G-FKZJQSFTKC',
    ),
  );
  await FirebaseApi().initNotifications();
  await NaverMapSdk.instance.initialize(clientId: 'fyu8vwn1ij');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email');
  runApp(ProviderScope(child: MyApp(initialRoute: email != null ? '/' : '/login',)));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
   MyApp({super.key, required this.initialRoute});
  @override
  Widget build(BuildContext context) {
    final router = GoRouter(initialLocation: initialRoute,routes:[
      GoRoute(path: '/login',name: "login", builder: (context, state) => const LoginIntegratedPage()),
      GoRoute(
        name: "setUserProfile",
        path: '/setUserProfile', builder: (context, state) => const SignUpUserProfileSetPage(),
        routes: [
          //네임드에는 파라미터 못받음 , named push 사용할 경우에도 path에 사용
          GoRoute(path: "signUpName/:userProfile",
            name: "signUpName",
            builder: (context, state) => SignUpAddNamePage(
              userProfile: state.pathParameters["userProfile"],
            ),
          ),
          GoRoute(path: "password/:userId/:userImage",
            name: "password",
            builder: (context, state) => SignUpAddPassWordPage(
              userImage: state.pathParameters["userImage"],
              userId: state.pathParameters["userId"] ?? "이름 없음",

            ),),
        ],
      ),
      GoRoute(
          name: "main",
          path: '/', builder: (context, state) => const MainPage()),
    ],
    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "nexon1",
        colorScheme: ColorScheme.fromSeed(seedColor: selectColor),
        useMaterial3: true,
      ),
        routerConfig: router,


    );
  }
}
