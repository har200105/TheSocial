import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/Chat/Chat.dart';
import 'package:thesocial/services/Authentication.dart';
import 'package:thesocial/services/FirebaseOperations.dart';
import 'package:thesocial/widgets/GlobalWidgets.dart';

class AltProfileHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget headerAltProfile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String userUid) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.37,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 200,
                  width: 180,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: CircleAvatar(
                          backgroundColor: constantColors.transperant,
                          radius: 60,
                          backgroundImage: NetworkImage(snapshot.data
                                  .get('userimage') ??
                              "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=100"),
                        ),
                        onTap: () {},
                      ),
                      SizedBox(height: 5),
                      Text(
                        snapshot.data.get('username'),
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            EvaIcons.email,
                            color: constantColors.greenColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            snapshot.data.get('useremail'),
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userUid)
                                  .collection('followers')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return GestureDetector(
                                    child: profileDetailBox('Followers',
                                        snapshot.data.docs.length.toString()),
                                    onTap: () {
                                      Provider.of<GlobalWidgets>(context,
                                              listen: false)
                                          .showFollowingsSheet(
                                              context, snapshot);
                                    },
                                  );
                                }
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userUid)
                                  .collection('followings')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return GestureDetector(
                                      child: profileDetailBox('Followings',
                                          snapshot.data.docs.length.toString()),
                                      onTap: () {
                                        Provider.of<GlobalWidgets>(context,
                                                listen: false)
                                            .showFollowingsSheet(
                                                context, snapshot);
                                      });
                                }
                              }),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .where("useruid", isEqualTo: userUid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return GestureDetector(
                                      child: profileDetailBox('Posts',
                                          snapshot.data.docs.length.toString()),
                                      onTap: () {},
                                    );
                                  }
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Provider.of<GlobalWidgets>(context, listen: false)
                    .conditionalFollowButtons(
                  context,
                  snapshot,
                  userUid,
                ),
                MaterialButton(
                  color: constantColors.blueColor,
                  child: Text(
                    'Message',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                          child: Chat(
                            profileImage: snapshot.data.get('userimage'),
                            username: snapshot.data.get('username'),
                            userUid: userUid,
                            myUid: Provider.of<Authentication>(
                              context,
                              listen: false,
                            ).getUserUid,
                          ),
                          type: PageTransitionType.leftToRight,
                        ));
                  },
                ),
              ],
            )
          ],
        ));
  }

  Widget divider(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Divider(
          thickness: 3,
          color: constantColors.whiteColor.withOpacity(0.2),
        ),
      ),
    );
  }

  Widget footerProfile(BuildContext context, String userUid) {
    return Provider.of<GlobalWidgets>(context, listen: false)
        .postGrid(context, userUid);
  }

  Widget profileDetailBox(String title, String value) {
    return Container(
      height: 70,
      width: 80,
      decoration: BoxDecoration(
          color: constantColors.darkColor,
          borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$title',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
