import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/ChatRoom/ChatRoom.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/ChatList/ChatListHelpers.dart';
import 'package:thesocial/services/Authentication.dart';
import 'package:thesocial/screens/Profile/ProfileHelpers.dart';
import 'package:thesocial/screens/LandingPage/LandingPage.dart';

class ChatList extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(icon: Icon(Icons.group,color: Colors.blue),onPressed:(){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChatRoom()));
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
           automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: constantColors.blueGreyColor,
          actions: [
            IconButton(
              icon: Icon(
                EvaIcons.logOutOutline,
                size: 30,
                color: constantColors.greenColor,
              ),
              
              onPressed: () {
                Provider.of<ProfileHelpers>(context, listen: false)
                    .logoutDialog(context);
              },
            )
          ],
          title: RichText(
              text: TextSpan(
                  text: 'Chat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: constantColors.whiteColor,
                  ),
                  children: [
                TextSpan(
                    text: 'List',
                    style: TextStyle(
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0))
              ])),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                padding: EdgeInsets.all(4),
                height: MediaQuery.of(context).size.height * 1.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: constantColors.blueGreyColor.withOpacity(0.6)),
                child: Provider.of<ChatListHelpers>(context, listen: false)
                    .chatListItems(context)),
          ),
        ));
  }
}
