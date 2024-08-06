

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageDetail extends StatelessWidget {
  const ImageDetail({super.key,required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Image.network(image,fit: BoxFit.contain,),
          ),
        ],
      ),
    );
  }
}
