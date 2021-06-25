import 'package:chat/helper/authenticate.dart';
import 'package:chat/helper/constant.dart';
import 'package:chat/helper/helperfunction.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:chat/views/conversationScreens.dart';
import 'package:chat/views/search.dart';
import 'package:chat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  ChatRoomScreen({Key key}) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  Stream chatRoomStream;
  Widget chatRoomList() {
    return StreamBuilder<QuerySnapshot>(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child: GestureDetector(
                        onLongPress: () {
                          var id = DatabaseMethods().deleteRoomid(
                            snapshot.data.docs[index].data()['chatRoomId'],
                          );
                          print(id);
                          DatabaseMethods().deleteRoom(
                              snapshot.data.docs[index].data()['chatRoomId'],
                              id);
                        },
                        child: ChatRoomTile(
                          snapshot.data.docs[index]
                              .data()['chatRoomId']
                              .toString()
                              .replaceAll('_', '')
                              .replaceAll(Constant.myName, ''),
                          snapshot.data.docs[index].data()['chatRoomId'],
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  getUserInfo() async {
    Constant.myName = await HelperFunction.getUserNameSharedPreference();
    DatabaseMethods().getChatroom(Constant.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[200],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Image(
          height: 50.0,
          image: AssetImage('assets/appbar.png'),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              AuthServices().signout().then((value) {
                HelperFunction.savedUserLoggedInSharedPreference(false);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              });
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ),
          );
        },
        child: Icon(
          Icons.search,
          size: 30.0,
        ),
      ),
      body: chatRoomList(),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName, id;
  ChatRoomTile(this.userName, this.id);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(id, userName),
          ),
        );
      },
      child: Material(
        elevation: 10.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.indigo[100],
          ),
          child: Row(
            children: [
              Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  alignment: Alignment.center,
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[500],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    '${userName.substring(0, 1).toUpperCase()} ',
                    style: textStyle(),
                  )),
              SizedBox(
                width: 5.0,
              ),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
