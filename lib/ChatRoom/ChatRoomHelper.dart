import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/Message/GroupMessage.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/AltProfile/AltProfile.dart';
import 'package:thesocial/services/Authentication.dart';
import 'package:thesocial/services/FirebaseOperations.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatRoomHelper with ChangeNotifier {
  String chatRoomAvatarUrl;
  String chatRoomId;
  String get getChatRoomId => chatRoomId;
  String get getChatRoomAvatarUrl => chatRoomAvatarUrl;
  String latestTime;
  String get getlastestTime => latestTime;
  TextEditingController chat = TextEditingController();

  showChatRoomDetails(BuildContext context, DocumentSnapshot snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: ConstantColors().blueGreyColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    color: ConstantColors().whiteColor,
                    thickness: 4.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: ConstantColors().blueColor),
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Members",
                        style: TextStyle(
                            color: ConstantColors().whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(snapshot.id)
                        .collection("members")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              snapshot.data.docs.map((DocumentSnapshot e) {
                            return GestureDetector(
                              onTap: () {
                                if (Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid !=
                                    e['useruid']) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AltProfile(
                                                userUid: e['useruid'],
                                              )));
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: ConstantColors().darkColor,
                                radius: 25.0,
                                backgroundImage: NetworkImage(e['userimage'] ??
                                    "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=100"),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: ConstantColors().blueColor),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Text(
                    "Admin",
                    style: TextStyle(
                        color: ConstantColors().whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: ConstantColors().transperant,
                        backgroundImage: NetworkImage(snapshot['userimage'] ??
                            "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=100"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot['username'],
                          style: TextStyle(
                              color: ConstantColors().whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  showCreatedChatRoom(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      color: ConstantColors().whiteColor,
                      thickness: 4.0,
                    ),
                  ),
                  // Text(
                  //   "Select ChatRoom Avatar",
                  //   style: TextStyle(
                  //       color: ConstantColors().greenColor,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 14.0),
                  // ),
                  // Container(
                  //   height: MediaQuery.of(context).size.height * 0.1,
                  //   width: MediaQuery.of(context).size.width,
                  //   child: StreamBuilder<QuerySnapshot>(
                  //     stream: FirebaseFirestore.instance
                  //         .collection("chatRoomIcons")
                  //         .snapshots(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       } else {
                  //         return ListView(
                  //           scrollDirection: Axis.horizontal,
                  //           children:
                  //               snapshot.data.docs.map((DocumentSnapshot e) {
                  //             return GestureDetector(
                  //               onTap: () {
                  //                 chatRoomAvatarUrl = e['image'];
                  //                 notifyListeners();
                  //               },
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     border: Border.all(
                  //                         color: chatRoomAvatarUrl == e['image']
                  //                             ? ConstantColors().blueColor
                  //                             : Colors.transparent),
                  //                   ),
                  //                   height: 10.0,
                  //                   width: 40.0,
                  //                   child: Image.network(e['image']),
                  //                 ),
                  //               ),
                  //             );
                  //           }).toList(),
                  //         );
                  //       }
                  //     },
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          controller: chat,
                          style: TextStyle(
                              color: ConstantColors().whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                          decoration: InputDecoration(
                            hintText: 'Enter ChatRoom ID',
                            hintStyle: TextStyle(
                                color: ConstantColors().whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .submitChatRoomData(chat.text, {
                            // 'roomavatar': getChatRoomAvatarUrl,
                            'time': Timestamp.now(),
                            'roomname': chat.text,
                            'username': Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getUserName,
                            'userimage': Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .getUserImage,
                            'useremail': Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .getUserEmail,
                            'useruid': Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid
                          }).whenComplete(() => {Navigator.pop(context)});
                        },
                        backgroundColor: ConstantColors().blueGreyColor,
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: ConstantColors().yellowColor,
                        ),
                      )
                    ],
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: ConstantColors().darkColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
            ),
          );
        });
  }

  showChatroom(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("chatrooms").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 200.0,
              width: 200.0,
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: new ListView(
                children: snapshot.data.docs.map<Widget>((DocumentSnapshot e) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.5, 0.9],
                            colors: [Colors.yellow, Colors.cyan])),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GroupMessage(documentSnapshot: e)));
                        },
                        onLongPress: () {
                          showChatRoomDetails(context, e);
                        },
                        title: Text(
                          e['roomname'],
                          style: TextStyle(
                              color: ConstantColors().whiteColor,
                              fontSize: 16.0),
                        ),

                        // trailing: Container(
                        //   width: 0,
                        //   child: StreamBuilder<QuerySnapshot>(
                        //     stream: FirebaseFirestore.instance
                        //         .collection("chatrooms")
                        //         .doc(e.id)
                        //          .collection("messages")
                        //         .orderBy("time", descending: true)
                        //         .snapshots(),
                        //         builder: (context,snapshot){
                        //               showLastMessageTime(snapshot.data.docs.first['time']);
                        //             if (snapshot.connectionState == ConnectionState.waiting) {
                        //       return Center(
                        //         child: CircularProgressIndicator(),
                        //       );
                        //     }else{
                        //       return Text(getlastestTime,style: TextStyle(
                        //         color: Colors.white
                        //       ),);
                        //     }
                        //         },
                        //   ),
                        // ),
                        // subtitle: StreamBuilder<QuerySnapshot>(
                        //   stream: FirebaseFirestore.instance
                        //       .collection("chatrooms")
                        //       .doc(e.id)
                        //       .collection("messages")
                        //       .orderBy("time", descending: true)
                        //       .snapshots(),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.connectionState == ConnectionState.waiting) {
                        //       return Center(
                        //         child: CircularProgressIndicator(),
                        //       );
                        //     } else if (snapshot.data.docs.first['username'] != null &&
                        //         snapshot.data.docs.first['message'] != null) {
                        //       return Text(snapshot.data.docs.first['username'] +
                        //           ":" +
                        //           snapshot.data.docs.first['message']);
                        //     } else if (snapshot.data.docs.first['username'] != null &&
                        //         snapshot.data.docs.first['sticker'] != null) {
                        //       return Text(snapshot.data.docs.first['username'] +
                        //           ":" +
                        //           "Sticker");
                        //     } else {
                        //       return Container(
                        //         height: 0,
                        //         width: 0,
                        //       );
                        //     }
                        //   },
                        // ),
                        // leading: CircleAvatar(
                        //   backgroundColor: ConstantColors().transperant,
                        //   backgroundImage: NetworkImage(e['roomavatar']),
                        // ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    latestTime = timeago.format(dateTime);
    notifyListeners();
  }
}
