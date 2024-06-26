
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../common/size_valiable/utill_size.dart';
import '../../../../ropository/firs_base_mixin/fire_base_queue.dart';
import '../login_riv_state.dart';
final userId = StateProvider<String>((ref) => "");
class SignUpAddPassWordPage extends ConsumerWidget with FireBaseInitialize {
  String userId;
  String? userImage;

  SignUpAddPassWordPage({super.key, required this.userId, this.userImage});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    TextEditingController passwordController = TextEditingController();
    Future<bool> signUp(String emailAddress, String password) async {
      try {
            await fireBaseAuthInit.createUserWithEmailAndPassword(
                email: emailAddress, password: password);
        //add 대신 set으로 설정해서 docyment id를 user.uid로 변경 후 프로필 사진 불러오기 성공..
        await FirebaseFirestore.instance.collection("users").doc(userId).set({
          "profileImage": userImage,
          "userId": userId,
          "password": passwordController.text,
          "user": userUid,
          "userUid": ""
        });
        //계정이 생성 된 이후 만들어지는 uid를 받아오기 위한 작업
        await firestoreInit.collection("users").doc(userId).update({
              "userUid" : fireBaseAuthInit.currentUser!.uid
            });
        return true;
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("아이디가 취약합니다.")),
          );
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("이미 정보가 존재합니다")),
          );
        }
        return false;
      } catch (e) {
        return false;
      }
    }

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeightBox(30),
              "비밀번호를 입력하세요"
                  .text
                  .fontWeight(FontWeight.w700)
                  .size(bigFontSize + 8)
                  .make()
                  .pOnly(left: 20),
              const HeightBox(160),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: formKey,
                    child: TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        final passwordValidation = ref.read(namedProvider.notifier);
                        passwordValidation.validatePassword(value ?? "");
                      },
                      controller: passwordController,
                      style: TextStyle(fontSize: bigFontSize + 5),
                      autofocus: true,
                      cursorColor: Colors.grey,
                      decoration: const InputDecoration(
                        hintText: "비밀번호 입력",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ).pOnly(left: 15, right: 10),
                  ),
                  const HeightBox(20),
                  "6자 이상의 비밀번호를 입력해주세요."
                      .text
                      .color(Colors.grey[700])
                      .size(smallFontSize)
                      .make()
                      .pOnly(left: 15)
                ],
              ),
              const HeightBox(150),
              Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          if (context.mounted) {
                            final result = await signUp(userId.trim(), passwordController.text.trim());
                            if (result) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("회원가입 성공")),);
                                  signUp(userId, passwordController.text);
                                  context.goNamed("login");
                              }
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("회원가입에 실패했습니다.")),
                            );
                          }
                        }
                      },
                      child: "가입할래요!".text.make()))
            ],
          ),
        ),
      ),
    );
  }
}
