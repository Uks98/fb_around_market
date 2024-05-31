import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginValidation extends StateNotifier<bool> {
  LoginValidation() : super(false);

  ///이메일을 검증하는 함수입니다
  String? validateEmail(String value) {
    bool isEmptyEmail = value.isEmpty;
    bool isLengthEmail5 = value.length < 5;
    bool isAT = !value.contains("@");
    if (isEmptyEmail) {
      return "이메일을 입력해주세요";
    } else if (isLengthEmail5) {
      return "이메일을 더 길게 작성해주세요";
    } else if (isAT) {
      return "@를 포함한 유효한 이메일을 입력해주세요";
    }
    return null;
  }
  ///비밀번호를 검증하는 함수입니다.
  String? validatePassword(String value){
    bool isEmptyPassword = value.isEmpty;
    bool isLengthPassword5 = value.length < 5;
    if (isEmptyPassword) {
      print("비밀번호를 입력해주세요");
      return "비밀번호를 입력해주세요";
    } else if (isLengthPassword5) {
      return "비밀번호를 더 길게 작성해주세요. ${6 - value.length}자리만 더 입력해주세요";
    }
    return null;
  }

}

final namedProvider = StateNotifierProvider<LoginValidation, bool>((ref) => LoginValidation());

final userCredentialProvider = StateProvider<UserCredential?>((ref) => null);
