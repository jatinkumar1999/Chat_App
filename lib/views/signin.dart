import 'package:chat/helper/helperfunction.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:chat/views/charRoomScreens.dart';
import 'package:chat/views/forgotpassward.dart';
import 'package:chat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  final Function toogle;
  Login(this.toogle);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isloading = false;
  bool clicked = true;
  QuerySnapshot snapshotUserInfo;

  signIn() {
    if (formkey.currentState.validate()) {
      HelperFunction.savedUserEmailSharedPreference(
          emailTextEditingController.text);
      DatabaseMethods()
          .getUserByUserEmail(emailTextEditingController.text)
          .then((value) {
        snapshotUserInfo = value;
        HelperFunction.savedUserNameSharedPreference(
            snapshotUserInfo.docs[0].get('name'));
      });
      setState(() {
        isloading = true;
      });

      AuthServices()
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        if (value != null) {
          HelperFunction.savedUserLoggedInSharedPreference(true);

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ChatRoomScreen()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Scaffold(
            body: Container(
              color: Colors.indigo[300],
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(bottom: 50.0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo[600],
                            Colors.indigo[100],
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100.0),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/logo.png',
                            ),
                          ),
                          Positioned(
                            right: 20,
                            bottom: 10,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 20, right: 20.0, top: 30.0),
                      child: Column(
                        children: [
                          Form(
                            key: formkey,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[300],
                                  ),
                                  child: TextFormField(
                                    decoration:
                                        inputDecoration("email", Icons.email),
                                    controller: emailTextEditingController,
                                    validator: (value) =>
                                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(value)
                                            ? null
                                            : "enter a valid email",
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[300],
                                  ),
                                  child: TextFormField(
                                      obscureText: clicked,
                                      controller: passwordTextEditingController,
                                      validator: (value) => value.length < 6
                                          ? "enter  6+ chars password "
                                          : null,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.vpn_key,
                                          color: Colors.grey[600],
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[300])),
                                        hintText: "password",
                                        hintStyle: TextStyle(
                                          color: Colors.black26,
                                        ),
                                        suffixIcon: clicked
                                            ? GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    clicked = false;
                                                  });
                                                },
                                                child: Icon(
                                                  FontAwesomeIcons.eyeSlash,
                                                  color: Colors.indigo[600],
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    clicked = true;
                                                  });
                                                },
                                                child: Icon(
                                                  FontAwesomeIcons.eye,
                                                  color: Colors.indigo[600],
                                                ),
                                              ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0),
                              alignment: Alignment.centerRight,
                              child: Text(
                                'ForgotPassword ?',
                                style: TextStyle(
                                  color: Colors.indigo[600],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          GestureDetector(
                            onTap: signIn,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                alignment: Alignment.center,
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    gradient: LinearGradient(colors: [
                                      Colors.indigo[600],
                                      Colors.indigo[100],
                                    ])),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  width: 50,
                                  height: 50,
                                  child: Image.asset(
                                    'assets/fb.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  width: 50,
                                  height: 50,
                                  child: Image.asset(
                                    'assets/gg.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Don\'t have an account ? ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                              children: [
                                TextSpan(
                                  text: "Register",
                                  style: TextStyle(
                                    color: Colors.indigo[600],
                                    fontSize: 18.0,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      widget.toogle();
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
