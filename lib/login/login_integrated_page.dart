import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginIntegratedPage extends StatelessWidget {
  const LoginIntegratedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            "찾았다 \n   붕어빵".text.fontWeight(FontWeight.w700).size(50).make()
          ],
        ),
      ),
    );
  }
}
