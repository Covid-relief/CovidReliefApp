import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';

/**
 * Aqui basicamente hacemos un widget para mostrar la imagen
 */
Widget imageUp (sampleImage){
  if (sampleImage!=null){
    return Image.file(sampleImage);
  }else{
    return SizedBox();
  }
}
