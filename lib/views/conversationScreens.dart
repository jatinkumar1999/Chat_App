import 'package:chat/helper/constant.dart';
import 'package:chat/services/database.dart';
import 'package:chat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId, username;
  ConversationScreen(this.chatRoomId, this.username);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageTextEditingController = TextEditingController();
  Stream chatMessageStream;
  Widget chatMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(bottom: 100),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (contex, index) {
                  return SingleChildScrollView(
                    child: GestureDetector(
                      onDoubleTap: () {
                        DatabaseMethods().updatemessage(
                            widget.chatRoomId,
                            snapshot.data.docs[index].id,
                            messageTextEditingController.text);
                        messageTextEditingController.clear();
                      },
                      onLongPress: () {
                        DatabaseMethods().deletemessage(
                          widget.chatRoomId,
                          snapshot.data.docs[index].id,
                        );
                      },
                      child: MessageTile(
                        snapshot.data.docs[index].data()['message'],
                        snapshot.data.docs[index].data()['sendBy'] ==
                            Constant.myName,
                        snapshot.data.docs[index].id,
                        widget.username,
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: Colors.indigo[200],
              );
      },
    );
  }

  sendMessage() {
    if (messageTextEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageTextEditingController.text,
        'sendBy': Constant.myName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseMethods().addConversationMessage(widget.chatRoomId, messageMap);
    }
  }

  @override
  void initState() {
    DatabaseMethods().showConversationMessage(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[400],
          title: Text(widget.username),
        ),
        body: Container(
          child: Stack(
            children: [
              chatMessageList(),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      colors: [
                        Colors.indigo[200],
                        Colors.white,
                        Colors.indigo[200],
                      ],
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: messageTextEditingController,
                        decoration: InputDecoration(
                            hintText: "Send message....",
                            hintStyle: TextStyle(color: Colors.white),
                            focusColor: Colors.white,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            )),
                        style: textStyle(),
                      )),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                          messageTextEditingController.clear();
                        },
                        child: Container(
                          width: 50,
                          height: 60,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.green[200]),
                          child: Image.asset(
                            'assets/send.png',
                            width: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String userID;
  final String userName;
  MessageTile(this.message, this.sendByMe, this.userID, this.userName);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: sendByMe ? 25.0 : 0,
        right: sendByMe ? 0 : 25.0,
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: sendByMe
                  ? [
                      Colors.indigo[200],
                      Colors.indigo[50],
                    ]
                  : [
                      Colors.grey[400],
                      Colors.grey[600],
                    ],
            ),
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23.0),
                    topRight: Radius.circular(23.0),
                    bottomLeft: Radius.circular(23.0),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(23.0),
                    topRight: Radius.circular(23.0),
                    bottomRight: Radius.circular(23.0),
                  ),
          ),
          child: Column(
            children: [
              Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              ),
            ],
          )),
    );
  }
}
