import 'dart:html';

import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final FontStyle? fontStyle;

   CustomText({
     super.key,
     required this.text,
     required this.fontSize,
     this.fontWeight, this.color,
     this.fontStyle
   });

  @override
  Widget build(BuildContext context) {
    return  Text("data");
  }
}
