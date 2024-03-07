import 'package:fb_around_market/size_valiable/utill_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpAddPassWordPage extends StatelessWidget {
  SignUpAddPassWordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _passwordController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeightBox(30),
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
                    key: _formKey,
                    child: TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "비밀번호를 입력해주세요";
                        }else if(value.length < 5){
                        }
                        return "비밀번호를 더 길게 작성해주세요. ${6 - value.length}자리만 더 입력해주세요";
                        return null;
                      },
                      controller: _passwordController,
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
                    ).pOnly(left: 15,right: 10),
                  ),
                  const HeightBox(20),
                  "6자 이상의 비밀번호를 입력해주세요.".text.color(Colors.grey[700]).size(smallFontSize).make().pOnly(left: 15)
                ],
              ),
              HeightBox(150),
              Center(child: ElevatedButton(onPressed: () {
                if(_formKey.currentState!.validate()){
                  _formKey.currentState!.save();
                  if(context.mounted){
                   // context.go("/signUp/password");
                  }
                }
              }, child: "다음".text.make()))
            ],
          ),
        ),
      ),
    );
  }
}
