import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/HomePage/HomePage.dart';
import 'package:thesocial/services/Authentication.dart';
import 'package:thesocial/services/FirebaseOperations.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessagingHelper with ChangeNotifier {
  bool hasMemberJoined = false;
  String lastMsg;
  String get getLastMsg => lastMsg;
  bool get getHasMember => hasMemberJoined;

  leaveGroup(BuildContext context, String chatRoomname) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ConstantColors().darkColor,
            title: Text(
              'Leave $chatRoomname',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              MaterialButton(
                onPressed: () {},
                child: Text(
                  "No",
                  style: TextStyle(
                      color: ConstantColors().whiteColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(chatRoomname)
                      .collection("members")
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserUid)
                      .delete()
                      .whenComplete(() {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  });
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                      color: ConstantColors().whiteColor,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        });
  }

  showMessages(
      BuildContext context, DocumentSnapshot snapshot, String adminUserUid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(snapshot.id)
          .collection("messages")
          .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView(
            reverse: true,
            children: snapshot.data.docs.map((DocumentSnapshot e) {
              showLastMessage(e['time']);
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: e['message'] != null
                          ? MediaQuery.of(context).size.height * 0.125
                          : MediaQuery.of(context).size.height * 0.2,
                      child: Stack(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 60.0, top: 30.0),
                            child: Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      maxHeight: e['message'] != null
                                          ? MediaQuery.of(context).size.height *
                                              0.11
                                          : MediaQuery.of(context).size.height *
                                              0.42,
                                      maxWidth: e['message'] != null
                                          ? MediaQuery.of(context).size.height *
                                              0.81
                                          : MediaQuery.of(context).size.height *
                                              0.92),
                                  decoration: BoxDecoration(
                                    color: Provider.of<Authentication>(context,
                                                    listen: false)
                                                .getUserUid ==
                                            e['useruid']
                                        ? ConstantColors()
                                            .blueGreyColor
                                            .withOpacity(0.4)
                                        : ConstantColors().blueGreyColor,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 150.0,
                                          child: Row(
                                            children: [
                                              Text(
                                                e['username'] ?? "",
                                                style: TextStyle(
                                                    color: ConstantColors()
                                                        .greenColor,
                                                    fontSize: 10.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      e['message'] != null
                                          ? Text(
                                              e['message'] ?? "",
                                              style: TextStyle(
                                                  color: ConstantColors()
                                                      .whiteColor,
                                                  fontSize: 14.0),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Container(
                                                width: 100.0,
                                                height: 110.0,
                                                child:
                                                    Image.network(e['sticker']),
                                              ),
                                            ),
                                      Container(
                                        width: 40.0,
                                        height: 20.0,
                                        child: Text(
                                          getLastMsg,
                                          style: TextStyle(
                                              color:
                                                  ConstantColors().whiteColor,
                                              fontSize: 6.0),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                              left: 20,
                              child: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      e['useruid']
                                  ? Container(
                                      width: 0.0,
                                      height: 0.0,
                                    )
                                  : CircleAvatar(
                                      backgroundColor:
                                          ConstantColors().darkColor,
                                      backgroundImage: NetworkImage(e[
                                              'userimage'] ??
                                          "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=100"),
                                    ))
                        ],
                      )),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  sendMessage(BuildContext context, DocumentSnapshot snapshot,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(snapshot.id)
        .collection("messages")
        .add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'username':
          Provider.of<FirebaseOperations>(context, listen: false).getUserName,
      'userimage':
          Provider.of<FirebaseOperations>(context, listen: false).getUserImage
    });
  }

  Future checkIfJoined(
      BuildContext context, String chatRoomName, String chatRoomAdminId) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .collection("members")
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((value) {
      hasMemberJoined = false;
      if (value.data()['joined'] != null) {
        hasMemberJoined = value.data()['joined'];
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserUid ==
          chatRoomAdminId) {
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  askToJoin(BuildContext context, String roomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ConstantColors().darkColor,
            title: Text(
              'Join $roomName',
              style: TextStyle(
                color: ConstantColors().whiteColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              MaterialButton(
                color: ConstantColors().blueColor,
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(roomName)
                      .collection("members")
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserUid)
                      .set({
                    'joined': true,
                    'username':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getUserName,
                    'userimage':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getUserImage,
                    'useremail':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getUserEmail,
                    'useruid':
                        Provider.of<Authentication>(context, listen: false)
                            .getUserUid,
                    'time': Timestamp.now()
                  }).whenComplete(() => {Navigator.pop(context)});
                },
                child: Text(
                  "Yes",
                  style: TextStyle(),
                ),
              )
            ],
          );
        });
  }

  showSticker(BuildContext context, String chatRoomId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(
                    thickness: 4,
                    color: ConstantColors().whiteColor,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.blue)),
                        height: 30.0,
                        width: 30.0,
                        // child: Image.asset("sunflower"),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("stickers")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          children: snapshot.data.docs.map((e) {
                            return GestureDetector(
                              onTap: () {
                                sendStickers(context, e['image'], chatRoomId);
                              },
                              child: Image.network(e['image']),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ConstantColors().darkColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  sendStickers(BuildContext context, String imageUrl, String chatRoomId) async {
    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .add({
      'sticker': imageUrl,
      'username':
          Provider.of<FirebaseOperations>(context, listen: false).getUserName,
      'userimage':
          Provider.of<FirebaseOperations>(context, listen: false).getUserImage,
      'time': Timestamp.now()
    });
  }

  showLastMessage(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMsg = timeago.format(dateTime);
    notifyListeners();
  }
}
