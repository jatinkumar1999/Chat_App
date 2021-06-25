import 'package:chat/views/signin.dart';
import 'package:chat/views/signup.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  Authenticate({Key key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isloggedIn = true;

  void toogleView() {
    setState(() {
      isloggedIn = !isloggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isloggedIn) {
      return Login(toogleView);
    } else {
      return Register(toogleView);
    }
  }
}
