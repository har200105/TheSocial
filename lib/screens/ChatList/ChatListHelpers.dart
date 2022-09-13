import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/Chat/Chat.dart';
import 'package:thesocial/services/Authentication.dart';
import 'package:thesocial/services/FirebaseOperations.dart';

class ChatListHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget chatListItems(BuildContext context) {
    return ListView(
      children: [
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(Provider.of<Authentication>(context, listen: false)
                    .getUserUid)
                .collection('chats')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                    children: snapshot.data.docs
                        .map<Widget>((DocumentSnapshot documentSnapshot) {
                  return GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          color: constantColors.blueGreyColor,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: ListTile(
                        title: Text(
                          documentSnapshot.get('username'),
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(documentSnapshot
                                  .get('userimage') ??
                              "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=100"),
                          radius: 25,
                          backgroundColor: constantColors.redColor,
                        ),
                        trailing: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.trash,
                              color: constantColors.redColor,
                            ),
                            onPressed: () {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .deleteChatList(
                                      documentSnapshot.get('chatdocuid'),
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid,
                                      documentSnapshot.get('userid'))
                                  .whenComplete(() {
                                print('chat list deleted');
                              });
                            }),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                            child: Chat(
                              profileImage: documentSnapshot.get('userimage'),
                              username: documentSnapshot.get('username'),
                              userUid: documentSnapshot.get('userid'),
                              myUid: Provider.of<Authentication>(
                                context,
                                listen: false,
                              ).getUserUid,
                            ),
                            type: PageTransitionType.leftToRight,
                          ));
                    },
                  );
                }).toList());
              }
            })
      ],
    );
  }
}
