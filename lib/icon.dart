import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class icon extends StatefulWidget {
  icon({Key key}) : super(key: key);

  @override
  _iconState createState() => _iconState();
}

class _iconState extends State<icon> {
  bool clicked = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextFormField(
        obscureText: clicked,
        decoration: InputDecoration(
          suffixIcon: clicked
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      clicked = false;
                      print(clicked);
                    });
                  },
                  child: Icon(
                    FontAwesomeIcons.eyeSlash,
                    color: Colors.indigo[400],
                  ))
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      clicked = true;
                    });
                  },
                  child: Icon(
                    FontAwesomeIcons.eye,
                    color: Colors.indigo[400],
                  )),
        ),
      )),
    );
  }
}
