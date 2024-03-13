import 'package:fb_around_market/login/signup/s_signup_seq2_password.dart';
import 'package:fb_around_market/size_valiable/utill_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpAddNamePage extends ConsumerWidget{
  SignUpAddNamePage({super.key, this.userProfile});
  final String? userProfile;
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    print(userProfile);
    TextEditingController _idController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeightBox(30),
              "이메일을를 입력하세요"
                  .text
                  .fontWeight(FontWeight.w700)
                  .size(bigFontSize + 10)
                  .make()
                  .pOnly(left: 20),
              const HeightBox(160),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "이메일을 입력해주세요";
                      }else if(value.length < 5){
                        return "이메일을 더 길게 작성해주세요";
                      }else if( !value.contains("@")){
                        return "@를 포함한 유효한 이메일을 입력해주세요";
                      }
                      return null;
                    },
                    controller: _idController,
                   style: TextStyle(fontSize: bigFontSize + 5),
                   autofocus: true,
                   cursorColor: Colors.grey,
                   decoration: const InputDecoration(
                     hintText: "이메일 입력",
                     border: InputBorder.none,
                     focusedBorder: InputBorder.none,
                     enabledBorder: InputBorder.none,
                     errorBorder: InputBorder.none,
                     disabledBorder: InputBorder.none,
                   ),
                                 ).pOnly(left: 15,right: 10),
                ),
                 const HeightBox(20),
                 "스트릿 푸드 파인더에서 고유한 이메일을 만드세요 \n한번 만들면 변경할 수 없어요.".text.color(Colors.grey[700]).size(smallFontSize).make().pOnly(left: 15)
                             ],
                           ),
              const HeightBox(150),
              Center(child: ElevatedButton(onPressed: () async{
                if(_formKey.currentState!.validate()){
                  _formKey.currentState!.save();
                if(context.mounted){
                   String id = await ref.watch(userId);
                   id = _idController.text;
                  context.goNamed("password",
                      pathParameters: {
                    "userId" : id,
                    "userImage":userProfile ?? "",});
                }
                }

                //context.go("/signUp/password");
              }, child: "다음".text.make()))
            ],
          ),
        ),
      ),
    );
  }
}
