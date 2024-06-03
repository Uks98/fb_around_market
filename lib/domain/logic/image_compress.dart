

import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ComplexImageLogicBox{
Future<Uint8List> imageCompressList(Uint8List img) async {
  var result = await FlutterImageCompress.compressWithList(img, quality: 50);
  return result;
}

}