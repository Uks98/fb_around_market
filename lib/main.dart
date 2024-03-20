import 'package:fb_around_market/color/color_box.dart';
import 'package:fb_around_market/logic/map/s_all_place_map.dart';
import 'package:fb_around_market/login/signup/s_signup_seq2_password.dart';
import 'package:fb_around_market/main_page/s_main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'login/s_login_integrated_page.dart';
import 'login/signup/s_sign_up_seq1_name.dart';
import 'login/signup/s_user_profile_set_page.dart';
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
    )
  );
  await NaverMapSdk.instance.initialize(clientId: 'fyu8vwn1ij');
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final router = GoRouter(initialLocation: "/login",routes:[
      GoRoute(path: '/login',name: "login", builder: (context, state) => LoginIntegratedPage()),
    GoRoute(
      name: "setUserProfile",
        path: '/setUserProfile', builder: (context, state) => SignUpUserProfileSetPage(),
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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
