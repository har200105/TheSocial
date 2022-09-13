import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Message/GroupMessageHelper.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/HomePage/HomePage.dart';
import 'package:thesocial/services/Authentication.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const GroupMessage({Key key, @required this.documentSnapshot})
      : super(key: key);

  @override
  _GroupMessageState createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  @override
  void initState() {
    Provider.of<GroupMessagingHelper>(context, listen: false)
        .checkIfJoined(context, widget.documentSnapshot.id,
            widget.documentSnapshot['useruid'])
        .whenComplete(() async {
      if (Provider.of<GroupMessagingHelper>(context, listen: false)
              .getHasMember ==
          false) {
        Timer(
            Duration(milliseconds: 10),
            () => {
                  Provider.of<GroupMessagingHelper>(context, listen: false)
                      .askToJoin(context, widget.documentSnapshot.id)
                });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController c = TextEditingController();
    return Scaffold(
      backgroundColor: ConstantColors().darkColor,
      appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<GroupMessagingHelper>(context, listen: false)
                    .leaveGroup(context, widget.documentSnapshot.id);
              },
              icon: Icon(EvaIcons.logOutOutline),
              color: ConstantColors().redColor,
            ),
            Provider.of<Authentication>(context, listen: false).getUserUid ==
                    widget.documentSnapshot['useruid']
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(EvaIcons.moreVertical),
                    color: Colors.white,
                  )
                : Container(
                    width: 0.0,
                    height: 0.0,
                  )
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          centerTitle: true,
          backgroundColor: ConstantColors().darkColor.withOpacity(0.6),
          title: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.documentSnapshot['roomname'],
                      style: TextStyle(
                          color: ConstantColors().whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("chatrooms")
                          .doc(widget.documentSnapshot.id)
                          .collection("members")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Text(
                            snapshot.data.docs.length.toString() + " Members",
                            style: TextStyle(
                                color: ConstantColors()
                                    .greenColor
                                    .withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0),
                          );
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                child: Provider.of<GroupMessagingHelper>(context, listen: false)
                    .showMessages(context, widget.documentSnapshot,
                        widget.documentSnapshot['useruid']),
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                duration: Duration(seconds: 1),
                curve: Curves.bounceIn,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.77,
                        child: TextField(
                          controller: c,
                          style: TextStyle(
                            color: ConstantColors().whiteColor,
                            fontSize: 16.0,
                          ),
                          decoration: InputDecoration(
                              hintText: 'Type Here.....',
                              hintStyle: TextStyle(color: Colors.white)),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        backgroundColor: ConstantColors().blueColor,
                        onPressed: () {
                          if (c.text != "") {
                            Provider.of<GroupMessagingHelper>(context,
                                    listen: false)
                                .sendMessage(
                                    context, widget.documentSnapshot, c);
                            c.clear();
                          }
                        },
                        child: Icon(Icons.send_sharp,
                            color: ConstantColors().whiteColor),
                      ),
                    )
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
