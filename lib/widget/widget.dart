import 'package:flutter/material.dart';

Widget appbarmain(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.indigo[300],
    title: Image(
      image: AssetImage('assets/appbar.png'),
      height: 50.0,
    ),
  );
}

InputDecoration inputDecoration(String hinttext, icon) {
  return InputDecoration(
    hintText: hinttext,
    hintStyle: TextStyle(
      color: Colors.black26,
    ),
    prefixIcon: Icon(
      icon,
      color: Colors.grey[600],
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey[300],
      ),
    ),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300])),
  );
}

TextStyle textStyle() {
  return TextStyle(
    color: Colors.white,
  );
}
