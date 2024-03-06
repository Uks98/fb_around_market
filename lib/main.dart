import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'login/s_login_integrated_page.dart';
import 'login/signup/s_sign_up_seq1_name.dart';
import 'login/signup/s_user_profile_set_page.dart';

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
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final router = GoRouter(initialLocation: "/login",routes:[
      GoRoute(path: '/login', builder: (context, state) => LoginIntegratedPage()),
    GoRoute(
        path: '/signUp', builder: (context, state) => SignUpUserProfileSetPage(),
      routes: [
        GoRoute(path: "signUpName", builder: (context, state) => SignUpAddNamePage(),)
      ],
    ),
  ],

  );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "nexon1",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
        routerConfig: router,


    );
  }
}
