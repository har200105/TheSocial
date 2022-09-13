import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/constants/Constantcolors.dart';
import 'package:thesocial/screens/Feed/FeedUtils.dart';
import 'package:thesocial/screens/Feed/FeedServices.dart';
import 'package:thesocial/screens/AltProfile/AltProfile.dart';
import 'package:thesocial/services/Authentication.dart';
import 'package:thesocial/services/FirebaseOperations.dart';
import 'package:thesocial/utils/TimeAgo.dart';
import 'package:thesocial/utils/PostOptions.dart';
import 'package:thesocial/widgets/GlobalWidgets.dart';

class FeedHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 100),
        child: Container(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 8.0,
            right: 8.0,
            bottom: 60,
          ),
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: SizedBox(
                  height: 500,
                  width: 400,
                  child: Lottie.asset('assets/animations/loading.json'),
                ));
              } else {
                return ListView(
                  children: snapshot.data.docs
                      .map<Widget>((DocumentSnapshot documentSnapshot) {
                    Provider.of<TimeAgo>(context, listen: false)
                        .showTimeGo(documentSnapshot.get('time'));
                    return Container(
                      margin: EdgeInsets.only(bottom: 40),
                      //  height: MediaQuery.of(context).size.height * 0.69,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    documentSnapshot.get('userimage') ??
                                        "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=100",
                                  ),
                                  radius: 20.0,
                                ),
                                onTap: () {
                                  var uidFromDB =
                                      documentSnapshot.get('useruid');
                                  if (uidFromDB !=
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid) {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                          child: AltProfile(userUid: uidFromDB),
                                          type: PageTransitionType.leftToRight,
                                        ));
                                  }
                                },
                              ),
                              SizedBox(width: 10),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          3 /
                                          4,
                                      child: Text(
                                        documentSnapshot.get('caption'),
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          documentSnapshot.get('username') +
                                              ' , ',
                                          style: TextStyle(
                                              color: constantColors.blueColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${Provider.of<TimeAgo>(context, listen: false).getImageTimePosted.toString()}',
                                          style: TextStyle(
                                            color: constantColors.lightColor
                                                .withOpacity(0.99),
                                            fontSize: 12,
                                          ),
                                        ),
                                        //Spacer(),
                                        SizedBox(width: 80),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          //displaying the post image
                          Container(
                            height: MediaQuery.of(context).size.height * 0.46,
                            width: MediaQuery.of(context).size.width,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Image.network(
                                documentSnapshot.get('postimage'),
                                scale: 2,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          //row of button for like,comment,reward
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      child: Icon(
                                        FontAwesomeIcons.heart,
                                        color: constantColors.redColor,
                                      ),
                                      onTap: () {
                                        print('Adding Like ....');
                                        Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false,
                                        )
                                            .addLike(
                                          context,
                                          documentSnapshot.get('caption'),
                                          Provider.of<Authentication>(
                                            context,
                                            listen: false,
                                          ).getUserUid,
                                        )
                                            .whenComplete(() {
                                          likeSheet(context, documentSnapshot);
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 7),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(documentSnapshot.get('caption'))
                                          .collection('likes')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            // child: CircularProgressIndicator(),
                                            height: 0,
                                            width: 0,
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data.docs.length
                                                .toString(),
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                            ),
                                          );
                                        }
                                      }),
                                ],
                              ),
                              SizedBox(width: 15),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      child: Icon(
                                        FontAwesomeIcons.comment,
                                        color: constantColors.blueColor,
                                      ),
                                      onTap: () {
                                        commentSheet(context, documentSnapshot,
                                            documentSnapshot.get('caption'));
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 7),
                                  //number of comments
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(documentSnapshot.get('caption'))
                                          .collection('comments')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            // child: CircularProgressIndicator(),
                                            height: 0,
                                            width: 0,
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data.docs.length
                                                .toString(),
                                            style: TextStyle(
                                                color:
                                                    constantColors.whiteColor),
                                          );
                                        }
                                      }),
                                ],
                              ),
                              SizedBox(width: 15),

                              Spacer(),
                              //conditional tree dots
                              documentSnapshot.get('useruid') ==
                                      Provider.of<Authentication>(context)
                                          .getUserUid
                                  ? IconButton(
                                      icon: Icon(EvaIcons.moreVertical),
                                      color: constantColors.whiteColor,
                                      onPressed: () {
                                        Provider.of<PostOptions>(context,
                                                listen: false)
                                            .showPostOptions(
                                                context,
                                                documentSnapshot
                                                    .get('caption'));
                                      },
                                    )
                                  : Container(
                                      height: 0,
                                      width: 0,
                                    )
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Provider.of<FeedUtils>(context, listen: false)
                            .pickPostImage(context, ImageSource.camera)
                            .whenComplete(() {
                          Provider.of<FeedServices>(context, listen: false)
                              .showPostImage(context);
                        });
                      },
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Provider.of<FeedUtils>(context, listen: false)
                            .pickPostImage(context, ImageSource.gallery)
                            .whenComplete(() {
                          Provider.of<FeedServices>(context, listen: false)
                              .showPostImage(context);
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

//docId is the caption for each post
  //snapshoto is the snapshot we are getting for each post from feedbody
  Future commentSheet(
      BuildContext context, DocumentSnapshot snapshoto, String docId) {
    TextEditingController _commentController = TextEditingController();
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(docId)
                        .collection('comments')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return SingleChildScrollView(
                            //shrinkWrap: true,
                            child: Padding(
                          padding: const EdgeInsets.only(bottom: 100.0),
                          child: Column(
                            children: snapshot.data.docs.map<Widget>(
                                (DocumentSnapshot documentSnapshot) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 10),
                                        GestureDetector(
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              documentSnapshot
                                                      .get('userimage') ??
                                                  "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=100",
                                            ),
                                            radius: 15,
                                          ),
                                          onTap: () {
                                            if (documentSnapshot
                                                    .get('useruid') !=
                                                Provider.of<Authentication>(
                                                        context,
                                                        listen: false)
                                                    .getUserUid) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                    child: AltProfile(
                                                      userUid: documentSnapshot
                                                          .get('useruid'),
                                                    ),
                                                    type: PageTransitionType
                                                        .leftToRight,
                                                  ));
                                            }
                                            return;
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => AltProfile(
                                                        userUid: documentSnapshot
                                                            .get('useruid'))));
                                          },
                                          child: Text(
                                            documentSnapshot.get('username'),
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(children: [
                                      Icon(
                                        Icons.keyboard_arrow_right,
                                        color: constantColors.blueColor,
                                      ),
                                      Text(documentSnapshot.get('comment'),
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                          ))
                                    ]),
                                    SizedBox(height: 10)
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ));
                      }
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    color: constantColors.darkColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 45.0,
                          width: 300.0,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: constantColors.greenColor,
                                      width: 1.0),
                                ),
                                hintText: 'Add Comment...',
                                hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                            controller: _commentController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                            backgroundColor: constantColors.greenColor,
                            child: Icon(FontAwesomeIcons.comment,
                                color: constantColors.whiteColor),
                            onPressed: () {
                              print('adding comment');
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .addComment(
                                context,
                                snapshoto.get('caption'),
                                _commentController.text,
                              )
                                  .whenComplete(() {
                                _commentController.text = '';
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              });
                            })
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future likeSheet(BuildContext context, DocumentSnapshot snapshot) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(snapshot.get('caption'))
                        .collection('likes')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return SingleChildScrollView(
                            //shrinkWrap: true,
                            child: Column(
                          children: snapshot.data.docs
                              .map<Widget>((DocumentSnapshot documentSnapshot) {
                            return Center(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 0.95,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 5),
                                        GestureDetector(
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              documentSnapshot
                                                      .get('userimage') ??
                                                  "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=100",
                                            ),
                                            radius: 20,
                                          ),
                                          onTap: () {
                                            if (documentSnapshot
                                                    .get('useruid') !=
                                                Provider.of<Authentication>(
                                                        context,
                                                        listen: false)
                                                    .getUserUid) {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    child: AltProfile(
                                                        userUid:
                                                            documentSnapshot
                                                                .get(
                                                                    'useruid')),
                                                    type: PageTransitionType
                                                        .leftToRight,
                                                  ));
                                            }
                                            return;
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          children: [
                                            Text(
                                              documentSnapshot.get('username'),
                                              style: TextStyle(
                                                color: constantColors.blueColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              documentSnapshot.get('useremail'),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        //conditional follow button
                                        documentSnapshot.get('useruid') !=
                                                Provider.of<Authentication>(
                                                  context,
                                                  listen: false,
                                                ).getUserUid
                                            ? Provider.of<GlobalWidgets>(
                                                    context,
                                                    listen: false)
                                                .conditionalFollowButtons(
                                                context,
                                                documentSnapshot,
                                                documentSnapshot.get('useruid'),
                                              )
                                            : Container(
                                                width: 0,
                                                height: 0,
                                              )
                                      ],
                                    ),
                                    SizedBox(height: 10)
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ));
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future rewardSheet(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('rewards')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs
                              .map<Widget>((DocumentSnapshot documentSnapshot) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Image.network(
                                      documentSnapshot.get('image')),
                                ),
                                onTap: () {
                                  print('adding the reward');
                                  Provider.of<FirebaseOperations>(context,
                                          listen: false)
                                      .addReward(
                                          context,
                                          documentSnapshot.get('image'),
                                          postId);
                                },
                              ),
                            );
                          }).toList(),
                        );
                      }
                    }),
              ],
            ),
          );
        });
  }
}

Widget followButton(ConstantColors constantColors) {
  return MaterialButton(
    child: Text(
      'Follow',
      style: TextStyle(
          color: constantColors.whiteColor, fontWeight: FontWeight.bold),
    ),
    color: constantColors.blueColor,
    onPressed: () {},
  );
}
