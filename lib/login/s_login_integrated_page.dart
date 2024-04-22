import 'package:fb_around_market/color/color_box.dart';
import 'package:fb_around_market/firs_base_mixin/fire_base_queue.dart';
import 'package:fb_around_market/login/signup/s_signup_seq2_password.dart';
import 'package:fb_around_market/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:velocity_x/velocity_x.dart';

import '../notification_widget/w_toast_notification.dart';
import '../widget/w_login_container_widget.dart';
import 'login_riv_state.dart';

class LoginIntegratedPage extends ConsumerWidget with FireBaseInitialize {

  LoginIntegratedPage({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController emailTextController = TextEditingController();
    TextEditingController pwdTextController = TextEditingController();

    Future<UserCredential?> emailSignIn(String email, String password) async {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == "user-not-found") {
          ToastNotification.warningToast("일치하는 사용자가 없습니다 😅");
        } else if (e.code == "wrong-password") {
          ToastNotification.warningToast("비밀번호가 일치하지 않습니다 😅");
        }
      } catch (e) {
        ToastNotification.warningToast("로그인 정보를 확인해주세요 😅");
      }
    }
    Future<UserCredential?> signInWithGoogle()async{
      userCredentialWithGoogle = fireBaseAuthInit.currentUser?.uid ?? "";
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      //print("어센티피케이션 ${}");

      return await FirebaseAuth.instance.signInWithCredential(credential);;
    }
    return Scaffold(
      backgroundColor: baseColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HeightBox(100),
            "스트릿 \n   푸드 파인더".text.fontWeight(FontWeight.w700).fontFamily("title").size(60).color(Colors.white).make(),
            const HeightBox(30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0,right: 40.0),
                    child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      controller: emailTextController,
                      //밑즐만 하얗게
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.white, // 원하는 색상으로 변경
                        ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
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
                  const HeightBox(70),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0,right: 40.0),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.grey,
                      controller: pwdTextController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        fillColor: Colors.grey,
                        labelText: "비밀번호",
                        labelStyle: TextStyle(
                          color: Colors.white, // 원하는 색상으로 변경
                        ),

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
            const HeightBox(90),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Consumer(builder: (context, ref, child) {
                return Consumer(
                    builder: (context,ref,child) {
                      return LoginContainer(loginSite: '이메일로 로그인', containerColor: Colors.white,textColor: Colors.black,
                        isLabel: false,
                        callback: ()async {
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
                              context.pushNamed("main");
                            }
                          }
                        },
                      );
                    }
                );
              }),
            ),
            LoginContainer(loginSite: '구글 계정으로 로그인', containerColor: Colors.white,textColor: Colors.black,
            isLabel: true,
            assetImage: "assets/google.png",
            callback: ()async{
              final userCredit = await signInWithGoogle();
              if(userCredit != null){
                await signInWithGoogle();
                context.pushNamed("main");
              }else{
                ToastNotification.warningToast("구글 로그인에 실패했습니다");
              }
            }
            ),
            const HeightBox(30),
            TextButton(
              onPressed: () => context.goNamed("setUserProfile"),
              child: "계정이 없나요? 회원가입".text.color(Colors.white).make(),
            ),
          ],
        ),
      ),
    );
  }
}
