import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login/login_integrated_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyB7wZb2tO1-Fs6GbDADUSTs2Qs3w08Hovw',
      appId: '1:406099696497:web:87e25e51afe982cd3574d0',
      messagingSenderId: '406099696497',
      projectId: 'flutterfire-e2e-tests',
      storageBucket: 'flutterfire-e2e-tests.appspot.com',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "nexon1",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginIntegratedPage(),
    );
  }
}
