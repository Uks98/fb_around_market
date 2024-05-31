

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLodeWidget{
  static Center loadingWidget() {
    return Center(
      child: LoadingAnimationWidget.inkDrop(
        color: Colors.black,
        size: 100,
      ),
    );
  }
}


