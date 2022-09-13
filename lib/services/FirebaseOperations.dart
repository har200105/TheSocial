import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/screens/LandingPage/LandingUtils.dart';
import 'package:thesocial/services/Authentication.dart';

class FirebaseOperations extends ChangeNotifier {
  String useremail;
  String username;
  String userimage;
  List<String> listOfUserIds = [];
  String get getUserEmail => useremail;
  String get getUserName => username;
  String get getUserImage => userimage;
  List<String> get getListOfUserIds => listOfUserIds;

  Future uploadUserAvatar(BuildContext context) async {
    var provider = Provider.of<LandingUtils>(context, listen: false);
    UploadTask imageUploadTask;
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('userProfileAvatar/${TimeOfDay.now()}');

    imageUploadTask = imageReference.putFile(provider.getUserAvatar);

    await imageUploadTask.whenComplete(() {
      print('Image uploaded');
    });

    imageReference.getDownloadURL().then((url) {
      print('user profile avatar URL' + url.toString());
      provider.userAvatarUrl = url.toString();
      this.userimage = url.toString();
    });
  }

  Future addUserToCollection(BuildContext context, dynamic data) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
          .set(data);
    } catch (e) {
      print(e.code);
    }
  }

  Future fetchUserProfileInfo(BuildContext context) async {
    print("999999");
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((doc) {
      this.useremail = doc.get('useremail');
      this.username = doc.get('username');
      this.userimage = doc.get('userimage');
      print("usidjsifd");
      print(this.useremail + ' ' + this.username + ' ' + this.userimage);
      notifyListeners();
    });
  }

  Future addPostData(String postId, dynamic data) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteAccount(String userUid) async {
    await FirebaseFirestore.instance.collection('users').doc(userUid).delete();
  }

  Future addLike(BuildContext context, String postId, String subDocId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username': this.username,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': this.userimage,
      'useremail': this.useremail,
      'time': Timestamp.now()
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username': this.username,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': this.userimage,
      'useremail': this.useremail,
      'time': Timestamp.now()
    });
  }

  Future addReward(
      BuildContext context, String rewardUrl, String postId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('rewards')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set({'image': rewardUrl});
  }

  //postId is the caption of post
  Future deletePost(postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  }

  Future followUser(
      String followingUid,
      String followingDocId,
      dynamic followingData,
      String followerUid,
      String followerDocId,
      dynamic followerData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followerUid)
        .set(followerData);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(followerUid)
        .collection('followings')
        .doc(followingUid)
        .set(followingData);

    print('followed!!!');
  }

  Future unFollowUser(String unfollowingUid, String beingUnfollowed) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(beingUnfollowed)
        .collection('followers')
        .doc(unfollowingUid)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(unfollowingUid)
        .collection('followings')
        .doc(beingUnfollowed)
        .delete();
  }

  Future deleteChatMessage(String chatDocUid, String docId) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatDocUid)
        .collection('messages')
        .doc(docId)
        .delete();
  }

  Future addChat(BuildContext context, String profileImage, String username,
      String userUid, String myUid, String message, String chatDocUid) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatDocUid)
        .collection('messages')
        .add({
      'message': message,
      'time': Timestamp.now(),
      'from': myUid,
      'to': userUid
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(myUid)
        .collection('chats')
        .doc(userUid)
        .set({
      'username': username,
      'userimage': profileImage,
      'userid': userUid,
      'chatdocuid': chatDocUid
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('chats')
        .doc(myUid)
        .set({
      'username':
          Provider.of<FirebaseOperations>(context, listen: false).getUserName,
      'userimage':
          Provider.of<FirebaseOperations>(context, listen: false).getUserImage,
      'userid': myUid,
      'chatdocuid': chatDocUid
    });
  }

  Future deleteChatList(String chatDocUid, String myUid, String userUid) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatDocUid)
        .collection('messages')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((QueryDocumentSnapshot documentSnapshot) {
        documentSnapshot.reference.delete();
      });
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(myUid)
        .collection('chats')
        .doc(userUid)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('chats')
        .doc(myUid)
        .delete();
  }

  Future submitChatRoomData(String chatRoomName, dynamic chatRoomData) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomName)
        .set(chatRoomData);
  }
}
