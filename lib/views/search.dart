import 'package:chat/helper/constant.dart';
import 'package:chat/services/database.dart';
import 'package:chat/views/conversationScreens.dart';
import 'package:chat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;
  initiate() {
    databaseMethods
        .getUserByUserName(searchTextEditingController.text)
        .then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  createChatRoomAndStartConversation({String userName}) {
    String chatRoomId = getChatRoomId(userName, Constant.myName);
    List<String> users = [userName, Constant.myName];
    Map<String, dynamic> chatRoomMap = {
      'users': users,
      'chatRoomId': chatRoomId,
    };
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (conext) => ConversationScreen(chatRoomId, userName),
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot.docs[index].data()['name'],
                userEmail: searchSnapshot.docs[index].data()['email'],
              );
            })
        : Container();
  }

  Widget searchTile({String userName, String userEmail}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.indigo[200],
      ),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 25),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                userEmail,
                style: textStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(userName: userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                'Message',
                style: textStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: appbarmain(context),
      body: Column(
        children: [
          Container(
            color: Colors.indigo[200],
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 18),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: searchTextEditingController,
                  decoration: InputDecoration(
                      hintText: "search userName....",
                      hintStyle: TextStyle(color: Colors.white),
                      focusColor: Colors.white,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      )),
                  style: textStyle(),
                )),
                GestureDetector(
                  onTap: initiate(),
                  child: Container(
                    width: 60,
                    height: 60,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: LinearGradient(colors: [
                          Colors.indigo[100],
                          Colors.indigo[600],
                          Colors.indigo[100],
                        ])),
                    child: Image.asset(
                      'assets/search_white.png',
                      width: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          searchList(),
        ],
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}
