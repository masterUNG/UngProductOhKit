import 'package:flutter/material.dart';

class MyStyle {
  List<Color> primaryColors = [
    Colors.limeAccent.shade700,
    Colors.purple.shade600,
  ];

  Widget showProgress() {
    return Center(child: CircularProgressIndicator(),);
  }

  MyStyle();
}
