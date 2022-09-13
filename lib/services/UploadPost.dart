import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/screens/Feed/FeedUtils.dart';

class UploadPost extends ChangeNotifier {
  Future uploadPostImageToFirebase(BuildContext context) async {
    final provider = Provider.of<FeedUtils>(context, listen: false);

    UploadTask imageUploadTask;
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('userPostImage/${TimeOfDay.now()}');

    imageUploadTask = imageReference.putFile(provider.getPostImage);

    await imageUploadTask.whenComplete(() {
      print('Image uploaded');
    });

    imageReference.getDownloadURL().then((url) {
      provider.postImageUrl = url.toString();
      print('user post image URL' + provider.postImageUrl);
    });
  }
}
