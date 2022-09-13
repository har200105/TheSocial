import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/ChatRoom/ChatRoomHelper.dart';
import 'package:thesocial/constants/Constantcolors.dart';

import '../screens/HomePage/HomePage.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.blueColor,
        child: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          Provider.of<ChatRoomHelper>(context, listen: false)
              .showCreatedChatRoom(context);
        },
      ),
      appBar: AppBar(
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: constantColors.whiteColor,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: HomePage(), type: PageTransitionType.leftToRight));
          },
        ),
        title: Text("Group Chats"),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
              0.5,
              0.9
            ],
                colors: [
              constantColors.darkColor,
              constantColors.blueGreyColor
            ])),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Provider.of<ChatRoomHelper>(context, listen: false)
            .showChatroom(context),
      ),
    );
  }
}
