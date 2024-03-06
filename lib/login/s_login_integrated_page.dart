import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:velocity_x/velocity_x.dart';

import '../notification_widget/w_toast_notification.dart';
import 'login_riv_state.dart';

class LoginIntegratedPage extends StatelessWidget {

  const LoginIntegratedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController emailTextController = TextEditingController();
    TextEditingController pwdTextController = TextEditingController();
    final toastMsg = ToastNotification();
    Future<UserCredential?> emailSignIn(String email, String password) async {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == "user-not-found") {
          toastMsg.loginToast("일치하는 사용자가 없습니다 😅");
        } else if (e.code == "wrong-password") {
          toastMsg.loginToast("비밀번호가 일치하지 않습니다 😅");
        }
      } catch (e) {
        toastMsg.loginToast("로그인 정보를 확인해주세요 😅");
      }
    }
    // Future<UserCredential?> signInWithGoogle()async{
    //   final FirebaseAuth _auth = FirebaseAuth.instance;
    //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    //   userCredentialWithGoogle = _auth.currentUser?.uid.toString() ?? "";
    //   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    //
    //   final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth?.accessToken,
    //     idToken: googleAuth?.idToken,
    //   );
    //   //print("어센티피케이션 ${}");
    //
    //   return await FirebaseAuth.instance.signInWithCredential(credential);;
    // }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            "스트릿 \n   푸드 파인더".text.fontWeight(FontWeight.w700).size(50).make(),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(

                      cursorColor: Colors.grey,
                      controller: emailTextController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(

                        ),
                        labelText: "아이디",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "아이디를 입력하세요.";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      cursorColor: Colors.grey,
                      controller: pwdTextController,
                      decoration: const InputDecoration(
                        fillColor: Colors.grey,
                        border: UnderlineInputBorder(),
                        labelText: "비밀번호",
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "비밀번호를 입력하세요.";
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Consumer(builder: (context, ref, child) {
                return Consumer(
                    builder: (context,ref,child) {
                      return MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final result = await emailSignIn(
                                emailTextController.text.trim(),
                                pwdTextController.text.trim());

                            if (result == null) {
                              if(context.mounted){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(content: Text("로그인 실패"),),);
                              }
                              return;
                            }
                            ref.watch(userCredentialProvider.notifier).state = result;
                            if(context.mounted){
                             // context.go("/");
                            }
                          }
                        },
                        height: 48,
                        minWidth: double.infinity,
                        color: Colors.red,
                        child: const Text(
                          "로그인",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }
                );
              }),
            ),
            TextButton(
              onPressed: () => context.push("/signUp"),
              child: "계정이 없나요? 회원가입".text.color(Colors.grey).make(),
            ),
          ],
        ),
      ),
    );
  }
}
